# pwsh/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-Prettier'`, written with `#`.

```text
The prettier engine with the tool boundary mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)):
never launch a real process in a unit test. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
