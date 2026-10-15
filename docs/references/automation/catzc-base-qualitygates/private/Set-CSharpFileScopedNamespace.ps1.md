---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md
    kind: comment-page
    body_sha: a98fae25f179
---

# automation/Catzc.Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `for ($i = 0; $i -lt $lines.Count; $i++) {`.

```text
An existing namespace declaration: correct a file-scoped one in place (no-op when already right);
leave a block-scoped one (file-scoped lines end with ';'; anything else is a block) untouched — not a
shape we author, so Format-Types reports it rather than this helper double-declaring.
```
