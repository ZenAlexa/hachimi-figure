# Nexty - Modern Full-Stack SaaS Boilerplate

## Project Overview

**Nexty** is a production-ready SaaS boilerplate built with Next.js 15, React 19, and TypeScript. It provides a complete foundation for building modern SaaS applications with authentication, payments, AI integration, internationalization, and more.

**Version:** 3.2.4
**Package Manager:** pnpm
**Primary Stack:** Next.js 15 (App Router) + React 19 + TypeScript 5 + Tailwind CSS v4

## Quick Start

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env.local
# Edit .env.local with your credentials

# Set up database
pnpm db:generate  # Generate migrations
pnpm db:migrate   # Apply migrations
pnpm db:seed      # Seed initial data

# Start development server
pnpm dev          # Standard mode (localhost:3000)
pnpm dev:turbo    # With Turbopack
```

## Architecture

### Technology Stack

**Core:**
- Next.js 15.3.0 with App Router
- React 19 with Server Components
- TypeScript 5 (strict mode)
- Tailwind CSS v4 (CSS-based configuration)

**Database & ORM:**
- PostgreSQL with Drizzle ORM (v0.44.5)
- Neon serverless adapter for edge compatibility
- 13 tables with proper indexing and relationships

**Authentication:**
- Better Auth v1.3.7 with Drizzle adapter
- Social providers: GitHub, Google
- Features: Magic links, One-tap login, Anonymous users, Role-based access (admin/user)
- Cloudflare Turnstile for CAPTCHA

**Payments:**
- Stripe integration (subscriptions + one-time payments)
- Webhook handlers for all events
- Credit system with usage tracking
- Customer portal integration

**AI Integration:**
- Vercel AI SDK v4.3.9
- Multiple providers: OpenAI, Anthropic, Google, DeepSeek, XAI, OpenRouter, Replicate, Fireworks
- Support for text, image, and video generation
- Factory pattern for model initialization

**Internationalization:**
- next-intl v4.0.2
- Supported locales: English (en), Chinese (zh), Japanese (ja)
- Middleware-based locale detection
- Translation files organized by feature

**Storage:**
- Cloudflare R2 (S3-compatible)
- Presigned URLs for uploads/downloads
- User isolation with access controls
- Rate limiting on public endpoints

**Email:**
- Resend v4.1.2 with React email templates
- Templates: Welcome, Magic link, Payment notifications, Fraud alerts
- Newsletter subscription management

**State & Caching:**
- Zustand v5.0.3 for global state
- Upstash Redis for caching
- Upstash Rate Limit for API protection

**UI Components:**
- shadcn/ui (New York style) - 57 components
- Radix UI primitives
- Lucide React icons
- TipTap editor for rich text
- MDX support for blog

### Directory Structure

```
/
├── .claude/              # Claude Code configuration (commands, skills, hooks)
├── .cursor/rules/        # 15 comprehensive development guidelines
├── actions/              # Server Actions organized by feature
│   ├── newsletter/       # Newsletter subscriptions
│   ├── orders/          # Order management
│   ├── posts/           # Blog CMS operations
│   ├── r2-resources/    # File operations
│   ├── stripe/          # Payment processing
│   ├── usage/           # Credit system
│   └── users/           # User management
├── app/                 # Next.js App Router
│   ├── [locale]/        # Localized routes
│   │   ├── (basic-layout)/  # Public pages with header/footer
│   │   └── (protected)/dashboard/  # Authenticated routes
│   │       ├── (admin)/     # Admin-only routes
│   │       └── (user)/      # User routes
│   └── api/             # API Route Handlers
│       ├── ai-demo/     # AI endpoints
│       ├── auth/        # Better Auth
│       ├── payment/     # Payment processing
│       └── stripe/      # Webhooks
├── blogs/               # MDX blog content by locale
├── components/          # React components
│   ├── ai-demo/         # AI demo UI
│   ├── auth/            # Auth forms and guards
│   ├── cms/             # Blog editor components
│   ├── ui/              # shadcn/ui components (57)
│   └── [others]/        # Feature-specific components
├── config/              # Configuration files
│   ├── colors.ts        # Color palette
│   ├── common.ts        # Common constants
│   ├── models.ts        # AI model configs
│   └── site.ts          # Site metadata
├── content/             # Static content (about pages)
├── emails/              # React email templates (8)
├── hooks/               # Custom React hooks (4)
├── i18n/                # Internationalization
│   ├── messages/        # Translation JSON files
│   ├── request.ts       # i18n config
│   └── routing.ts       # Locale routing
├── lib/                 # Backend utilities & integrations
│   ├── auth/            # Better Auth server/client
│   ├── cloudflare/      # R2 client & helpers
│   ├── db/              # Drizzle schema, migrations, seed
│   ├── stripe/          # Stripe client
│   ├── upstash/         # Redis & rate limiting
│   └── [utilities]/     # Helper functions
├── public/              # Static assets
├── stores/              # Zustand stores
├── styles/              # Global CSS & Tailwind
└── types/               # TypeScript definitions
```

### Database Schema (13 Tables)

1. **user** - User accounts with Better Auth, Stripe customer ID, role (admin/user), ban support
2. **session** - Better Auth sessions with IP/user agent tracking
3. **account** - Social provider accounts (GitHub, Google)
4. **verification** - Email verification tokens
5. **pricingPlans** - Multi-locale pricing plans with Stripe integration
6. **orders** - Payment tracking (subscription/one-time)
7. **subscriptions** - Stripe subscription sync
8. **usage** - Credit balances with JSONB flexibility
9. **creditLogs** - Audit trail for credit changes
10. **posts** - Blog CMS with visibility control
11. **tags** - Blog tagging system
12. **postTags** - Many-to-many post-tag relationships
13. **newsletter** - Email collection

## Development Workflows

### Database Management

```bash
# Generate migration from schema changes
pnpm db:generate

