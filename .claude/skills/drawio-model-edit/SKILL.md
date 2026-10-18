---
name: drawio-model-edit
description:
  Edit labels or styles in the model a .drawio.png embeds and re-render its raster so the two stay honest; for write-drawio-files; input is
  the PNG's repository path and the exact literals to change.
user-invocable: false
allowed-tools: Bash, Read, Write
paths: docs/.assets/**/*.drawio.png, out/drawio/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/drawio-model-edit/SKILL.md"
      folder: skills/drawio-model-edit
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: [uv, pillow]
---

# drawio-model-edit

<!-- cspell:ignore mxfile -->

1. Decode the model to `out/drawio/<stem>.xml` with `drawio_png.decode` (the `mxfile` tEXt chunk; labels are `value="…"` HTML-escaped,
   styles are `style="…"`); list the exact literals the brief touches and ask when one is ambiguous; a sibling `.$<name>.drawio.png.bkp`
   means the user has the file open, say so.
2. Apply each replacement to that file asserting its count; only the named cell's `value` or `style`, never geometry, cells or minimap
   images; a colour outside the STYLE.md tokens is surfaced, not applied; then background
   `timeout 120 uv run -q --with pillow python <repo>/.claude/drawio/drawio_png.py out/drawio/<stem>.xml <png>` (or
   `migrate_dark.py <png> <png>` for a dark migration, its `unmapped` colours reported, never guessed).
3. Verify by decoding the written file: every intended token present, no stale token, the XML parses, the PNG verifies, the model
   round-trips; then drawio-look at the result; a sister `.drawio.md` or article that now contradicts the slide is reported, never edited.
