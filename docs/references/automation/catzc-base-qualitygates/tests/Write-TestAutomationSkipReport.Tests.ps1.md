---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationSkipReport.Tests.ps1.md
    kind: test-asset
    body_sha: "133011b7714c"
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationSkipReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the report's
information-stream output can be asserted (see console-output-matters / Write-InformationColored).
```

## comment:2

Above `function New-Row {`.

```text
Rows are the plain per-test shape ConvertTo-TestAutomationRowSet produces — the report never sees
a live Pester object. SkipReason is pre-resolved by the reducer in the process that ran the test.
```
