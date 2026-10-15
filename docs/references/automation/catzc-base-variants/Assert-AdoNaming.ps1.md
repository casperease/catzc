---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Assert-AdoNaming.ps1.md
    kind: reference
    body_sha: d23b5b8b7b33
    adrs: []
---

# automation/Catzc.Base.Variants/Assert-AdoNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-AdoNaming. Pass exactly one of -Standard or -Classic; throws (naming the
actual order and where to change it) when the repo's order does not match. Guards a code path that only
holds under one naming convention.
```
