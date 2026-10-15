---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md
    kind: comment-page
    body_sha: ca3d1a45f6c7
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$toInstant = {`.

```text
ConvertFrom-Json turns ISO timestamps into [datetime] (kind kept from the 'Z'/offset suffix); a string
cast would drop sub-second precision and the zone, so both shapes are read as instants here.
```
