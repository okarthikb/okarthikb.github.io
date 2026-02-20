#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
remote="${REMOTE:-origin}"
branch="${1:-gh-pages}"
timestamp="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"

if ! git -C "$repo_dir" diff --quiet || ! git -C "$repo_dir" diff --cached --quiet; then
  echo "Working tree is not clean. Commit or stash changes before deploy."
  exit 1
fi

echo "Building site locally..."
(cd "$repo_dir" && cabal run site build)
touch "$repo_dir/_site/.nojekyll"

tmp_worktree="$(mktemp -d "${TMPDIR:-/tmp}/site-deploy.XXXXXX")"

cleanup() {
  git -C "$repo_dir" worktree remove --force "$tmp_worktree" >/dev/null 2>&1 || true
  rm -rf "$tmp_worktree"
}
trap cleanup EXIT

if git -C "$repo_dir" show-ref --verify --quiet "refs/heads/$branch"; then
  git -C "$repo_dir" worktree add "$tmp_worktree" "$branch" >/dev/null
elif git -C "$repo_dir" ls-remote --exit-code --heads "$remote" "$branch" >/dev/null 2>&1; then
  git -C "$repo_dir" fetch "$remote" "$branch" >/dev/null
  git -C "$repo_dir" worktree add -b "$branch" "$tmp_worktree" "$remote/$branch" >/dev/null
else
  git -C "$repo_dir" worktree add --detach "$tmp_worktree" >/dev/null
  git -C "$tmp_worktree" switch --orphan "$branch" >/dev/null
fi

find "$tmp_worktree" -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} +
cp -a "$repo_dir/_site/." "$tmp_worktree/"
touch "$tmp_worktree/.nojekyll"

git -C "$tmp_worktree" add -A
if git -C "$tmp_worktree" diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

git -C "$tmp_worktree" commit -m "Deploy site $timestamp" >/dev/null
git -C "$tmp_worktree" push "$remote" "$branch"

echo "Deployed _site to $remote/$branch"
