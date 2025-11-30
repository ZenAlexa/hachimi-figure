---
description: Create a new React component with TypeScript
argument-hint: [component-name] [path]
---

Create a new React component named "$1" at the path "$2" following the project's conventions:

1. Use TypeScript (.tsx extension)
2. Follow PascalCase naming
3. Include proper type definitions
4. Add 'use client' directive if it needs client-side interactivity
5. Import shadcn/ui components from @/components/ui when needed
6. Use Tailwind CSS for styling
7. Follow the import organization pattern:
   - React imports first
   - External packages
   - Internal @/* imports
   - Relative imports

Structure:
```typescript
'use client' // Only if needed

import { ComponentProps } from 'react'

interface Props {
  // Define props
}

export function ComponentName({ }: Props) {
  return (
    <div>
      {/* Component content */}
    </div>
  )
}
```
