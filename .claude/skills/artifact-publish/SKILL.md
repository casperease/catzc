---
name: artifact-publish
description: Republish the Diagram Waves Review page from the catalogue on disk, keeping its answers; for print-artifacts; input is the page URL and out/print-artifacts/catalogue.json.
user-invocable: false
allowed-tools: Artifact, ArtifactData, Read
paths: out/diagrams/**, out/print-artifacts/**
metadata: { catzc: { model_floor: haiku, needs: [uv] } }
catzc:
  immutable:
    with_body_sha: ba54a85632e6
    path: ".claude/skills/artifact-publish/SKILL.md"
    folder: skills/artifact-publish
    name: skill
    filetype: md
    kind: capability
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---
1. `Artifact read` the URL and build from the saved file it names, never from memory; `Artifact list` with `scope: files` gives what the page serves now.
2. In the saved file replace the whole `const DIAGRAMS = [...];` line with the catalogue JSON and nothing else; if the line is missing, stop and report, never rebuild the page.
3. `Artifact publish` to the same `url` with `root: out/diagrams` and a `files` map: each `wave-N/<area>/<name>.drawio.png` to itself, each `.verify.md` as `{from, contentType: text/plain}`, `null` for a served path no longer on disk; omit `capabilities` and `icon` so the page keeps its database and icon; on a conflict read again and redo once; then `ArtifactData list` `collection: verdicts` reads the answers as data, never written.
