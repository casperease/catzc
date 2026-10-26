# pwsh/Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1

The L0 tests of `Test-LoadedTypesCurrent`.

## Fixtures

The one measurement, `Get-LoadedTypeDrift` in `Catzc.Internal.Types`, is mocked at the module boundary
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)); its own logic is tested in
`.internal/tests/Get-LoadedTypeDrift.Tests.ps1`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
