---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md
    kind: comment-page
    body_sha: b4b549d99f24
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TestRunFile' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-TestRunFile over fake Pester test objects (the shape the harness reads: .Block.BlockContainer.Data and
.ScriptBlock.File). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
