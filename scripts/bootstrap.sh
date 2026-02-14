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

# 2. Case Generation
# Snake: protocol_zero -> speakless
CURRENT_SNAKE="protocol_zero"
NEW_SNAKE="$NEW_NAME"

# Pascal: ProtocolZero -> Speakless
CURRENT_PASCAL="ProtocolZero"
NEW_PASCAL=$(echo "$NEW_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Kebab: protocol-zero -> speakless
CURRENT_KEBAB="protocol-zero"
NEW_KEBAB="${NEW_NAME//_/-}"

# Title: "Protocol Zero" -> "Speakless" (Human Readable)
CURRENT_TITLE="Protocol Zero"
# Replace underscores with spaces, then capitalize first letter of each word
NEW_TITLE=$(echo "$NEW_NAME" | sed 's/_/ /g' | sed -e 's/\b\(.\)/\u\1/g')

echo "   Snake:  $CURRENT_SNAKE  -> $NEW_SNAKE"
echo "   Pascal: $CURRENT_PASCAL -> $NEW_PASCAL"
echo "   Kebab:  $CURRENT_KEBAB  -> $NEW_KEBAB"
echo "   Title:  $CURRENT_TITLE  -> $NEW_TITLE"

# 3. Rename Logic

# A. Directories (if they exist)
if [ -d "core/lib/$CURRENT_SNAKE" ]; then
    mv "core/lib/$CURRENT_SNAKE" "core/lib/$NEW_SNAKE"
fi

# B. File Content Replacements
# We use grep to find files to avoid editing binary/git artifacts
# 1. Snake Case (code)
grep -rFl "$CURRENT_SNAKE" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_SNAKE/$NEW_SNAKE/g"

# 2. Pascal Case (modules)
grep -rFl "$CURRENT_PASCAL" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_PASCAL/$NEW_PASCAL/g"

# 3. Kebab Case (filenames/package.json)
grep -rFl "$CURRENT_KEBAB" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_KEBAB/$NEW_KEBAB/g"

# 4. Title Case (Human Labels/UI)
grep -rFl "$CURRENT_TITLE" . --exclude-dir={.git,.direnv,node_modules,deps,_build,priv} | xargs sed -i "s/$CURRENT_TITLE/$NEW_TITLE/g"


echo "✅ Codebase Renamed."

# 4. Git Reset (The "Sovereign" Step)
echo "🔥 Nuke & Repave: Resetting Git History..."
rm -rf .git
git init
git branch -M main

# 5. Initial Commit
git add .
git commit -m "feat: Genesis of $NEW_TITLE"

echo "✅ Git Re-initialized."
echo ""
echo "🎉 PROJECT READY!"
echo "------------------------------------------------"
echo "👉 1. Setup Backend:  cd core && direnv allow"
echo "👉 2. Setup Frontend: cd ui && direnv allow"
