---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationSkipReport.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fae9c4665e33
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationSkipReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the report's
information-stream output can be asserted (see console-output-matters / Write-InformationColored).
```

## comment:2

Above `function New-Row {`, written with `#`.

```text
Rows are the plain per-test shape ConvertTo-TestAutomationRowSet produces — the report never sees
a live Pester object. SkipReason is pre-resolved by the reducer in the process that ran the test.
```
