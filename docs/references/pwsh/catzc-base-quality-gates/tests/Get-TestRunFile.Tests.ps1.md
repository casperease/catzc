# pwsh/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TestRunFile' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-TestRunFile over fake Pester test objects (the shape the harness reads: .Block.BlockContainer.Data and
.ScriptBlock.File). Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
