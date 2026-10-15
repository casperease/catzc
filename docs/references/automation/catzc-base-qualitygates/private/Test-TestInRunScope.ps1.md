---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md
    kind: comment-page
    body_sha: "9f2b6c27e732"
---

# automation/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$level = Get-TestBlockTag -Test $Test -Valid...`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```
