---
name: nextjs-expert
description: Expert knowledge for Next.js 15 App Router development patterns, best practices, and common issues. Use when working with Next.js routing, Server Components, Client Components, data fetching, or deployment.
---

# Next.js 15 App Router Expert

You are an expert in Next.js 15 with deep knowledge of the App Router, React Server Components, and modern Next.js patterns.

## Key Expertise Areas

### 1. App Router Architecture
- **File-based routing** in `app/` directory
- **Route Groups** using `(group-name)/` for organization without affecting URL
- **Parallel Routes** using `@folder` for advanced layouts
- **Intercepting Routes** using `(..)` for modals
- **Dynamic Routes** using `[param]/` and `[...slug]/`
- **Route Handlers** in `route.ts` for API endpoints

### 2. Server vs Client Components

**Server Components (default):**
- No 'use client' directive
- Can access backend resources directly
- Cannot use hooks (useState, useEffect, etc.)
- Cannot use browser APIs
- Better for SEO and performance
- Should be the default choice

**Client Components:**
- Require 'use client' directive
- Can use React hooks
- Can use browser APIs
- Can handle user interactions
- Should be used minimally

**Best Practice:** Start with Server Components, only add 'use client' when you need:
- useState, useEffect, or other hooks
- Event handlers (onClick, onChange, etc.)
- Browser APIs (window, localStorage, etc.)
- Third-party libraries that require client-side code

### 3. Data Fetching Patterns

**Server Components:**
```typescript
// Fetch in Server Component
async function getData() {
  const res = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 } // Cache for 1 hour
  })
  return res.json()
}

export default async function Page() {
  const data = await getData()
  return <div>{data.title}</div>
}
```

**Client Components:**
```typescript
'use client'

import useSWR from 'swr'

export function ClientData() {
  const { data } = useSWR('/api/data', fetcher)
  return <div>{data?.title}</div>
}
```

**Server Actions (preferred for mutations):**
```typescript
'use server'

export async function createItem(formData: FormData) {
  const title = formData.get('title')
  // Database operation
  revalidatePath('/items')
  return { success: true }
}
```

### 4. Loading and Error States

**Loading UI:**
```typescript
// app/dashboard/loading.tsx
export default function Loading() {
  return <Spinner />
}
```

**Error Handling:**
```typescript
// app/dashboard/error.tsx
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error
  reset: () => void
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={reset}>Try again</button>
    </div>
  )
}
```

### 5. Metadata and SEO

**Static Metadata:**
```typescript
export const metadata = {
  title: 'Page Title',
  description: 'Page description',
}
```

**Dynamic Metadata:**
```typescript
export async function generateMetadata({ params }) {
  const post = await getPost(params.id)
  return {
    title: post.title,
    description: post.description,
  }
}
```

### 6. Common Patterns in This Project

**Protected Routes:**
- Use `<AuthGuard>` component for authentication
- Server-side: `await getSession()` in Server Components
- Client-side: `authClient.useSession()` hook

**Internationalization:**
- Routes under `app/[locale]/`
- Use `await getTranslations()` in Server Components
- Use `useTranslations()` in Client Components

**Admin Routes:**
- Located in `app/[locale]/(protected)/dashboard/(admin)/`
- Protected with `isAdmin()` check
- Use admin-specific actions from `actions/`

**API Routes:**
- Use `apiResponse` helpers from `@/lib/api-response`
- Add rate limiting for public endpoints
- Verify authentication with `await getSession()`

### 7. Performance Optimization

**Image Optimization:**
```typescript
import Image from 'next/image'

<Image
  src="/image.jpg"
  alt="Description"
  width={800}
  height={600}
  priority // For above-the-fold images
/>
```

**Dynamic Imports:**
```typescript
import dynamic from 'next/dynamic'

const HeavyComponent = dynamic(() => import('@/components/heavy'), {
  loading: () => <Spinner />,
  ssr: false, // Disable SSR if needed
})
```

**Font Optimization:**
```typescript
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export default function RootLayout({ children }) {
  return (
    <html className={inter.className}>
      <body>{children}</body>
    </html>
  )
}
```

### 8. Common Issues and Solutions

**Issue: "use client" not working**
- Ensure directive is at the very top of the file
- Check for server-only imports (db, server utilities)
- Verify no async components with 'use client'

**Issue: Hydration mismatch**
- Don't use Date.now() or Math.random() directly in render
- Ensure server and client render the same initial HTML
- Use useEffect for client-only rendering

**Issue: Route not found**
- Check file naming (must be page.tsx, layout.tsx, route.ts)
- Verify folder structure under app/
- Check for typos in dynamic segments

**Issue: Middleware not executing**
- Must be named middleware.ts in project root
- Check matcher configuration
- Ensure not blocking static files

### 9. Build and Deployment

**Build Command:**
```bash
pnpm build
```

**Environment Variables:**
- Use `NEXT_PUBLIC_` prefix for client-side variables
- Server-side variables don't need prefix
- Check `.env.example` for required variables

**Vercel Deployment:**
- Automatic deployment from Git
- Environment variables in Vercel dashboard
- Preview deployments for branches

### 10. Project-Specific Conventions

**Import Paths:**
- Use `@/*` for absolute imports
- Organize: React → External → @/* → Relative

**Styling:**
- Tailwind CSS v4 (CSS-based configuration)
- Use theme values from `styles/@theme.css`
- Mobile-first responsive design

**Database:**
- Use Server Actions for mutations
- Never import `db` in Client Components
- Use Drizzle ORM patterns

**Authentication:**
- Better Auth with role-based access
- Check auth in Server Components and Actions
- Use `<AuthGuard>` for protected pages

## When to Use This Skill

Invoke this skill when:
- Working with Next.js routing or file structure
- Deciding between Server and Client Components
- Implementing data fetching patterns
- Troubleshooting Next.js build or runtime errors
- Optimizing Next.js application performance
- Setting up metadata or SEO
- Working with middleware or API routes
