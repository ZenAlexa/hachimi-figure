---
description: Create a new Server Action with validation
argument-hint: [action-name] [feature-path]
---

Create a new Server Action named "$1" in the "actions/$2" directory following the project's patterns:

1. Add 'use server' directive at the top
2. Import necessary dependencies:
   - zod for validation
   - db from @/lib/db
   - actionResponse from @/lib/action-response
   - getSession, isAdmin from @/lib/auth/server
3. Define Zod schema for input validation
4. Implement error handling
5. Check authentication/authorization
6. Return typed responses using actionResponse helpers

Template structure:
```typescript
'use server'

import { z } from 'zod'
import { db } from '@/lib/db'
import { actionResponse } from '@/lib/action-response'
import { getSession } from '@/lib/auth/server'

const schema = z.object({
  // Define schema
})

export async function actionName(data: z.infer<typeof schema>) {
  const validated = schema.safeParse(data)
  if (!validated.success) {
    return actionResponse.error('Invalid input', validated.error)
  }

  const session = await getSession()
  if (!session) {
    return actionResponse.unauthorized()
  }

  try {
    // Business logic
    return actionResponse.success(result)
  } catch (error) {
    console.error('Error:', error)
    return actionResponse.error('Operation failed')
  }
}
```
