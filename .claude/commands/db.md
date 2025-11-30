Database operation request: $ARGUMENTS

Guidelines:
1. Use Drizzle ORM patterns from /lib/db
2. Follow the existing schema patterns in /lib/db/schema.ts
3. Create proper indexes for frequently queried fields
4. Use appropriate data types (uuid, timestamp with timezone, etc.)
5. Add proper foreign key relationships with cascade rules
6. Include created_at and updated_at timestamps
7. Generate migration if schema changes are needed

Commands reference:
- Generate migration: pnpm db:generate
- Apply migration: pnpm db:migrate
- Push schema: pnpm db:push
- Open studio: pnpm db:studio
