# pwsh/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-FormatScope' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-FormatScope with git mocked: the tracked files (Get-GitTrackedPath) and the .gitattributes classes
(Get-GitAttributeValue). Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
