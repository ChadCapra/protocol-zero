#!/usr/bin/env bash
set -e

NEW_NAME=$1

# 1. Validation
if [ -z "$NEW_NAME" ]; then
    echo "❌ Error: You must provide a project name."
    echo "Usage: ./scripts/bootstrap.sh <new_snake_case_name>"
    echo "Example: ./scripts/bootstrap.sh speakless"
    exit 1
fi

echo "🚀 Bootstrapping Project: $NEW_NAME"

# 2. Rename Logic (Snake & Pascal Case)
CURRENT_SNAKE="protocol_zero"
CURRENT_PASCAL="ProtocolZero"
NEW_PASCAL=$(echo "$NEW_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Rename "protocol-zero-ui" -> "speakless-ui" in package.json
sed -i "s/protocol-zero-ui/${NEW_NAME//_/-}-ui/g" ui/package.json

# Find and replace text in all files (excluding ignored dirs)
grep -rFl "$CURRENT_SNAKE" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_SNAKE/$NEW_NAME/g"
grep -rFl "$CURRENT_PASCAL" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_PASCAL/$NEW_PASCAL/g"

echo "✅ Codebase Renamed."

# 3. Git Reset (The "Sovereign" Step)
echo "🔥 Nuke & Repave: Resetting Git History..."
rm -rf .git
git init
git branch -M main

# 4. Initial Commit
git add .
git commit -m "feat: Genesis of $NEW_PASCAL"

echo "✅ Git Re-initialized."
echo ""
echo "🎉 PROJECT READY!"
echo "------------------------------------------------"
echo "👉 1. Setup Backend:  cd core && direnv allow"
echo "👉 2. Setup Frontend: cd ui && direnv allow"
