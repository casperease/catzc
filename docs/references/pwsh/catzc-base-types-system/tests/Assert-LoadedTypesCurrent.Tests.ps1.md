# pwsh/Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1

The L0 tests of `Assert-LoadedTypesCurrent`.

## Fixtures

The one measurement, `Get-LoadedTypeDrift` in `Catzc.Internal.Types`, is mocked at the module boundary
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)). The fixtures use neutral
names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
