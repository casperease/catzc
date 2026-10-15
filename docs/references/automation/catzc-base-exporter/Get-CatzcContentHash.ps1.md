---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
    kind: reference
    body_sha: "990d6d7cf67b"
    adrs:
      - ADR-FLOW-CD-GLOBS#5
---

# automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The same durable-SHA recipe the globsets use
([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)), applied to every file under
-Path: per file a
SHA-256 over its bytes with every CR stripped (so a CRLF vs LF tree yields the same identity on any
machine), folded as <relative-path>|<digest> lines in ordinal path order, then one combined SHA-256 over
the fold — 64 lowercase hex chars. The relative path is forward-slashed and taken from -Path, so the hash
is stable wherever the tree is copied. This is the reproducibility proof an exported bundle carries
(build twice from one commit -> identical hash).
```

## comment:2

Section `.PARAMETER Exclude` of the comment-based help.

```text
Path-relative, forward-slashed file paths to omit from the hash — e.g. a build.json sidecar that itself
carries the hash, so it cannot be part of the content it identifies.
```