# Apply migrations to database
pnpm db:migrate

# Push schema directly (dev only, skips migrations)
pnpm db:push

# Open Drizzle Studio GUI
pnpm db:studio

# Seed database with initial data
pnpm db:seed
```

**Schema Location:** [lib/db/schema.ts](lib/db/schema.ts) (373 lines)
**Migration Files:** [lib/db/migrations/](lib/db/migrations/)

### Building & Deployment

```bash
# Build for production
pnpm build

# Start production server
pnpm start

# Build with bundle analyzer
pnpm analyze
# Or: ANALYZE=true pnpm build
```

**Build Configuration:** [next.config.mjs](next.config.mjs)
- Optimized for Vercel deployment
- Image optimization enabled
- Console.log removal in production (except errors)
- next-intl plugin for i18n
- Redirects configured

### Code Quality

```bash
# Run ESLint
pnpm lint
```

**Configured Tools:**
- ESLint with Next.js rules
- Prettier v3.6.2 for formatting
- TypeScript strict mode
- Format on save enabled in VS Code

### Environment Variables

**Required Setup:** Copy [.env.example](.env.example) to `.env.local` and configure:

**13 Configuration Sections:**
1. Site info (name, URL, description)
2. Database (PostgreSQL connection string)
3. Auth (Better Auth secret, Turnstile keys)
4. Resend (API key for emails)
5. Upstash (Redis URL & token, Rate limit)
6. Stripe (API keys, webhooks)
7. Cloudflare R2 (credentials, bucket, domain)
8. AI providers (8 different providers - OpenAI, Anthropic, etc.)
9. Translation (Google Translate API key)
10. Analytics (Google Analytics, Plausible, Baidu Tongji, Adsense)
11. Discord (webhook URL)
12. Tolt.io (affiliate tracking)
13. Feature flags (enable/disable Stripe, Google Auth, etc.)

## Coding Conventions

### TypeScript Patterns

**File Naming:**
- Components: PascalCase (e.g., `UserProfile.tsx`)
- Utilities: camelCase (e.g., `formatDate.ts`)
- Server Actions: camelCase (e.g., `createOrder.ts`)
- Types: PascalCase (e.g., `User.ts`)

**Import Organization:**
```typescript
// 1. React imports
import { useState } from 'react'

