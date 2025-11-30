---
description: Add a new shadcn/ui component
argument-hint: [component-name]
allowed-tools: Bash(npx:*)
---

Add the shadcn/ui component "$1" to the project:

```bash
npx shadcn@latest add $1
```

After adding:
1. Verify the component was added to components/ui/
2. Check for any TypeScript errors
3. Show example usage of the component
4. List any dependencies that were added
