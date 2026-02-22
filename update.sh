#!/bin/bash

set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
"${script_dir}/new-post.sh" "$@"
