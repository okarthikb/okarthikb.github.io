#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Usage: ./update.sh \"Post Title\""
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
"${script_dir}/new-post.sh" "$1"
