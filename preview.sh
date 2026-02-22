#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
port="${1:-8000}"

"${repo_dir}/build.sh"

cd "${repo_dir}/docs"
python -m http.server "$port" --bind 127.0.0.1