// 2. External packages
import { z } from 'zod'

// 3. Internal absolute imports (@/*)
import { db } from '@/lib/db'
import { Button } from '@/components/ui/button'

// 4. Relative imports
import { localHelper } from './helper'
```

**Component Structure:**
```typescript
'use client' // Only if client component needed

import type { ComponentProps } from '@/types'

interface Props {
  userId: string
  optional?: boolean
}

export function ComponentName({ userId, optional = false }: Props) {
  // Hooks first
  const [state, setState] = useState(false)

  // Handlers
  const handleClick = () => {
    // Logic
  }

  // Render
  return (
    <div>Content</div>
  )
}
```

### Server Actions Pattern

**Location:** [actions/](actions/) directory, organized by feature

**Structure:**
```typescript
'use server'

import { z } from 'zod'
import { db } from '@/lib/db'
import { actionResponse } from '@/lib/action-response'
import { getSession, isAdmin } from '@/lib/auth/server'

const schema = z.object({
  field: z.string().min(1),
})

export async function actionName(data: z.infer<typeof schema>) {
  // Validate input
  const validated = schema.safeParse(data)
  if (!validated.success) {
    return actionResponse.error('Invalid input', validated.error)
  }

  // Check auth
  const session = await getSession()
  if (!session) {
    return actionResponse.unauthorized()
  }

  // Check admin if needed
  if (!isAdmin(session)) {
    return actionResponse.forbidden()
  }

  try {
    // Business logic
    const result = await db.insert(/* ... */)

    return actionResponse.success(result)
  } catch (error) {
    console.error('Action error:', error)
    return actionResponse.error('Operation failed')
  }
}
```

### API Routes Pattern

**Location:** [app/api/](app/api/) directory

**Structure:**
```typescript
import { NextRequest } from 'next/server'
import { apiResponse } from '@/lib/api-response'
import { getSession } from '@/lib/auth/server'

export async function POST(req: NextRequest) {
  try {
    // Rate limiting (if public endpoint)
    const ip = getClientIPFromHeaders(req)
    const { success } = await rateLimit.limit(ip)
    if (!success) {
      return apiResponse.tooManyRequests()
    }

    // Auth check
    const session = await getSession()
    if (!session) {
      return apiResponse.unauthorized()
    }

    // Parse body
    const body = await req.json()

    // Business logic
    const result = await processRequest(body)

    return apiResponse.success(result)
  } catch (error) {
    console.error('API error:', error)
    return apiResponse.error('Internal server error')
  }
}
```

### Authentication Patterns

**Server-side (Server Components, Actions, API Routes):**
```typescript
import { getSession, isAdmin } from '@/lib/auth/server'

// Get current session
const session = await getSession()
if (!session) {
  // Handle unauthorized
}

// Check if admin
if (isAdmin(session)) {
  // Admin-only logic
}
```

**Client-side (Client Components):**
```typescript
'use client'

import { authClient } from '@/lib/auth/auth-client'

// Use hooks
const { data: session } = authClient.useSession()
const { signOut } = authClient.useSignOut()

// Sign in with provider
await authClient.signIn.social({
  provider: 'github',
  callbackURL: '/dashboard',
})

// Sign out
await signOut()
```

**Protected Routes:**
```typescript
import { AuthGuard } from '@/components/auth/auth-guard'

export default function ProtectedPage() {
  return (
    <AuthGuard requireAdmin={false}>
      <div>Protected content</div>
    </AuthGuard>
  )
}
```

### Database Operations (Drizzle ORM)

```typescript
import { db } from '@/lib/db'
import { users, posts } from '@/lib/db/schema'
import { eq, and, desc } from 'drizzle-orm'

// Select
const user = await db.query.users.findFirst({
  where: eq(users.id, userId),
})

// Select with relations
const postsWithTags = await db.query.posts.findMany({
  with: {
    postTags: {
      with: {
        tag: true,
      },
    },
  },
})

