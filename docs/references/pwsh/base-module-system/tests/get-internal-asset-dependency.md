# pwsh/Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1

The logic tests of the inventory of internal asset dependencies
([ADR-AUTO-ASSETDEP-LITERALCHILDPATH](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-literalchildpath)):
one record per `Get-CatzcModuleRoot` call site, derived from the code by AST. They run over a TestKit fixture tree with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
