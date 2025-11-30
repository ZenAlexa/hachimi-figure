---
description: Check required environment variables
---

Check if all required environment variables are properly configured:

1. Read .env.example to see required variables
2. Check if .env.local exists
3. Verify critical variables are set (without revealing their values):
   - DATABASE_URL
   - BETTER_AUTH_SECRET
   - NEXT_PUBLIC_SITE_URL
   - Other required variables based on enabled features

Report which variables are:
- ✅ Configured
- ⚠️ Optional (feature flags disabled)
- ❌ Missing but required

Do NOT display the actual values of sensitive variables.
