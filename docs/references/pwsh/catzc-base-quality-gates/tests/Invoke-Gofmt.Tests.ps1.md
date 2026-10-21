# pwsh/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-Gofmt' -Tag 'L0', 'logic' {`, written with `#`.

```text
The gofmt engine with its seams mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/adr/automation/test-automation.md#rule-adr-auto-test-noovermocking)):
the tool probe (Resolve-ToolExecutable) finding a managed go beside a fixture gofmt in $TestDrive, and gofmt itself
(Invoke-Executable). Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
