---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-AbandonedTestRun.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fdeda9fb8c79
---

# automation/Catzc.Base.QualityGates/private/Set-AbandonedTestRun.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$abandoned = [ordered]@{}`, written with `#`.

```text
ConvertFrom-Json turns an ISO timestamp into a local DateTime, which would be written back with the local
offset; every run record stamps UTC, so a date goes back as the UTC round-trip string it was read from.
```
