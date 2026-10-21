# pwsh/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-DotnetFormat' -Tag 'L0', 'logic' {`, written with `#`.

```text
The dotnet-format engine with the tool boundary mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/adr/automation/test-automation.md#rule-adr-auto-test-noovermocking)):
the mock answers like `dotnet format whitespace --verify-no-changes --report`, writing the JSON report the engine
reads. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
