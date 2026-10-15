---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-AbandonedTestRun.ps1.md
    kind: comment-page
    body_sha: "9c5d442657d4"
---

# automation/Catzc.Base.QualityGates/private/Set-AbandonedTestRun.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$abandoned = [ordered]@{}`.

```text
ConvertFrom-Json turns an ISO timestamp into a local DateTime, which would be written back with the local
offset; every run record stamps UTC, so a date goes back as the UTC round-trip string it was read from.
```
