---
name: stripe-expert
description: Expert in Stripe integration for payments, subscriptions, webhooks, and customer management in this project. Use when working with payment flows, subscription management, or Stripe webhooks.
---

# Stripe Integration Expert

Expert knowledge of Stripe integration patterns, payment flows, subscription management, and webhook handling specific to this project.

## Project's Stripe Architecture

### Current Implementation

**Location:** Multiple locations
- Client initialization: `lib/stripe/index.ts`
- Server Actions: `actions/stripe/`
- API Routes: `app/api/stripe/`, `app/api/payment/`
- Webhooks: `app/api/stripe/webhook/route.ts`

**Payment Types Supported:**
1. **Subscriptions** - Recurring payments with tiers
2. **One-time payments** - Single purchase transactions
3. **Customer Portal** - Self-service subscription management

## Key Concepts

### 1. Stripe Client Initialization

**Server-side only:**
```typescript
// lib/stripe/index.ts
import Stripe from 'stripe'

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})
```

**Important:** Never initialize Stripe on the client with secret key.

### 2. Customer Management

**Create or Get Customer:**
```typescript
import { stripe } from '@/lib/stripe'
import { db } from '@/lib/db'
import { users } from '@/lib/db/schema'

async function getOrCreateCustomer(userId: string) {
  const user = await db.query.users.findFirst({
    where: eq(users.id, userId),
  })

  if (user.stripeCustomerId) {
    return user.stripeCustomerId
  }

  // Create new customer
  const customer = await stripe.customers.create({
    email: user.email,
    name: user.name,
    metadata: {
      userId: user.id,
    },
  })

  // Save to database
  await db.update(users)
    .set({ stripeCustomerId: customer.id })
    .where(eq(users.id, userId))

  return customer.id
}
```

**Update Customer:**
```typescript
await stripe.customers.update(customerId, {
  name: newName,
  email: newEmail,
  metadata: {
    customField: 'value',
  },
})
```

### 3. Subscription Flow

**Step 1: Create Checkout Session (Server Action)**
```typescript
'use server'

import { stripe } from '@/lib/stripe'
import { getSession } from '@/lib/auth/server'
import { actionResponse } from '@/lib/action-response'

export async function createSubscriptionCheckout(priceId: string) {
  const session = await getSession()
  if (!session) {
    return actionResponse.unauthorized()
  }

  const customerId = await getOrCreateCustomer(session.user.id)

  const checkoutSession = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [
      {
        price: priceId, // Stripe Price ID from pricingPlans table
        quantity: 1,
      },
    ],
    success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/pricing`,
    metadata: {
      userId: session.user.id,
      type: 'subscription',
    },
  })

  return actionResponse.success({ url: checkoutSession.url })
}
```

**Step 2: Redirect User (Client Component)**
```typescript
'use client'

import { createSubscriptionCheckout } from '@/actions/stripe/checkout'

async function handleSubscribe(priceId: string) {
  const result = await createSubscriptionCheckout(priceId)

  if (result.success && result.data.url) {
    window.location.href = result.data.url
  } else {
    // Handle error
    toast.error('Failed to create checkout session')
  }
}
```

**Step 3: Handle Webhook Events**
```typescript
// app/api/stripe/webhook/route.ts
import { stripe } from '@/lib/stripe'
import { db } from '@/lib/db'
import { subscriptions, orders } from '@/lib/db/schema'

