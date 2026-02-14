#!/usr/bin/env bash
set -e

NEW_NAME=$1
NEW_MODULE=$(echo "$NEW_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g') # snake_case -> CamelCase

if [ -z "$NEW_NAME" ]; then
  echo "Usage: ./rename_project.sh <new_snake_case_name>"
  exit 1
fi

echo "Renaming 'protocol_zero' -> '$NEW_NAME' (Module: $NEW_MODULE)..."

# 1. Rename Files
find . -depth -name "*protocol_zero*" -exec rename 's/protocol_zero/'"$NEW_NAME"'/' {} +

# 2. Replace Content
grep -rIl "protocol_zero" . | xargs sed -i "s/protocol_zero/$NEW_NAME/g"
grep -rIl "ProtocolZero" . | xargs sed -i "s/ProtocolZero/$NEW_MODULE/g"

echo "Done! You are now running Project $NEW_MODULE."
