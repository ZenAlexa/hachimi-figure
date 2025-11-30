#!/bin/bash

# Pre-commit hook for Claude Code
# This runs before git commits to ensure code quality

set -e

echo "🔍 Running pre-commit checks..."

# Check if pnpm is available
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is not installed. Please install pnpm first."
    exit 1
fi

# Run linter
echo "📝 Running ESLint..."
if pnpm lint; then
    echo "✅ Linting passed"
else
    echo "❌ Linting failed. Please fix the errors before committing."
    exit 1
fi

# Check TypeScript
echo "🔧 Checking TypeScript..."
if pnpm tsc --noEmit; then
    echo "✅ TypeScript check passed"
else
    echo "❌ TypeScript errors found. Please fix them before committing."
    exit 1
fi

# Check for sensitive data in .env files
echo "🔒 Checking for sensitive data..."
if git diff --cached --name-only | grep -E '\.env\.local|\.env\.production'; then
    echo "⚠️  Warning: You're about to commit .env files!"
    echo "❌ Aborting commit to prevent exposing secrets."
    exit 1
fi

# Check for TODO comments in staged files
echo "📋 Checking for TODO comments..."
TODO_COUNT=$(git diff --cached | grep -c "TODO:" || true)
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "⚠️  Warning: Found $TODO_COUNT TODO comments in staged changes"
    echo "Consider addressing them before committing"
fi

echo "✅ All pre-commit checks passed!"
exit 0
