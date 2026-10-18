# pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES-ONEDRIFTMEASURE' {`, written with `#`.

```text
Test-LoadedTypesCurrent with the one measurement (Get-LoadedTypeDrift, in Catzc.Internal.Types) mocked at the module
boundary ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/adr/automation/test-automation.md#rule-adr-auto-test-noovermocking)); its own logic is tested in
.internal/tests/Get-LoadedTypeDrift.Tests.ps1. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
