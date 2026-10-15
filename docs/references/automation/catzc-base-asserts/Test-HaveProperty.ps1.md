---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Test-HaveProperty.ps1.md
    kind: reference
    body_sha: "5d97b573b2c2"
    adrs: []
---

# automation/Catzc.Base.Asserts/Test-HaveProperty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.PARAMETER PropertyName` of the comment-based help.

```text
The property name to look for. Dotted paths (e.g. 'parent.child.value')
walk each level in turn; a missing or null-valued intermediate short-circuits to $false
rather than throwing.
```
