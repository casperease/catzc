# pwsh/Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1

The logic tests of the coverage gate's engine
([ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically)),
run over a TestKit fixture tree. They prove which functions with an internal asset dependency lack a test that cites
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest) and
is not source-only. The fixture test files are parsed, never run, and the names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
