#!/bin/bash

# Pre-build hook for Claude Code
# Runs before building the project

set -e

echo "🚀 Running pre-build checks..."

# Check if required environment variables are set
echo "🔐 Checking environment variables..."

REQUIRED_VARS=(
    "DATABASE_URL"
    "BETTER_AUTH_SECRET"
    "NEXT_PUBLIC_SITE_URL"
)

MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo "❌ Missing required environment variables:"
    for var in "${MISSING_VARS[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Please set these variables in .env.local before building."
    exit 1
fi

echo "✅ All required environment variables are set"

# Check if dependencies are installed
echo "📦 Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo "⚠️  node_modules not found. Running pnpm install..."
    pnpm install
fi

# Clean previous build
echo "🧹 Cleaning previous build..."
rm -rf .next

# Run TypeScript check
echo "🔧 Running TypeScript check..."
if pnpm tsc --noEmit; then
    echo "✅ TypeScript check passed"
else
    echo "❌ TypeScript errors found. Please fix them before building."
    exit 1
fi

echo "✅ Pre-build checks completed successfully!"
exit 0
