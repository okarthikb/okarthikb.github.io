#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
remote="${REMOTE:-origin}"
branch="${1:-main}"
timestamp="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

echo "Building docs with pandoc..."
"$repo_dir/build.sh"

git -C "$repo_dir" add docs
if git -C "$repo_dir" diff --cached --quiet; then
  echo "No docs changes to commit."
  exit 0
fi

git -C "$repo_dir" commit -m "Build site $timestamp"
git -C "$repo_dir" push "$remote" "$branch"

echo "Pushed docs from main to $remote/$branch"