// Insert
const [newPost] = await db.insert(posts).values({
  title: 'Post title',
  content: 'Content',
  authorId: userId,
}).returning()

// Update
await db.update(users)
  .set({ name: 'New name' })
  .where(eq(users.id, userId))

// Delete
await db.delete(posts)
  .where(eq(posts.id, postId))

// Complex queries
const results = await db.select()
  .from(posts)
  .where(and(
    eq(posts.published, true),
    eq(posts.locale, 'en'),
  ))
  .orderBy(desc(posts.createdAt))
  .limit(10)
```

### Styling with Tailwind CSS v4

**Theme Usage:**
```tsx
// Use theme values (not arbitrary)
<div className="bg-primary text-primary-foreground">
  <h1 className="text-2xl font-bold">Title</h1>
</div>

// Mobile-first responsive
<div className="w-full md:w-1/2 lg:w-1/3">
  Content
</div>

// Dark mode support
<div className="bg-white dark:bg-gray-900">
  Content
</div>
```

**Custom Colors:** Defined in [config/colors.ts](config/colors.ts)

### Internationalization

**Server Components:**
```typescript
import { getTranslations } from 'next-intl/server'

export default async function Page() {
  const t = await getTranslations('common')

  return <h1>{t('welcome')}</h1>
}
```

**Client Components:**
```typescript
'use client'

import { useTranslations } from 'next-intl'

