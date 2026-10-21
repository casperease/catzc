# pwsh/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-BicepFormat' -Tag 'L0', 'logic' {`, written with `#`.

```text
The bicep engine with the tool boundary mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)):
the probe finds a managed Bicep CLI, and the mock writes the --outfile copy the engine compares. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {`, written with `#`.

```text
The fake formatter collapses runs of spaces in every file the --pattern names, in place, as `bicep format
--pattern` does.
```
