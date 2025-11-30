#!/bin/bash

# Post-build hook for Claude Code
# Runs after successful build

set -e

echo "📊 Post-build analysis..."

# Check build size
if [ -d ".next" ]; then
    BUILD_SIZE=$(du -sh .next | cut -f1)
    echo "📦 Build size: $BUILD_SIZE"
fi

# Check for large chunks
echo "🔍 Checking for large JavaScript chunks..."
LARGE_CHUNKS=$(find .next/static/chunks -name "*.js" -size +500k 2>/dev/null || true)

if [ -n "$LARGE_CHUNKS" ]; then
    echo "⚠️  Warning: Found large JavaScript chunks (>500KB):"
    echo "$LARGE_CHUNKS" | while read -r file; do
        SIZE=$(du -h "$file" | cut -f1)
        echo "   - $(basename "$file"): $SIZE"
    done
    echo ""
    echo "Consider code splitting or dynamic imports to reduce bundle size."
fi

# Generate build report
echo "📝 Build completed at: $(date)"

echo "✅ Post-build analysis completed!"
exit 0
