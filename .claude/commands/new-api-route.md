---
description: Create a new API route handler
argument-hint: [route-path]
---

Create a new API route at "app/api/$1/route.ts" following Next.js App Router conventions:

1. Use TypeScript
2. Import NextRequest from 'next/server'
3. Import apiResponse from @/lib/api-response
4. Include rate limiting for public endpoints
5. Add authentication check if needed
6. Implement proper error handling
7. Export named functions for HTTP methods (GET, POST, PUT, DELETE)

Template:
```typescript
import { NextRequest } from 'next/server'
import { apiResponse } from '@/lib/api-response'
import { getSession } from '@/lib/auth/server'
import { rateLimit } from '@/lib/upstash/rate-limit'
import { getClientIPFromHeaders } from '@/lib/utils'

export async function POST(req: NextRequest) {
  try {
    // Rate limiting
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
    // ...

    return apiResponse.success(result)
  } catch (error) {
    console.error('API error:', error)
    return apiResponse.error('Internal server error')
  }
}
```
