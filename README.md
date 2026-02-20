# okarthikb.github.io

Hakyll-powered personal site.

## Workflow

1. Create a new post:

```bash
./update.sh "Post Title"
```

2. Edit the generated Markdown file in `posts/`.

3. Run local dev server with rebuilds:

```bash
cabal run site -- watch
```

Use this for normal writing, styling, and preview work.

4. Optional static-only preview (no auto rebuild):

```bash
cabal run site -- build
python -m http.server 8000 --directory _site
```

Use this only when you already built the site and just want to serve the output.

## Notes

- Media and embed blocks in Markdown are centered by default.
- PDFs in `pdf/` are copied directly to the final site.
