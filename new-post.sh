#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./new-post.sh \"Post Title\""
  exit 1
fi

title="$1"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
date=$(date +%Y-%m-%d)
file="posts/${date}-${slug}.md"

if [ -f "$file" ]; then
  echo "File already exists: $file"
  exit 1
fi

cat > "$file" << EOF
---
title: ${title}
date: ${date}
---

EOF

echo "Created $file"
