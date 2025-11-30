---
description: Guide for creating database migrations
---

Provide step-by-step guidance for creating a database migration:

1. **Edit the schema** in lib/db/schema.ts:
   - Show current schema structure
   - Explain Drizzle ORM syntax for common operations:
     - Adding tables
     - Adding columns
     - Adding indexes
     - Adding relationships
     - Modifying existing columns

2. **Generate migration**:
   ```bash
   pnpm db:generate
   ```
   This creates a SQL migration file in lib/db/migrations/

3. **Review migration**:
   - Check the generated SQL file
   - Verify it matches intended changes
   - Look for potential data loss

4. **Apply migration**:
   ```bash
   pnpm db:migrate
   ```

5. **Verify in Drizzle Studio**:
   ```bash
   pnpm db:studio
   ```

6. **Update seed data** if needed in lib/db/seed.ts

Common patterns:
- Use text('column_name') for strings
- Use integer('column_name') for numbers
- Use boolean('column_name') for booleans
- Use timestamp('column_name') for dates
- Use jsonb('column_name') for JSON data
- Add .notNull() for required fields
- Add .default() for default values
- Use references() for foreign keys
