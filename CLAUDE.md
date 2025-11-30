# HachimiFigure - 二次元插画手办化在线工具

## 产品概述

**产品名称:** HachimiFigure
**域名:** hachimifigure.com
**定位:** 面向二次元用户的在线工具，将插画/表情包转换为高一致性的三维手办摄影风图片

### 核心特点
- 角色一致性控制能力
- 二次元垂直体验
- 风格化范围可控（角色/背景/文字分离控制）

### 本期支持
- 插画到手办风图片（角色立绘、同人图、壁纸、漫画分格、表情包、头像）

### 本期不支持
- 从零文生图
- 真人照片转手办
- 通用图像编辑和滤镜
- 真实三维模型导出

---

## 目标用户

1. **插画与同人创作者** - 生成手办展示图用于展示页、企划书、众筹页
2. **普通二次元爱好者** - 一键转成手办风图片用于头像、签名、社交平台
3. **小型IP团队和周边工作室** - 正式3D打样前快速试角色姿势、场景和包装方案
4. **视频和封面创作者** - 快速生成统一手办风角色图

---

## 技术栈（基于Nexty模板）

**核心框架:**
- Next.js 15.3.0 (App Router)
- React 19 + TypeScript 5
- Tailwind CSS v4 + shadcn/ui

**数据库:** PostgreSQL + Drizzle ORM
**认证:** Better Auth (GitHub, Google, Magic Link)
**支付:** Stripe (订阅 + 一次性支付 + 积分系统)
**存储:** Cloudflare R2
**邮件:** Resend
**i18n:** next-intl (中文为主，英文、日文)

**AI模型调用:**
- OpenRouter API 调用 Nano Banana Pro
- 图像到图像风格化能力

---

## 页面架构（简化版）

### 导航结构
```
Home (首页) - Landing Page，包含轻量体验区
Generate (生成) - 核心功能页
Showcases (案例) - 可选，展示官方示例
Pricing (价格) - 简单定价展示
FAQ - 常见问题
Account (账号) - 登录/注册/设置
```

### 设计决策：单页面 vs 多页面

**推荐方案：Landing Page + Generate Page 双页面结构**

理由：
1. Landing Page 专注转化和品牌展示
2. Generate Page 专注核心功能
3. SEO友好
4. 加载性能更好

---

## 首页模块 (Landing Page)

### 模块一：Hero区域
- 品牌标志：HachimiFigure
- 主标题：把任何二次元插画一键变成手办照片
- 副标题：Ciallo～(∠・ω< )⌒★
- CTA按钮：开始生成 / 查看案例

### 模块二：卖点说明
- 角色高度一致
- 专为二次元插画优化
- 风格化范围可选
- 免费试用 无需登录

### 模块三：轻量体验区
- 简化版上传入口（可直接在首页体验）
- 原图对比生成图展示
- 说明：只风格化角色 / 全图手办化 / 文字保护

### 模块四：精选案例
- 官方示例卡片（原插画 + 手办风结果）

### 模块五：简要FAQ + 页脚

---

## 生成页核心功能 (Generate Page)

### 布局
```
┌─────────────────────────────────────────────┐
│  左侧：上传和参数设置    │  右侧：预览和结果  │
├─────────────────────────────────────────────┤
│  上传框（拖拽/点击）     │  生成结果主图      │
│  支持格式：PNG/JPG/WEBP  │  候选视角切换      │
│                          │  下载/保存按钮     │
│  风格卡片列表            │                    │
│  风格化范围控制          │                    │
│  一致性控制滑杆          │                    │
│  补充描述输入            │                    │
│                          │                    │
│  生成按钮                │                    │
│  积分情况显示            │                    │
└─────────────────────────────────────────────┘
```

### 风格预设（首批5种）
1. **商业手办展示柜** - 玻璃柜+灯条背景
2. **透明亚克力底座** - 简约展台+背景虚化
3. **创作者工作桌** - 桌面+手办摆件+屏幕
4. **舞台光效场景** - 彩色聚光灯+舞台结构
5. **简洁纯色背景展台** - 单色渐变+简约底座

### 风格化范围控制
**角色范围：**
- 只风格化角色（背景保持原图）
- 全图风格化（角色+背景整体手办化）

**背景模式：**
- 保留原背景
- 替换为风格场景

**文本保护：**
- 保护文字（保持可读性）
- 重绘文字（融入手办风格）

### 一致性控制
- 总开关（默认开启）
- 强度滑杆（更自由 ↔ 更严格）
- 锁定角色特征选项（多次生成一致性）

---

## 数据库Schema扩展

### 新增表

