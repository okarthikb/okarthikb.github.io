#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
out_dir="${repo_dir}/docs"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/site-build.XXXXXX")"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc is required but not installed."
  exit 1
fi

html_escape() {
  local value="$1"
  value="${value//&/&amp;}"
  value="${value//</&lt;}"
  value="${value//>/&gt;}"
  value="${value//\"/&quot;}"
  printf '%s' "$value"
}

read_meta() {
  local key="$1"
  local file="$2"
  awk -v key="$key" '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { exit }
    in_frontmatter && $0 ~ ("^" key ":[[:space:]]*") {
      sub("^" key ":[[:space:]]*", "", $0)
      gsub(/^"/, "", $0)
      gsub(/"$/, "", $0)
      print
      exit
    }
  ' "$file"
}

strip_frontmatter() {
  local file="$1"
  awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { in_frontmatter = 0; next }
    !in_frontmatter { print }
  ' "$file"
}

wrap_page() {
  local title="$1"
  local body_file="$2"
  local output_file="$3"
  local escaped_title
  escaped_title="$(html_escape "$title")"

  {
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${escaped_title}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.js"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/contrib/auto-render.min.js"
        onload="renderMathInElement(document.body, {
            delimiters: [
                {left: '\\\\[', right: '\\\\]', display: true},
                {left: '\\\\(', right: '\\\\)', display: false}
            ],
            ignoredClasses: ['no-math'],
            throwOnError: false
        });"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css">
    <link rel="stylesheet" href="/css/default.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (window.hljs && document.querySelector('pre code')) {
                hljs.highlightAll();
            }
        });
    </script>
</head>
<body>
    <div class="container">
        <main>
EOF
    cat "$body_file"
    cat <<'EOF'
        </main>
        <footer>
            © Karthik 2023-2026
        </footer>
    </div>
    <script>
        if (document.querySelector('blockquote.twitter-tweet')) {
            const twitterScript = document.createElement('script');
            twitterScript.async = true;
            twitterScript.src = 'https://platform.twitter.com/widgets.js';
            twitterScript.charset = 'utf-8';
            document.body.appendChild(twitterScript);
        }
    </script>
</body>
</html>
EOF
  } > "$output_file"
}

rm -rf "$out_dir"
mkdir -p "$out_dir/posts"

for dir_name in css images pdf _archive; do
  if [ -d "${repo_dir}/${dir_name}" ]; then
    cp -a "${repo_dir}/${dir_name}" "$out_dir/"
  fi
done

touch "$out_dir/.nojekyll"

post_manifest="${tmp_dir}/posts.txt"
find "${repo_dir}/posts" -maxdepth 1 -type f -name '*.md' | sort -r > "$post_manifest"

index_body_file="${tmp_dir}/index-body.html"
{
  cat <<'EOF'
<h1 class="post-title"><a href="/">Karthik's site</a></h1>

<h3>About</h3>

<p class="about">
    Hey. I'm Karthik, undergrad <a href="https://twitter.com/UWaterloo">@UWaterloo</a>, interested in all things AGI. Follow me <a href="https://twitter.com/akbirthko">@akbirthko</a> on Twitter and do not hesitate to reach out! <a href="https://github.com/okarthikb">GH</a>.
</p>

<h3>Posts</h3>

<ul class="post-list">
EOF

  while IFS= read -r post_file; do
    slug="$(basename "$post_file" .md)"
    title="$(read_meta title "$post_file")"
    date="$(read_meta date "$post_file")"
    printf '    <li>\n'
    printf '        <span class="post-item-date">[%s]</span>\n' "$(html_escape "$date")"
    printf '        <a href="/posts/%s.html">%s</a>\n' "$slug" "$(html_escape "$title")"
    printf '    </li>\n\n'
  done < "$post_manifest"

  cat <<'EOF'
    <li>
        <span class="post-item-date">[0000-00-00]</span>
        <a href="/old.html">Old</a>
    </li>
</ul>
EOF
} > "$index_body_file"

wrap_page "Home" "$index_body_file" "${out_dir}/index.html"

old_title="$(read_meta title "${repo_dir}/old.html")"
old_body_file="${tmp_dir}/old-body.html"
strip_frontmatter "${repo_dir}/old.html" > "$old_body_file"
wrap_page "$old_title" "$old_body_file" "${out_dir}/old.html"

while IFS= read -r post_file; do
  slug="$(basename "$post_file" .md)"
  title="$(read_meta title "$post_file")"
  date="$(read_meta date "$post_file")"
  post_content_file="${tmp_dir}/${slug}-content.html"
  post_body_file="${tmp_dir}/${slug}-body.html"

  pandoc \
    --from=markdown+tex_math_dollars+tex_math_double_backslash+latex_macros+raw_html \
    --to=html5 \
    --mathjax \
    --syntax-highlighting=none \
    "$post_file" \
    > "$post_content_file"

  {
    printf '<article>\n'
    printf '    <h1 class="post-title">%s</h1>\n' "$(html_escape "$title")"
    printf '    <span class="post-date">%s</span>\n' "$(html_escape "$date")"
    printf '    <p><a class="page-back" href="/" aria-label="Back to home">&#9756;</a></p>\n'
    cat "$post_content_file"
    printf '\n</article>\n'
  } > "$post_body_file"

  wrap_page "$title" "$post_body_file" "${out_dir}/posts/${slug}.html"
done < "$post_manifest"

echo "Built site into ${out_dir}"
