# pwsh/Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1

The integrity test of the internal asset coverage rule over the real tree, run through its quality gate, `Test-InternalAssetDependency`
([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically),
[ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## What it proves

Every `Get-CatzcModuleRoot` call site passes literal values, and every function that reads an internal asset has a test citing
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)
that is not source-only, so the read is exercised in both the source run and the build run. The gate scans the per-function `.ps1` files and
the tests, which only the source tree has, so the test is source-only.