export function Component() {
  const t = useTranslations('common')

  return <p>{t('description')}</p>
}
```

**Translation Files:** [i18n/messages/](i18n/messages/) organized by locale (en/, zh/, ja/)

## Important Files & Locations

### Configuration Files
- [next.config.mjs](next.config.mjs) - Next.js configuration
- [tsconfig.json](tsconfig.json) - TypeScript configuration
- [drizzle.config.ts](drizzle.config.ts) - Database configuration
- [components.json](components.json) - shadcn/ui configuration
- [postcss.config.js](postcss.config.js) - PostCSS/Tailwind configuration
- [.eslintrc.js](.eslintrc.js) - ESLint rules
- [.prettierrc](.prettierrc) - Prettier formatting

### Key Utilities
- [lib/action-response.ts](lib/action-response.ts) - Server Action response helpers
- [lib/api-response.ts](lib/api-response.ts) - API response helpers
- [lib/utils.ts](lib/utils.ts) - Common utilities (cn, formatters)
- [lib/auth/server.ts](lib/auth/server.ts) - Server-side auth utilities
- [lib/auth/auth-client.ts](lib/auth/auth-client.ts) - Client-side auth

### Integration Clients
- [lib/db/index.ts](lib/db/index.ts) - Database singleton
- [lib/stripe/index.ts](lib/stripe/index.ts) - Stripe client
- [lib/cloudflare/index.ts](lib/cloudflare/index.ts) - R2 client
- [lib/resend/index.ts](lib/resend/index.ts) - Resend email client
- [lib/upstash/redis.ts](lib/upstash/redis.ts) - Redis client
- [lib/upstash/rate-limit.ts](lib/upstash/rate-limit.ts) - Rate limiter

## Common Tasks

### Adding a New Feature

1. **Create Server Action** in [actions/feature-name/](actions/)
2. **Add API Route** if needed in [app/api/feature-name/](app/api/)
3. **Create Components** in [components/feature-name/](components/)
4. **Add Route** in [app/\[locale\]/](app/[locale]/)
5. **Update i18n** messages in [i18n/messages/](i18n/messages/)
6. **Update Schema** if database changes in [lib/db/schema.ts](lib/db/schema.ts)
7. **Generate Migration** with `pnpm db:generate`

### Adding a New AI Model

1. Add API key to `.env.local`
2. Update [config/models.ts](config/models.ts)
3. Use in components via factory pattern from [lib/ai/get-model.ts](lib/ai/get-model.ts)

### Adding a New Payment Plan

1. Create plan in Stripe Dashboard
2. Add to database via Admin UI at `/dashboard/prices`
3. Sync Stripe product ID with database record

### Adding a New Blog Post

**Via Admin UI:**
1. Navigate to `/dashboard/blogs`
2. Click "New Post"
3. Write content with TipTap editor
4. Add metadata (title, description, tags, OG image)
5. Publish

**Via MDX Files:**
1. Create file in [blogs/{locale}/](blogs/) directory
2. Add frontmatter with metadata
3. Write content in Markdown/MDX

## Cursor Rules

The project includes 15 comprehensive development guidelines in [.cursor/rules/](.cursor/rules/):

1. **00-general.md** - TypeScript conventions
2. **01-next-best-practices.md** - Next.js patterns
3. **02-react.md** - React component patterns
4. **03-tailwind.md** - Tailwind CSS v4 usage
5. **04-internationalization.md** - i18n guidelines
6. **05-project-structure.md** - File organization
7. **06-ai-integration.md** - AI model usage
8. **07-better-auth-drizzle.md** - Auth patterns
9. **08-api-data-handling.md** - Data management
10. **09-stripe.md** - Payment integration
11. **10-r2.md** - File storage
12. **11-email.md** - Email templates
13. **12-env.md** - Environment variables
14. **13-scripts.md** - pnpm scripts
15. **14-logging-security.md** - Security & logging

**Important:** Review these rules before making significant changes.

## Security Considerations

### Authentication
- Better Auth handles session management
- Sessions stored in database
- IP and user agent tracking
- Admin role separation

### API Security
- Rate limiting on public endpoints (Upstash)
- CAPTCHA on sensitive forms (Turnstile)
- Environment variables for secrets
- Webhook signature verification (Stripe)

### Data Protection
- User data isolation (userId-based queries)
- R2 file access controls (user/admin/public)
- SQL injection prevention (Drizzle parameterized queries)
- XSS prevention (React escaping)

### Best Practices
- Never commit `.env.local`
- Validate all user input with Zod
- Use server-only code markers
- Sanitize file uploads
- Implement proper error handling

## Troubleshooting

### Database Issues

**Connection errors:**
- Verify `DATABASE_URL` in `.env.local`
- Check PostgreSQL server is running
- For Neon, ensure WebSocket connections allowed

**Migration errors:**
- Run `pnpm db:generate` after schema changes
- Check migration files in [lib/db/migrations/](lib/db/migrations/)
- Use `pnpm db:studio` to inspect database

### Build Errors

**TypeScript errors:**
- Run `pnpm build` to see all errors
- Check import paths use @/* aliases
- Verify types exist for third-party packages

**Tailwind not working:**
- Restart dev server after config changes
- Check [styles/@theme.css](styles/@theme.css) for v4 syntax
- Verify PostCSS config includes Tailwind v4 plugin

### Authentication Issues

**Session not persisting:**
- Check `BETTER_AUTH_SECRET` is set
- Verify cookies are enabled
- Clear browser cookies and retry

**Social login fails:**
- Verify provider credentials in `.env.local`
- Check redirect URIs match in provider dashboard
- Ensure callback URLs are whitelisted

### Payment Issues

**Stripe webhooks not working:**
- Verify `STRIPE_WEBHOOK_SECRET` matches Stripe dashboard
- Check webhook endpoint is accessible (use Stripe CLI for local dev)
- Review logs in `/api/stripe/webhook/route.ts`

## Resources

### Documentation
- [Next.js Docs](https://nextjs.org/docs)
- [Better Auth Docs](https://better-auth.com)
- [Drizzle ORM Docs](https://orm.drizzle.team)
- [shadcn/ui Docs](https://ui.shadcn.com)
- [Tailwind CSS v4 Docs](https://tailwindcss.com/docs)

### Project Files
- [README.md](README.md) - Project README
- [.env.example](.env.example) - Environment variable template
- [CHANGELOG.md](CHANGELOG.md) - Version history

### Support
- GitHub Issues: Report bugs and request features
- Documentation: Check Cursor rules in `.cursor/rules/`

---

**Last Updated:** 2025-01-22
**Maintained by:** Development Team
**License:** Check repository for license information