```typescript
// 手办风格预设
figureStyles: {
  id: uuid
  name: text (如 "commercial_cabinet")
  displayName: jsonb (多语言 {en, zh, ja})
  description: jsonb (多语言)
  thumbnailUrl: text
  promptTemplate: text (内部提示词模板)
  isActive: boolean
  displayOrder: integer
  createdAt, updatedAt
}

// 生成任务
figureGenerations: {
  id: uuid
  userId: uuid (nullable, 未登录用户为null)
  sessionId: text (未登录用户的临时会话ID)

  // 输入
  originalImageUrl: text
  originalImageHash: text (用于去重和一致性)

  // 参数
  styleId: uuid -> figureStyles
  stylizationScope: enum ('character_only', 'full_image')
  backgroundMode: enum ('keep_original', 'replace_with_scene')
  textProtection: enum ('protect', 'redraw')
  consistencyStrength: integer (0-100)
  lockCharacterFeatures: boolean
  additionalPrompt: text (用户补充描述)

  // 输出
  status: enum ('pending', 'processing', 'completed', 'failed')
  resultImageUrl: text
  alternativeImageUrls: jsonb (候选图数组)

  // 元数据
  creditsUsed: integer
  processingTimeMs: integer
  errorMessage: text

  createdAt, updatedAt
}

// 用户作品库（已登录用户保存的作品）
userGallery: {
  id: uuid
  userId: uuid
  generationId: uuid -> figureGenerations
  isFavorite: boolean
  isPublic: boolean (是否授权展示)
  createdAt
}
```

---

## 积分系统（复用模板）

**复用现有表：**
- `usage` - 积分余额
- `creditLogs` - 积分变动记录
- `pricingPlans` - 套餐定义
- `subscriptions` - 订阅状态
- `orders` - 订单记录

**积分消耗规则（待定）：**
- 标准生成：5积分
- 额外视角：+2积分/个

**套餐（待定，需结合Nano Banana Pro定价）：**
- Free: 每日5积分
- Pro: 每月300积分 ($6/月)
- Ultra: 每月1500积分 ($12/月)

---

## API路由设计

```
/api/figure/
  ├── generate/           POST 提交生成任务
  ├── status/[id]/        GET  查询任务状态
  ├── styles/             GET  获取可用风格列表
  └── history/            GET  获取用户历史记录

/api/upload/
  └── image/              POST 上传原图到R2
```

---

## 开发阶段

### v0.1.0 内测（当前目标）
- [ ] Landing Page（Hero + 卖点 + 轻量体验区）
- [ ] Generate Page（基础上传 + 1-2种风格 + 全图风格化）
- [ ] 简单的生成流程（无账号系统）
- [ ] 基础AI调用（OpenRouter + Nano Banana Pro）

### v0.2.0 公测
- [ ] 账号系统 + Free计划积分
- [ ] 完整风格化范围控制
- [ ] 一致性滑杆
- [ ] 文字保护选项
- [ ] 用户作品保存

---

## 开发命令

```bash
# 开发
pnpm dev

# 数据库
pnpm db:generate   # 生成迁移
pnpm db:migrate    # 应用迁移
pnpm db:push       # 推送schema（开发用）
pnpm db:studio     # 打开数据库GUI

# 构建
pnpm build
pnpm start
```

---

## 需要移除/简化的模板功能

### 移除
- [ ] Blog/CMS系统 (保留基础结构，移除复杂编辑器)
- [ ] AI Demo页面
- [ ] 复杂的Admin Dashboard（保留用户管理、订单查看）
- [ ] Newsletter功能
- [ ] Testimonials组件

### 简化
- [ ] Landing Page（重写为HachimiFigure专用）
- [ ] 定价页（简化为3档套餐展示）
- [ ] 用户Dashboard（只保留设置、积分、历史）

### 保留复用
- [x] 认证系统 (Better Auth)
- [x] 支付系统 (Stripe)
- [x] 积分系统 (usage, creditLogs)
- [x] 文件存储 (Cloudflare R2)
- [x] i18n框架 (next-intl)
- [x] UI组件库 (shadcn/ui)

---

## 多语言文案（i18n）

**主要语言：** 中文 (zh)
**支持语言：** 英文 (en), 日文 (ja)

**关键翻译文件：**
- `i18n/messages/{locale}/Landing.json` - 首页
- `i18n/messages/{locale}/Generate.json` - 生成页（新建）
- `i18n/messages/{locale}/common.json` - 通用

---

## 当前会话目标

**短期目标：完成v0.1.0内测版本的基础框架**

1. 更新站点配置（品牌名、域名、颜色主题）
2. 简化页面结构（移除不需要的页面）
3. 创建HachimiFigure专用Landing Page
4. 创建Generate Page基础布局
5. 添加figureStyles和figureGenerations数据库表
6. 实现基础上传和预览功能

---

## 设计风格指南

**色彩：**
- 主色调：紫色系（二次元/ACG风格）
- 强调色：粉色/蓝紫渐变
- 背景：深色主题友好

**视觉风格：**
- 现代简洁
- 二次元友好但不幼稚
- 专业工具感

**文案语气：**
- 亲切但专业
- 适度使用ACG圈层用语
- 避免过度卖萌

---

*最后更新: 2025-11-30*
*版本: v0.1.0-dev*
