---
catzc:
  immutable:
    with_body_sha: e87f3b06027a
    repo_status: locked
    path: docs/references/automation/catzc-base-objects/types/TypeShape.cs.md
    folder: docs/references/automation/catzc-base-objects/types
    name: type-shape-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#7
---

# automation/Catzc.Base.Objects/types/TypeShape.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class TypeShape`, written with `//`.

```text
The reflected properties of a type, read once. The table is keyed by Type and filled on first use: a loaded type cannot change in
a process (ADR-AUTO-TYPES#7), so an entry cannot go stale, and it is not a session cache of the file set (ADR-AUTO-CACHE).
```
