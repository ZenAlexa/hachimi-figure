---
name: database-expert
description: Expert in Drizzle ORM, PostgreSQL, database design, migrations, and query optimization for this project. Use when working with database schema, queries, migrations, or performance issues.
---

# Database Expert - Drizzle ORM & PostgreSQL

Expert knowledge of Drizzle ORM, PostgreSQL, and database patterns specific to this project.

## Current Schema Overview

The project has 13 tables in `lib/db/schema.ts`:

### Core Tables
1. **user** - User accounts (Better Auth + Stripe + roles)
2. **session** - Authentication sessions
3. **account** - Social provider accounts
4. **verification** - Email verification tokens

### Business Tables
5. **pricingPlans** - Multi-locale pricing plans
6. **orders** - Payment transactions
7. **subscriptions** - Stripe subscriptions
8. **usage** - Credit balances (JSONB for flexibility)
9. **creditLogs** - Credit transaction audit trail

### Content Tables
10. **posts** - Blog posts with visibility control
11. **tags** - Blog tags
12. **postTags** - Many-to-many post-tag relationships
13. **newsletter** - Email subscriptions

## Drizzle ORM Patterns

### 1. Schema Definition

**Table Definition:**
```typescript
import { pgTable, text, integer, boolean, timestamp, jsonb } from 'drizzle-orm/pg-core'

export const users = pgTable('user', {
  id: text('id').primaryKey(),
  name: text('name'),
  email: text('email').notNull().unique(),
  role: text('role').notNull().default('user'), // 'user' | 'admin'
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at')
    .notNull()
    .defaultNow()
    .$onUpdate(() => new Date()),
})
```

**Relationships:**
```typescript
export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
  orders: many(orders),
}))

export const postsRelations = relations(posts, ({ one, many }) => ({
  author: one(users, {
    fields: [posts.authorId],
    references: [users.id],
  }),
  postTags: many(postTags),
}))
```

**Indexes:**
```typescript
export const users = pgTable('user', {
  // ... columns
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
  roleIdx: index('role_idx').on(table.role),
}))
```

### 2. Query Patterns

**Basic Select:**
```typescript
import { db } from '@/lib/db'
import { users } from '@/lib/db/schema'
import { eq } from 'drizzle-orm'

// Find one
const user = await db.query.users.findFirst({
  where: eq(users.id, userId),
})

// Find many
const allUsers = await db.query.users.findMany({
  where: eq(users.role, 'admin'),
  limit: 10,
  orderBy: (users, { desc }) => [desc(users.createdAt)],
})
```

**With Relations:**
```typescript
const postsWithAuthor = await db.query.posts.findMany({
  with: {
    author: true,
    postTags: {
      with: {
        tag: true,
      },
    },
  },
})
```

**Complex Queries:**
```typescript
import { and, or, like, gte, lte } from 'drizzle-orm'

const results = await db.select()
  .from(posts)
  .where(
    and(
      eq(posts.published, true),
      eq(posts.locale, 'en'),
      or(
        like(posts.title, '%search%'),
        like(posts.content, '%search%'),
      ),
      gte(posts.createdAt, startDate),
    )
  )
  .orderBy(desc(posts.createdAt))
  .limit(20)
  .offset(page * 20)
```

**Joins:**
```typescript
const results = await db
  .select({
    post: posts,
    author: users,
    tagCount: count(postTags.tagId),
  })
  .from(posts)
  .leftJoin(users, eq(posts.authorId, users.id))
  .leftJoin(postTags, eq(posts.id, postTags.postId))
  .groupBy(posts.id, users.id)
```

### 3. Insert Operations

**Single Insert:**
```typescript
const [newPost] = await db.insert(posts).values({
  title: 'New Post',
  content: 'Content',
  authorId: userId,
  locale: 'en',
  published: false,
}).returning()
```

**Bulk Insert:**
```typescript
await db.insert(tags).values([
  { name: 'Tag 1', slug: 'tag-1' },
  { name: 'Tag 2', slug: 'tag-2' },
  { name: 'Tag 3', slug: 'tag-3' },
])
```

**Insert with Conflict Handling:**
```typescript
await db.insert(users)
  .values({ email: 'user@example.com', name: 'User' })
  .onConflictDoUpdate({
    target: users.email,
    set: { name: 'Updated Name' },
  })
```

### 4. Update Operations

**Update Single:**
```typescript
await db.update(users)
  .set({ name: 'New Name', updatedAt: new Date() })
  .where(eq(users.id, userId))
```

**Conditional Update:**
```typescript
await db.update(posts)
  .set({ published: true, publishedAt: new Date() })
  .where(
    and(
      eq(posts.id, postId),
      eq(posts.authorId, userId),
    )
  )
```

### 5. Delete Operations

**Soft Delete (Preferred):**
```typescript
await db.update(posts)
  .set({ deleted: true, deletedAt: new Date() })
  .where(eq(posts.id, postId))
```

**Hard Delete:**
```typescript
await db.delete(posts)
  .where(eq(posts.id, postId))
```

**Cascade Delete:**
```typescript
// Delete related records first
await db.delete(postTags).where(eq(postTags.postId, postId))
await db.delete(posts).where(eq(posts.id, postId))
```

### 6. Transactions

