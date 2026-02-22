#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
port="${1:-8000}"

if [ ! -d "${repo_dir}/docs" ]; then
  "${repo_dir}/build.sh"
fi

cd "${repo_dir}/docs"
python3 -m http.server "$port" --bind 0.0.0.0
