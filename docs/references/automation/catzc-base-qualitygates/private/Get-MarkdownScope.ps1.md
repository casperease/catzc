---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md
    kind: comment-page
    body_sha: "5b56ff30f06c"
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown`.

```text
Every class comes from .gitattributes.
Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
```
