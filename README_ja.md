# モダンフルスタック SaaS ボイラープレート

Next.js 15、React 19、最新技術で構築された、機能豊富なフルスタック SaaS アプリケーションボイラープレート。開発者が SaaS アプリケーションを迅速に構築・デプロイするための完全なソリューションを提供します。

## ✨ 主な機能

- 🚀 **Next.js 15 & React 19** - 最新の技術スタックで構築
- 💳 **Stripe 統合** - 完全なサブスクリプション決済システム
- 🔒 **Better Auth** - ソーシャルログインを備えた安全で信頼性の高いユーザー管理
- 🌍 **国際化 (i18n) 対応** - 英語、中国語、日本語のビルトインサポート
- 🧠 **AI 統合** - 複数の AI プロバイダーをサポート（OpenAI、Anthropic、DeepSeek、Google など）
- 📊 **管理者ダッシュボード** - ユーザー管理、価格プラン、コンテンツ管理など
- 📱 **レスポンシブデザイン** - さまざまなデバイスに完璧に適応
- 🎨 **Tailwind CSS v4** - モダンな UI デザイン
- 📧 **メールシステム** - Resend による通知・マーケティングメール
- 🖼️ **Cloudflare R2 ストレージ** - メディアファイル用のクラウドストレージ
- 📝 **ブログ CMS** - MDX と TipTap エディタを備えたビルトインブログ
- 🛡️ **Claude Code 設定** - 完全な開発セットアップを含む

## 🛠️ 技術スタック

### コア
- **フレームワーク**: Next.js 15.3.0（App Router）
- **言語**: TypeScript 5（strict モード）
- **スタイリング**: Tailwind CSS v4
- **パッケージマネージャー**: pnpm

### バックエンド
- **データベース**: PostgreSQL + Drizzle ORM
- **認証**: Better Auth v1.3.7
- **決済**: Stripe
- **ストレージ**: Cloudflare R2
- **メール**: Resend + React Email テンプレート
- **キャッシング**: Upstash Redis
- **レート制限**: Upstash Rate Limit

### フロントエンド
- **UI コンポーネント**: shadcn/ui（57 コンポーネント）
- **アイコン**: Lucide React
- **状態管理**: Zustand
- **フォーム**: React Hook Form + Zod
- **リッチテキストエディタ**: TipTap
- **データフェッチング**: SWR

### AI 統合
- **フレームワーク**: Vercel AI SDK v4.3.9
- **プロバイダー**: OpenAI、Anthropic、Google、DeepSeek、XAI、OpenRouter、Replicate、Fireworks

### アナリティクス
- Vercel Analytics
- Google Analytics
- Plausible Analytics

## 🚀 クイックスタート

### 前提条件

- Node.js 18+ と pnpm
- PostgreSQL データベース
- Stripe アカウント（決済用）
- Resend アカウント（メール用）
- Cloudflare R2（ストレージ用）

### インストール

1. リポジトリをクローン：
```bash
git clone https://github.com/ZenAlexa/saas-1.git
cd saas-1
```

2. 依存関係をインストール：
```bash
pnpm install
```

3. 環境変数を設定：
```bash
cp .env.example .env.local
```

`.env.local` を編集して設定：
- データベース接続（PostgreSQL）
- Better Auth シークレット
- Stripe キー
- Resend API キー
- Cloudflare R2 認証情報
- AI プロバイダー API キー（オプション）

4. データベースをセットアップ：
```bash
# マイグレーション生成
pnpm db:generate

# マイグレーション適用
pnpm db:migrate

# 初期データ投入
pnpm db:seed
```

5. 開発サーバーを起動：
```bash
pnpm dev
```

`http://localhost:3000` にアクセスしてアプリケーションを確認。

## 📁 プロジェクト構造