**Using Transactions:**
```typescript
await db.transaction(async (tx) => {
  // Deduct credits
  await tx.update(usage)
    .set({ balance: sql`${usage.balance} - ${amount}` })
    .where(eq(usage.userId, userId))

  // Log transaction
  await tx.insert(creditLogs).values({
    userId,
    amount: -amount,
    type: 'deduction',
    description: 'API usage',
  })

  // Create order
  const [order] = await tx.insert(orders).values({
    userId,
    amount,
    status: 'completed',
  }).returning()

  return order
})
```

### 7. Aggregations

**Count:**
```typescript
const [{ count }] = await db
  .select({ count: sql<number>`count(*)` })
  .from(posts)
  .where(eq(posts.published, true))
```

**Sum:**
```typescript
const [{ total }] = await db
  .select({ total: sql<number>`sum(${orders.amount})` })
  .from(orders)
  .where(eq(orders.userId, userId))
```

**Group By:**
```typescript
const stats = await db
  .select({
    date: sql<string>`date(${orders.createdAt})`,
    count: sql<number>`count(*)`,
    total: sql<number>`sum(${orders.amount})`,
  })
  .from(orders)
  .groupBy(sql`date(${orders.createdAt})`)
  .orderBy(sql`date(${orders.createdAt}) desc`)
```

## Migration Workflow

### 1. Edit Schema

Make changes to `lib/db/schema.ts`:
```typescript
// Add new column
export const users = pgTable('user', {
  // ... existing columns
  phoneNumber: text('phone_number'), // New column
})

// Add new table
export const notifications = pgTable('notification', {
  id: text('id').primaryKey(),
  userId: text('user_id').notNull().references(() => users.id),
  message: text('message').notNull(),
  read: boolean('read').notNull().default(false),
  createdAt: timestamp('created_at').notNull().defaultNow(),
})
```

### 2. Generate Migration

```bash
pnpm db:generate
```

This creates a SQL file in `lib/db/migrations/` with:
- CREATE TABLE statements
- ALTER TABLE statements
- CREATE INDEX statements

### 3. Review Migration

Check the generated SQL file:
```sql
-- Example migration file
ALTER TABLE "user" ADD COLUMN "phone_number" text;

CREATE TABLE IF NOT EXISTS "notification" (
  "id" text PRIMARY KEY NOT NULL,
  "user_id" text NOT NULL,
  "message" text NOT NULL,
  "read" boolean DEFAULT false NOT NULL,
  "created_at" timestamp DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS "user_phone_idx" ON "user" ("phone_number");

ALTER TABLE "notification" ADD CONSTRAINT "notification_user_id_user_id_fk"
  FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE cascade ON UPDATE no action;
```

### 4. Apply Migration

```bash
pnpm db:migrate
```

### 5. Verify in Studio

```bash
pnpm db:studio
```

## Common Patterns in This Project

### 1. User Isolation

Always filter by userId for user-specific data:
```typescript
const userPosts = await db.query.posts.findMany({
  where: eq(posts.authorId, session.user.id),
})
```

### 2. Admin Queries

Check admin role before accessing all data:
```typescript
const session = await getSession()
if (!isAdmin(session)) {
  throw new Error('Unauthorized')
}

const allUsers = await db.query.users.findMany()
```

### 3. Pagination

Use limit and offset for pagination:
```typescript
const page = 1
const pageSize = 20

const posts = await db.query.posts.findMany({
  limit: pageSize,
  offset: (page - 1) * pageSize,
  orderBy: (posts, { desc }) => [desc(posts.createdAt)],
})
```

### 4. Search

Use ILIKE for case-insensitive search:
```typescript
import { ilike } from 'drizzle-orm'

const results = await db.query.posts.findMany({
  where: or(
    ilike(posts.title, `%${query}%`),
    ilike(posts.content, `%${query}%`),
  ),
})
```

### 5. JSONB Columns

The `usage` table uses JSONB for flexible data:
```typescript
await db.update(usage).set({
  metadata: {
    lastUsed: new Date().toISOString(),
    feature: 'ai-chat',
    model: 'gpt-4',
  },
})
```

## Performance Optimization

### 1. Indexes

Add indexes for frequently queried columns:
```typescript
export const posts = pgTable('posts', {
  // columns
}, (table) => ({
  publishedIdx: index('published_idx').on(table.published),
  localeIdx: index('locale_idx').on(table.locale),
  createdAtIdx: index('created_at_idx').on(table.createdAt),
  authorIdx: index('author_idx').on(table.authorId),
}))
```

### 2. Select Only Needed Columns

```typescript
// Bad: Select all columns
const posts = await db.select().from(posts)

// Good: Select only needed columns
const posts = await db.select({
  id: posts.id,
  title: posts.title,
  createdAt: posts.createdAt,
}).from(posts)
```

### 3. Use Prepared Statements

For frequently executed queries:
```typescript
const getUserById = db.query.users.findFirst({
  where: eq(users.id, sql.placeholder('id')),
}).prepare('get_user_by_id')

const user = await getUserById.execute({ id: userId })
```

### 4. Batch Operations

Use transactions for multiple related operations:
```typescript
await db.transaction(async (tx) => {
  // Multiple operations in single transaction
  await tx.insert(posts).values(newPost)
  await tx.insert(postTags).values(tags)
  await tx.update(users).set({ postCount: sql`${users.postCount} + 1` })
})
```

## When to Use This Skill

Invoke this skill when:
- Designing database schema or adding tables
- Writing complex queries or joins
- Creating or modifying migrations
- Troubleshooting database performance
- Implementing transactions
- Working with relationships
- Optimizing queries with indexes
- Handling JSONB data
