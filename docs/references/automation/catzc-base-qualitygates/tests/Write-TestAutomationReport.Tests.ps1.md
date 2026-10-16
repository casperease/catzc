---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationReport.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: aff3894ab09c
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-Row {`, written with `#`.

```text
Rows are the plain per-test shape ConvertTo-TestAutomationRowSet produces — built directly here,
since the report never sees a live Pester object.
```
