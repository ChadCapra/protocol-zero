#!/usr/bin/env bash
set -e

NEW_NAME_SNAKE=$1
if [ -z "$NEW_NAME_SNAKE" ]; then
    echo "Usage: ./rename_project.sh <new_snake_case_name>"
    echo "Example: ./rename_project.sh speakless"
    exit 1
fi

# Convert "speakless" -> "Speakless" (PascalCase) for Elixir Modules
# This simple logic works for single words. For "my_project", it becomes "MyProject".
NEW_NAME_PASCAL=$(echo "$NEW_NAME_SNAKE" | sed -r 's/(^|_)([a-z])/\U\2/g')

CURRENT_SNAKE="protocol_zero"
CURRENT_PASCAL="ProtocolZero"
CURRENT_UI_NAME="protocol-zero-ui"
NEW_UI_NAME="${NEW_NAME_SNAKE//_/-}-ui"

echo "🚀 Renaming Project:"
echo "   Snake:  $CURRENT_SNAKE  -> $NEW_NAME_SNAKE"
echo "   Pascal: $CURRENT_PASCAL -> $NEW_NAME_PASCAL"
echo "   UI:     $CURRENT_UI_NAME -> $NEW_UI_NAME"

# 1. Replace Content in Files (Linux/GNU sed)
# Using grep to find files to avoid editing git/build artifacts
grep -rFl "$CURRENT_SNAKE" . --exclude-dir={.git,.direnv,_build,deps,node_modules,priv} | xargs sed -i "s/$CURRENT_SNAKE/$NEW_NAME_SNAKE/g"
grep -rFl "$CURRENT_PASCAL" . --exclude-dir={.git,.direnv,_build,deps,node_modules,priv} | xargs sed -i "s/$CURRENT_PASCAL/$NEW_NAME_PASCAL/g"

# Special case for package.json name (often uses hyphens)
sed -i "s/$CURRENT_UI_NAME/$NEW_UI_NAME/g" ui/package.json

# 2. Rename Directories (if any match the snake_case name)
# Note: In Elixir, lib/protocol_zero.ex is common, but we are using a scaffold structure.
# If you had lib/protocol_zero/, we would move it here.
if [ -d "core/lib/$CURRENT_SNAKE" ]; then
    mv "core/lib/$CURRENT_SNAKE" "core/lib/$NEW_NAME_SNAKE"
fi

echo "✅ Renaming complete. Note: You may need to run 'just setup' again to re-compile."
