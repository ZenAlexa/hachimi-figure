# Modern Full-Stack SaaS Boilerplate

A feature-rich, full-stack SaaS application boilerplate built with Next.js 15, React 19, and modern technologies. It provides developers with a complete solution to quickly build and deploy SaaS applications.

## ✨ Key Features

- 🚀 **Next.js 15 & React 19** - Built on the latest tech stack
- 💳 **Stripe Integration** - Complete subscription payment system
- 🔒 **Better Auth** - Secure and reliable user management with social login
- 🌍 **Internationalization (i18n) Ready** - Built-in support for English, Chinese, and Japanese
- 🧠 **AI Integration** - Supports multiple AI providers (OpenAI, Anthropic, DeepSeek, Google, etc.)
- 📊 **Admin Dashboard** - User management, pricing plans, content management, etc.
- 📱 **Responsive Design** - Perfect adaptation across various devices
- 🎨 **Tailwind CSS v4** - Modern UI design
- 📧 **Email System** - Notifications and marketing emails powered by Resend
- 🖼️ **Cloudflare R2 Storage** - Cloud storage support for media files
- 📝 **Blog CMS** - Built-in blog with MDX and TipTap editor
- 🛡️ **Claude Code Configuration** - Complete development setup included

## 🛠️ Tech Stack

### Core
- **Framework**: Next.js 15.3.0 with App Router
- **Language**: TypeScript 5 (strict mode)
- **Styling**: Tailwind CSS v4
- **Package Manager**: pnpm

### Backend
- **Database**: PostgreSQL with Drizzle ORM
- **Authentication**: Better Auth v1.3.7
- **Payments**: Stripe
- **Storage**: Cloudflare R2
- **Email**: Resend with React Email templates
- **Caching**: Upstash Redis
- **Rate Limiting**: Upstash Rate Limit

### Frontend
- **UI Components**: shadcn/ui (57 components)
- **Icons**: Lucide React
- **State Management**: Zustand
- **Forms**: React Hook Form + Zod
- **Rich Text Editor**: TipTap
- **Data Fetching**: SWR

### AI Integration
- **Framework**: Vercel AI SDK v4.3.9
- **Providers**: OpenAI, Anthropic, Google, DeepSeek, XAI, OpenRouter, Replicate, Fireworks

### Analytics
- Vercel Analytics
- Google Analytics
- Plausible Analytics

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and pnpm
- PostgreSQL database
- Stripe account (for payments)
- Resend account (for emails)
- Cloudflare R2 (for storage)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ZenAlexa/saas-1.git
cd saas-1
```

2. Install dependencies:
```bash
pnpm install
```

3. Set up environment variables:
```bash
cp .env.example .env.local
```

Edit `.env.local` and configure:
- Database connection (PostgreSQL)
- Better Auth secret
- Stripe keys
- Resend API key
- Cloudflare R2 credentials
- AI provider API keys (optional)

4. Set up the database:
```bash
# Generate migrations
pnpm db:generate

# Apply migrations
pnpm db:migrate

# Seed initial data
pnpm db:seed
```

5. Start the development server:
```bash
pnpm dev
```

Visit `http://localhost:3000` to see your app running.

## 📁 Project Structure

```
├── app/                    # Next.js App Router
│   ├── [locale]/          # Localized routes
│   ├── api/               # API routes
│   └── ...
├── components/            # React components
│   ├── ui/               # shadcn/ui components
│   └── ...
├── lib/                   # Backend utilities
│   ├── db/               # Database schema & migrations
│   ├── auth/             # Authentication
│   └── ...
├── actions/               # Server Actions
├── config/                # Configuration files
├── i18n/                  # Internationalization
├── public/                # Static assets
└── styles/                # Global styles
```

## 📝 Available Scripts

```bash
# Development
pnpm dev              # Start dev server
pnpm dev:turbo        # Start with Turbopack
pnpm build            # Build for production
pnpm start            # Start production server
pnpm lint             # Run ESLint

# Database
pnpm db:generate      # Generate migrations
pnpm db:migrate       # Apply migrations
pnpm db:push          # Push schema (dev only)
pnpm db:studio        # Open Drizzle Studio
pnpm db:seed          # Seed database

# Analysis
pnpm analyze          # Analyze bundle size
```

## 🔧 Configuration

### Database Schema

The project includes 13 tables:
- User management (users, sessions, accounts)
- Payments (pricingPlans, orders, subscriptions)
- Credit system (usage, creditLogs)
- Content (posts, tags, postTags)
- Marketing (newsletter)

See `lib/db/schema.ts` for the complete schema.

### Authentication

Configured with Better Auth supporting:
- Email/Password
- GitHub OAuth
- Google OAuth
- Magic Links
- Anonymous users
- Admin roles

### Payments

Stripe integration includes:
- Subscription management
- One-time payments
- Customer portal
- Webhook handlers
- Credit system integration

### AI Integration

Support for multiple AI providers:
- OpenAI (GPT-4, GPT-3.5)
- Anthropic (Claude)
- Google (Gemini)
- DeepSeek
- XAI (Grok)
- OpenRouter
- Replicate
- Fireworks

Configure API keys in `.env.local` to enable.

## 🌍 Internationalization

Built-in support for:
- English (en)
- Chinese (zh)
- Japanese (ja)

Translation files are located in `i18n/messages/`.

## 🎨 Customization

### Branding

Update the following files:
- `config/site.ts` - Site metadata
- `public/` - Logo and favicons
- `styles/@theme.css` - Color scheme

### Email Templates

Email templates are in `emails/` using React Email.

### UI Components

All UI components are built with shadcn/ui and can be customized in `components/ui/`.

## 📚 Documentation

- **CLAUDE.md** - Complete project documentation
- **.claude/** - Claude Code configuration
- **.cursor/rules/** - Development guidelines

## 🚢 Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Import the project in Vercel
3. Configure environment variables
4. Deploy

The app is optimized for Vercel with automatic deployments.

### Other Platforms

The app can be deployed to any platform that supports Next.js:
- Netlify
- AWS Amplify
- Railway
- Render
- Self-hosted with Docker

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

Built with modern technologies and best practices.

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check the documentation in CLAUDE.md

---

**Author**: Ziming Wang
**GitHub**: [@ZenAlexa](https://github.com/ZenAlexa)
**Email**: zimingwang945@gmail.com
**Repository**: [saas-1](https://github.com/ZenAlexa/saas-1)

Built with ❤️ using Next.js, React, and TypeScript