export async function POST(req: Request) {
  const body = await req.text()
  const signature = req.headers.get('stripe-signature')!

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )
  } catch (err) {
    return new Response('Webhook signature verification failed', { status: 400 })
  }

  switch (event.type) {
    case 'checkout.session.completed':
      const session = event.data.object as Stripe.Checkout.Session
      await handleCheckoutCompleted(session)
      break

    case 'customer.subscription.created':
    case 'customer.subscription.updated':
      const subscription = event.data.object as Stripe.Subscription
      await handleSubscriptionUpdate(subscription)
      break

    case 'customer.subscription.deleted':
      const deletedSub = event.data.object as Stripe.Subscription
      await handleSubscriptionDeleted(deletedSub)
      break

    case 'invoice.payment_succeeded':
      const invoice = event.data.object as Stripe.Invoice
      await handleInvoicePaymentSucceeded(invoice)
      break

    case 'invoice.payment_failed':
      const failedInvoice = event.data.object as Stripe.Invoice
      await handleInvoicePaymentFailed(failedInvoice)
      break
  }

  return new Response(JSON.stringify({ received: true }), { status: 200 })
}
```

### 4. One-Time Payment Flow

**Create One-Time Checkout:**
```typescript
export async function createOneTimeCheckout(priceId: string, quantity = 1) {
  const session = await getSession()
  if (!session) {
    return actionResponse.unauthorized()
  }

  const customerId = await getOrCreateCustomer(session.user.id)

  const checkoutSession = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'payment', // One-time payment
    payment_method_types: ['card'],
    line_items: [
      {
        price: priceId,
        quantity,
      },
    ],
    success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/pricing`,
    metadata: {
      userId: session.user.id,
      type: 'one_time',
    },
  })

  return actionResponse.success({ url: checkoutSession.url })
}
```

### 5. Customer Portal

**Create Portal Session:**
```typescript
export async function createPortalSession() {
  const session = await getSession()
  if (!session) {
    return actionResponse.unauthorized()
  }

  const user = await db.query.users.findFirst({
    where: eq(users.id, session.user.id),
  })

  if (!user.stripeCustomerId) {
    return actionResponse.error('No Stripe customer found')
  }

  const portalSession = await stripe.billingPortal.sessions.create({
    customer: user.stripeCustomerId,
    return_url: `${process.env.NEXT_PUBLIC_SITE_URL}/dashboard/subscription`,
  })

  return actionResponse.success({ url: portalSession.url })
}
```

### 6. Webhook Event Handlers

**Handle Checkout Completed:**
```typescript
async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  const userId = session.metadata?.userId
  if (!userId) return

  // Create order record
  await db.insert(orders).values({
    id: session.id,
    userId,
    stripeCustomerId: session.customer as string,
    amount: session.amount_total! / 100, // Convert from cents
    currency: session.currency!,
    status: 'completed',
    type: session.mode === 'subscription' ? 'subscription' : 'one_time',
    metadata: {
      sessionId: session.id,
      paymentIntent: session.payment_intent,
    },
  })

  // If subscription, create subscription record
  if (session.mode === 'subscription' && session.subscription) {
    const subscription = await stripe.subscriptions.retrieve(
      session.subscription as string
    )
    await handleSubscriptionUpdate(subscription)
  }

  // Grant credits or benefits
  if (session.metadata?.credits) {
    await grantCredits(userId, parseInt(session.metadata.credits))
  }
}
```

**Handle Subscription Update:**
```typescript
async function handleSubscriptionUpdate(subscription: Stripe.Subscription) {
  const userId = subscription.metadata?.userId
  if (!userId) return

  const priceId = subscription.items.data[0]?.price.id

  await db.insert(subscriptions).values({
    id: subscription.id,
    userId,
    stripeCustomerId: subscription.customer as string,
    stripePriceId: priceId,
    status: subscription.status,
    currentPeriodStart: new Date(subscription.current_period_start * 1000),
    currentPeriodEnd: new Date(subscription.current_period_end * 1000),
    cancelAtPeriodEnd: subscription.cancel_at_period_end,
  }).onConflictDoUpdate({
    target: subscriptions.id,
    set: {
      status: subscription.status,
      stripePriceId: priceId,
      currentPeriodStart: new Date(subscription.current_period_start * 1000),
      currentPeriodEnd: new Date(subscription.current_period_end * 1000),
      cancelAtPeriodEnd: subscription.cancel_at_period_end,
      updatedAt: new Date(),
    },
  })
}
```

**Handle Payment Failed:**
```typescript
async function handleInvoicePaymentFailed(invoice: Stripe.Invoice) {
  const userId = invoice.subscription_details?.metadata?.userId
  if (!userId) return

  // Send email notification
  await sendPaymentFailedEmail(userId, {
    amount: invoice.amount_due / 100,
    currency: invoice.currency,
    invoiceUrl: invoice.hosted_invoice_url,
  })

  // Update subscription status
  await db.update(subscriptions)
    .set({ status: 'past_due' })
    .where(eq(subscriptions.id, invoice.subscription as string))
}
```

### 7. Credit System Integration

**Grant Credits After Payment:**
```typescript
async function grantCredits(userId: string, amount: number) {
  await db.transaction(async (tx) => {
    // Update usage balance
    const [usage] = await tx.select()
      .from(usage)
      .where(eq(usage.userId, userId))

    if (usage) {
      await tx.update(usage)
        .set({ balance: usage.balance + amount })
        .where(eq(usage.userId, userId))
    } else {
      await tx.insert(usage).values({
        userId,
        balance: amount,
      })
    }

    // Log credit transaction
    await tx.insert(creditLogs).values({
      userId,
      amount,
      type: 'purchase',
      description: 'Credits purchased via Stripe',
    })
  })
}
```

### 8. Testing with Stripe CLI

**Install Stripe CLI:**
```bash
brew install stripe/stripe-cli/stripe
```

**Login:**
```bash
stripe login
```

**Forward Webhooks to Local:**
```bash
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

**Trigger Test Events:**
```bash
stripe trigger checkout.session.completed
stripe trigger customer.subscription.created
stripe trigger invoice.payment_failed
```

**Test Cards:**
```
Success: 4242 4242 4242 4242
Decline: 4000 0000 0000 0002
3D Secure: 4000 0025 0000 3155
```

## Common Patterns in This Project

### 1. Price Management

Prices are stored in the `pricingPlans` table with Stripe Price IDs:
```typescript
const plan = await db.query.pricingPlans.findFirst({
  where: and(
    eq(pricingPlans.id, planId),
    eq(pricingPlans.locale, locale),
  ),
})

// Use plan.stripePriceId for checkout
```

### 2. Subscription Status Checks

```typescript
async function hasActiveSubscription(userId: string) {
  const subscription = await db.query.subscriptions.findFirst({
    where: and(
      eq(subscriptions.userId, userId),
      inArray(subscriptions.status, ['active', 'trialing']),
    ),
  })

  return !!subscription
}
```

### 3. Feature Gating

```typescript
async function canAccessFeature(userId: string, feature: string) {
  const subscription = await db.query.subscriptions.findFirst({
    where: and(
      eq(subscriptions.userId, userId),
      eq(subscriptions.status, 'active'),
    ),
    with: {
      plan: true,
    },
  })

  return subscription?.plan?.features?.includes(feature) || false
}
```

## Best Practices

### 1. Security

- ✅ Always verify webhook signatures
- ✅ Never expose secret key on client
- ✅ Validate amount and currency before processing
- ✅ Use metadata to track userId, not customer name
- ✅ Implement idempotency for webhook handlers

### 2. Error Handling

```typescript
try {
  const session = await stripe.checkout.sessions.create({
    // ...
  })
  return actionResponse.success({ url: session.url })
} catch (error) {
  if (error instanceof Stripe.errors.StripeError) {
    console.error('Stripe error:', error.message)
    return actionResponse.error(error.message)
  }
  throw error
}
```

### 3. Idempotency

Use idempotency keys for critical operations:
```typescript
await stripe.paymentIntents.create(
  {
    amount: 1000,
    currency: 'usd',
    customer: customerId,
  },
  {
    idempotencyKey: `payment-${userId}-${timestamp}`,
  }
)
```

### 4. Webhook Retries

Stripe retries failed webhooks. Handle duplicates:
```typescript
async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  // Check if already processed
  const existing = await db.query.orders.findFirst({
    where: eq(orders.id, session.id),
  })

  if (existing) {
    return // Already processed
  }

  // Process payment
  // ...
}
```

## Environment Variables Required

```env
# Stripe
STRIPE_SECRET_KEY=sk_test_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Feature flags
NEXT_PUBLIC_ENABLE_STRIPE=true
```

## When to Use This Skill

Invoke this skill when:
- Implementing payment or subscription flows
- Setting up Stripe webhooks
- Debugging payment issues
- Adding new pricing plans
- Managing customer subscriptions
- Integrating credit system with payments
- Testing Stripe integration
- Handling refunds or disputes
