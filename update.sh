#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Usage: ./update.sh \"Post Title\""
  exit 1
fi

title="$1"
script_dir="$(cd "$(dirname "$0")" && pwd)"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
date=$(date +%Y-%m-%d)
file="${script_dir}/posts/${date}-${slug}.md"
escaped_title=${title//\"/\\\"}

if [ -f "$file" ]; then
  echo "File already exists: $file"
  exit 1
fi

cat > "$file" << EOF
---
title: "${escaped_title}"
date: ${date}
---

EOF

echo "Created ${file#${script_dir}/}"