```
├── app/                    # Next.js App Router
│   ├── [locale]/          # ローカライズされたルート
│   ├── api/               # API ルート
│   └── ...
├── components/            # React コンポーネント
│   ├── ui/               # shadcn/ui コンポーネント
│   └── ...
├── lib/                   # バックエンドユーティリティ
│   ├── db/               # データベース schema とマイグレーション
│   ├── auth/             # 認証
│   └── ...
├── actions/               # Server Actions
├── config/                # 設定ファイル
├── i18n/                  # 国際化
├── public/                # 静的アセット
└── styles/                # グローバルスタイル
```

## 📝 利用可能なスクリプト

```bash
# 開発
pnpm dev              # 開発サーバー起動
pnpm dev:turbo        # Turbopack で起動
pnpm build            # 本番ビルド
pnpm start            # 本番サーバー起動
pnpm lint             # ESLint 実行

# データベース
pnpm db:generate      # マイグレーション生成
pnpm db:migrate       # マイグレーション適用
pnpm db:push          # schema プッシュ（開発のみ）
pnpm db:studio        # Drizzle Studio を開く
pnpm db:seed          # データベースにシード

# 解析
pnpm analyze          # バンドルサイズを解析
```

## 🔧 設定

### データベース Schema

プロジェクトには 13 のテーブルが含まれます：
- ユーザー管理（users、sessions、accounts）
- 決済（pricingPlans、orders、subscriptions）
- クレジットシステム（usage、creditLogs）
- コンテンツ（posts、tags、postTags）
- マーケティング（newsletter）

完全な schema は `lib/db/schema.ts` を参照。

### 認証

Better Auth で設定、サポート機能：
- メール/パスワード
- GitHub OAuth
- Google OAuth
- マジックリンク
- 匿名ユーザー
- 管理者ロール

### 決済

Stripe 統合には以下が含まれます：
- サブスクリプション管理
- 一回限りの決済
- カスタマーポータル
- Webhook ハンドラー
- クレジットシステム統合

### AI 統合

複数の AI プロバイダーをサポート：
- OpenAI（GPT-4、GPT-3.5）
- Anthropic（Claude）
- Google（Gemini）
- DeepSeek
- XAI（Grok）
- OpenRouter
- Replicate
- Fireworks

`.env.local` で API キーを設定して有効化。

## 🌍 国際化

ビルトインサポート：
- 英語（en）
- 中国語（zh）
- 日本語（ja）

翻訳ファイルは `i18n/messages/` に配置。

## 🎨 カスタマイズ

### ブランディング

以下のファイルを更新：
- `config/site.ts` - サイトメタデータ
- `public/` - ロゴと favicons
- `styles/@theme.css` - カラースキーム

### メールテンプレート

メールテンプレートは `emails/` にあり、React Email を使用。

### UI コンポーネント

すべての UI コンポーネントは shadcn/ui で構築され、`components/ui/` でカスタマイズ可能。

## 📚 ドキュメント

- **CLAUDE.md** - 完全なプロジェクトドキュメント
- **.claude/** - Claude Code 設定
- **.cursor/rules/** - 開発ガイドライン

## 🚢 デプロイ

### Vercel（推奨）

1. コードを GitHub にプッシュ
2. Vercel でプロジェクトをインポート
3. 環境変数を設定
4. デプロイ

アプリケーションは Vercel 向けに最適化され、自動デプロイをサポート。

### その他のプラットフォーム

Next.js をサポートする任意のプラットフォームにデプロイ可能：
- Netlify
- AWS Amplify
- Railway
- Render
- Docker でセルフホスト

## 🤝 貢献

貢献を歓迎します！お気軽に Pull Request を提出してください。

## 📄 ライセンス

MIT License - 詳細は LICENSE ファイルを参照。

## 🙏 謝辞

最新技術とベストプラクティスで構築。

## 📞 サポート

問題がある場合：
- GitHub で issue を作成
- CLAUDE.md のドキュメントを確認

---

**作者**: Ziming Wang
**GitHub**: [@ZenAlexa](https://github.com/ZenAlexa)
**メール**: zimingwang945@gmail.com
**リポジトリ**: [saas-1](https://github.com/ZenAlexa/saas-1)

❤️ と Next.js、React、TypeScript で構築
