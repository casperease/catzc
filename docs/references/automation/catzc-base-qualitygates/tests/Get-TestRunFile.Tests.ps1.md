---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md
    kind: test-asset
    body_sha: e18b8c9aa2c3
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-TestRunFile' -Tag 'L0', 'logic' {`.

```text
Get-TestRunFile over fake Pester test objects (the shape the harness reads: .Block.BlockContainer.Data and
.ScriptBlock.File). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
