---
name: drawio-renderer
description:
  Fail-forward render of a given .drawio.png, always a source copy and a result PNG, model XML, a page of asserted text and the slide's
  minimaps regenerated when asked; for drawio-png; input is the PNG's repository path, optional model XML, asserted-text path, page,
  minimaps.
user-invocable: false
allowed-tools: Bash, Read
paths: docs/.assets/**/*.drawio.png, out/drawio/**
metadata:
  catzc:
    immutable:
      with_body_sha: cd4a2ab1f723
      repo_status: clean
      path: ".claude/skills/drawio-renderer/SKILL.md"
      folder: skills/drawio-renderer
      name: skill
      filetype: md
      kind: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: [uv, pillow, pwsh]
---

# drawio-renderer

1. Deterministic, background Bash, absolute paths:
   `timeout 360 uv run -q --with pillow python <repo>/.claude/drawio/drawio_forward.py <src> [<out_dir>]` plus any of `--page dark|model`,
   `--xml <model>`, `--assert <text.md>`, `--minimaps`, or for a whole folder
   `--all <folder> --stage prepare|highlight|join|all [--migrate] [--start A --end B]`; defaults (out_dir, page) come from
   `.claude/drawio/drawio.yml`; exit 0 clean, 2 warnings with every artifact still delivered, 3 no source, 124 the safeguard.
2. Forward the `src`, `result`, `model`, `slide`, `report` paths and every `warn` line verbatim; never retry, never edit the source or
   drawio.yml, never judge a warning away.
3. AI-bound remainder: none by default; only when the user asks for a look, Read the source copy and the result PNG and list what differs,
   or execute the parameter the user gave ("change this colour") through write-drawio-files.
