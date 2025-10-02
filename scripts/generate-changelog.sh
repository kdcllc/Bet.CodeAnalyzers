#!/bin/bash

# Script to manually generate changelog for a specific version
# Usage: ./scripts/generate-changelog.sh [version] [from-tag]

set -e

VERSION=${1:-""}
FROM_TAG=${2:-""}

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [from-tag]"
    echo "Example: ./scripts/generate-changelog.sh 2.1.0 v2.0.0"
    exit 1
fi

echo "Generating changelog for version $VERSION..."

# Get current date
CURRENT_DATE=$(date +"%Y-%m-%d")

# Check if we have gh CLI installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required but not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Generate changelog using GitHub CLI
echo "Fetching commits and pull requests..."

if [ -n "$FROM_TAG" ]; then
    RANGE="${FROM_TAG}..HEAD"
else
    # Get the latest tag
    LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -n "$LATEST_TAG" ]; then
        RANGE="${LATEST_TAG}..HEAD"
    else
        RANGE="HEAD"
    fi
fi

echo "Using range: $RANGE"

# Create temporary changelog entry
cat > temp_changelog_entry.md << EOF
## [$VERSION] - $CURRENT_DATE

EOF

# Get commits in the range and categorize them
echo "### 💥 Breaking Changes" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "BREAKING CHANGE:" | sed 's/^[a-f0-9]* BREAKING CHANGE: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md
echo "### 🚀 Features" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "CHANGE:" | grep -v "BREAKING CHANGE:" | sed 's/^[a-f0-9]* CHANGE: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md
echo "### 🐛 Bug Fixes" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "FIX:" | sed 's/^[a-f0-9]* FIX: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md
echo "### 🔒 Security" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "SECURITY:" | sed 's/^[a-f0-9]* SECURITY: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md
echo "### 🧪 Tests" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "TESTS:" | sed 's/^[a-f0-9]* TESTS: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md
echo "### 🔧 Maintenance" >> temp_changelog_entry.md
git log --oneline $RANGE | grep -i "CHORE:" | sed 's/^[a-f0-9]* CHORE: /- /' >> temp_changelog_entry.md || true

echo "" >> temp_changelog_entry.md

# Remove empty sections
sed -i '/^### .*/,/^$/{/^### .*/{N;/\n$/d;}}' temp_changelog_entry.md

# Create new changelog
echo "Updating CHANGELOG.md..."

# Create backup
cp CHANGELOG.md CHANGELOG.md.bak

# Create new changelog with the new entry inserted after [Unreleased]
awk '
/^## \[Unreleased\]/ {
    print $0
    print ""
    while ((getline line < "temp_changelog_entry.md") > 0) {
        print line
    }
    close("temp_changelog_entry.md")
    next
}
{ print }
' CHANGELOG.md.bak > CHANGELOG.md

# Update the links at the bottom
if [ -n "$FROM_TAG" ]; then
    # Update the [Unreleased] link to point to the new version
    sed -i "s|\[Unreleased\]: https://github.com/kdcllc/Bet.CodeAnalyzers/compare/.*\.\.\.HEAD|[Unreleased]: https://github.com/kdcllc/Bet.CodeAnalyzers/compare/v$VERSION...HEAD|" CHANGELOG.md

    # Add the new version link
    echo "[$VERSION]: https://github.com/kdcllc/Bet.CodeAnalyzers/compare/$FROM_TAG...v$VERSION" >> CHANGELOG.md
fi

# Clean up
rm temp_changelog_entry.md

echo "Changelog updated successfully!"
echo "Please review CHANGELOG.md and commit the changes."