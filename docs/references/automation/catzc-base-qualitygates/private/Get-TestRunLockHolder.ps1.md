---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: bff1eea7aa5d
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$toInstant = {`, written with `#`.

```text
ConvertFrom-Json turns ISO timestamps into [datetime] (kind kept from the 'Z'/offset suffix); a string
cast would drop sub-second precision and the zone, so both shapes are read as instants here.
```
