---
description: Reset and reseed the database
allowed-tools: Bash(pnpm:*)
---

Reset the database by running migrations and seeding with initial data. Execute:

```bash
pnpm db:generate && pnpm db:migrate && pnpm db:seed
```

Confirm the operation completed successfully and show the output.
