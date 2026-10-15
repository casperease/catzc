---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationReport.Tests.ps1.md
    kind: test-asset
    body_sha: "0a47914985c8"
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-Row {`.

```text
Rows are the plain per-test shape ConvertTo-TestAutomationRowSet produces — built directly here,
since the report never sees a live Pester object.
```
