---
description: Build and analyze bundle size
allowed-tools: Bash(pnpm:*)
---

Build the project with bundle analyzer to inspect the bundle size:

```bash
pnpm analyze
```

Wait for the build to complete and the browser to open with the bundle analyzer visualization.

After analyzing:
1. Identify the largest dependencies
2. Look for duplicate packages
3. Check for opportunities to use dynamic imports
4. Report findings with specific package names and sizes
