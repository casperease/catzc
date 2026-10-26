---
name: artifact-print
description: >
  Republish the Diagram Waves Review page from the diagrams on disk to the same link, its answers kept, and print every drawing and the
  answers so far; never draws, edits or answers; the user invokes it; input is the page URL.
user-invocable: true
allowed-tools: Bash, Read, Write, Artifact, ArtifactData
paths: out/diagrams/**, out/print-artifacts/**
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [uv]
---

# artifact-print

Publish what is on disk, exactly as it is now; never draw, edit or move a diagram, never write an answer.

1. Background Bash `timeout 60 uv run -q --project <repo>/python python -m catzc.diagrams.catalogue`; it writes
   `out/print-artifacts/catalogue.json` and prints one line per diagram.
2. `Artifact read` the URL and build from the saved file it names, never from memory; `Artifact list` with `scope: files` gives what the
   page serves now.
3. In the saved file replace the whole `const DIAGRAMS = [...];` line with the catalogue JSON and nothing else; if the line is missing, stop
   and report, never rebuild the page.
4. `Artifact publish` to the same `url` with `root: out/diagrams` and a `files` map: each `wave-N/<area>/<name>.drawio.png` to itself, each
   `.verify.md` as `{from, contentType: text/plain}`, `null` for a served path no longer on disk; omit `capabilities` and `icon` so the page
   keeps its database and icon; on a conflict read again and redo once.
5. Print the page link and what changed since the last publish; every drawing as a plain local path grouped by area with its wave and
   check-note counts; a png no longer matching its yml listed as a conflict or stale (drawio-declaration step 2), never re-put here.
6. `ArtifactData list` `collection: verdicts` reads the answers as data, never written: one line per answered diagram
   (`<id> — <choice> — <note>`), then the count pending; recommend nothing.
