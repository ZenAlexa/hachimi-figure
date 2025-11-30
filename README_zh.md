# 现代全栈 SaaS 样板

一个功能丰富的全栈 SaaS 应用程序样板，使用 Next.js 15、React 19 和现代技术构建。为开发者提供快速构建和部署 SaaS 应用的完整解决方案。

## ✨ 主要特性

- 🚀 **Next.js 15 & React 19** - 基于最新技术栈构建
- 💳 **Stripe 集成** - 完整的订阅支付系统
- 🔒 **Better Auth** - 安全可靠的用户管理与社交登录
- 🌍 **国际化 (i18n) 支持** - 内置英语、中文和日语支持
- 🧠 **AI 集成** - 支持多个 AI 提供商（OpenAI、Anthropic、DeepSeek、Google 等）
- 📊 **管理员仪表板** - 用户管理、价格计划、内容管理等
- 📱 **响应式设计** - 完美适配各种设备
- 🎨 **Tailwind CSS v4** - 现代化 UI 设计
- 📧 **邮件系统** - 由 Resend 驱动的通知和营销邮件
- 🖼️ **Cloudflare R2 存储** - 媒体文件的云存储支持
- 📝 **博客 CMS** - 内置博客系统，支持 MDX 和 TipTap 编辑器
- 🛡️ **Claude Code 配置** - 包含完整的开发设置

## 🛠️ 技术栈

### 核心
- **框架**: Next.js 15.3.0（App Router）
- **语言**: TypeScript 5（严格模式）
- **样式**: Tailwind CSS v4
- **包管理器**: pnpm

### 后端
- **数据库**: PostgreSQL + Drizzle ORM
- **认证**: Better Auth v1.3.7
- **支付**: Stripe
- **存储**: Cloudflare R2
- **邮件**: Resend + React Email 模板
- **缓存**: Upstash Redis
- **限流**: Upstash Rate Limit

### 前端
- **UI 组件**: shadcn/ui（57 个组件）
- **图标**: Lucide React
- **状态管理**: Zustand
- **表单**: React Hook Form + Zod
- **富文本编辑器**: TipTap
- **数据获取**: SWR

### AI 集成
- **框架**: Vercel AI SDK v4.3.9
- **提供商**: OpenAI、Anthropic、Google、DeepSeek、XAI、OpenRouter、Replicate、Fireworks

### 分析
- Vercel Analytics
- Google Analytics
- Plausible Analytics

## 🚀 快速开始

### 前置条件

- Node.js 18+ 和 pnpm
- PostgreSQL 数据库
- Stripe 账户（用于支付）
- Resend 账户（用于邮件）
- Cloudflare R2（用于存储）

### 安装

1. 克隆仓库：
```bash
git clone https://github.com/ZenAlexa/saas-1.git
cd saas-1
```

2. 安装依赖：
```bash
pnpm install
```

3. 设置环境变量：
```bash
cp .env.example .env.local
```

编辑 `.env.local` 并配置：
- 数据库连接（PostgreSQL）
- Better Auth 密钥
- Stripe 密钥
- Resend API 密钥
- Cloudflare R2 凭证
- AI 提供商 API 密钥（可选）

4. 设置数据库：
```bash
# 生成迁移
pnpm db:generate

# 应用迁移
pnpm db:migrate

# 填充初始数据
pnpm db:seed
```

5. 启动开发服务器：
```bash
pnpm dev
```

访问 `http://localhost:3000` 查看运行的应用。

## 📁 项目结构

```
├── app/                    # Next.js App Router
│   ├── [locale]/          # 本地化路由
│   ├── api/               # API 路由
│   └── ...
├── components/            # React 组件
│   ├── ui/               # shadcn/ui 组件
│   └── ...
├── lib/                   # 后端工具
│   ├── db/               # 数据库 schema 和迁移
│   ├── auth/             # 认证
│   └── ...
├── actions/               # Server Actions
├── config/                # 配置文件
├── i18n/                  # 国际化
├── public/                # 静态资源
└── styles/                # 全局样式
```

## 📝 可用脚本

```bash
# 开发
pnpm dev              # 启动开发服务器
pnpm dev:turbo        # 使用 Turbopack 启动
pnpm build            # 生产构建
pnpm start            # 启动生产服务器
pnpm lint             # 运行 ESLint

# 数据库
pnpm db:generate      # 生成迁移
pnpm db:migrate       # 应用迁移
pnpm db:push          # 推送 schema（仅开发）
pnpm db:studio        # 打开 Drizzle Studio
pnpm db:seed          # 填充数据库

# 分析
pnpm analyze          # 分析打包大小
```

## 🔧 配置

### 数据库 Schema

项目包含 13 个表：
- 用户管理（users、sessions、accounts）
- 支付（pricingPlans、orders、subscriptions）
- 积分系统（usage、creditLogs）
- 内容（posts、tags、postTags）
- 营销（newsletter）

查看完整 schema：`lib/db/schema.ts`

### 认证

使用 Better Auth 配置，支持：
- 邮箱/密码
- GitHub OAuth
- Google OAuth
- 魔法链接
- 匿名用户
- 管理员角色

### 支付

Stripe 集成包括：
- 订阅管理
- 一次性支付
- 客户门户
- Webhook 处理器
- 积分系统集成

### AI 集成

支持多个 AI 提供商：
- OpenAI（GPT-4、GPT-3.5）
- Anthropic（Claude）
- Google（Gemini）
- DeepSeek
- XAI（Grok）
- OpenRouter
- Replicate
- Fireworks

在 `.env.local` 中配置 API 密钥以启用。

## 🌍 国际化

内置支持：
- 英语（en）
- 中文（zh）
- 日语（ja）

翻译文件位于 `i18n/messages/`。

## 🎨 自定义

### 品牌

更新以下文件：
- `config/site.ts` - 网站元数据
- `public/` - Logo 和 favicons
- `styles/@theme.css` - 色彩方案

### 邮件模板

邮件模板位于 `emails/`，使用 React Email。

### UI 组件

所有 UI 组件使用 shadcn/ui 构建，可在 `components/ui/` 中自定义。

## 📚 文档

- **CLAUDE.md** - 完整项目文档
- **.claude/** - Claude Code 配置
- **.cursor/rules/** - 开发指南

## 🚢 部署

### Vercel（推荐）

1. 将代码推送到 GitHub
2. 在 Vercel 中导入项目
3. 配置环境变量
4. 部署

应用针对 Vercel 优化，支持自动部署。

### 其他平台

应用可部署到任何支持 Next.js 的平台：
- Netlify
- AWS Amplify
- Railway
- Render
- 使用 Docker 自托管

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

## 📄 许可证

MIT License - 详见 LICENSE 文件。

## 🙏 致谢

使用现代技术和最佳实践构建。

## 📞 支持

如有问题：
- 在 GitHub 上提出 issue
- 查看 CLAUDE.md 中的文档

---

**作者**: Ziming Wang
**GitHub**: [@ZenAlexa](https://github.com/ZenAlexa)
**邮箱**: zimingwang945@gmail.com
**仓库**: [saas-1](https://github.com/ZenAlexa/saas-1)

使用 ❤️ 和 Next.js、React、TypeScript 构建
