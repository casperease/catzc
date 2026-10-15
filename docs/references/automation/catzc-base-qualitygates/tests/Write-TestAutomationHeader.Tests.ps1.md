---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationHeader.Tests.ps1.md
    kind: test-asset
    body_sha: a7789fd81039
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationHeader.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
information-stream output can be asserted (see console-output-matters).
```
