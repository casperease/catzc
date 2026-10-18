# pwsh/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the functions with an internal asset dependency that no qualifying test covers — the coverage quality gate's engine.

### description

Takes the inventory (Get-InternalAssetDependency) and, for every function in it, looks for a test that satisfies
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest). The function's test files are the
ones in its own module's tests/ folder named for it: `<Function>.Tests.ps1`, or `<Function>.<suffix>.Tests.ps1` for a cross-cutting test
file ([ADR-PWSH-PESTER-TESTFILE](../../../../adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-testfile)). Each file is parsed, never run: every It block's
tags are the union of its own -Tag values and those of each enclosing Describe and Context (the block chain,
[ADR-AUTO-TEST-TWOMANDATORYTAGS](../../../../adr/automation/test-automation.md#rule-adr-auto-test-twomandatorytags)/27). A test qualifies when its chain carries the
citation 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' and does not carry 'source-only' — so it runs in both the source run and the build run.

Returns one record per uncovered function: { Module; Function; ChildPath; TestFile; Reason }, where Module is the module that defines the
function, ChildPath the child paths its calls read (sorted, unique; '.' for a call that names the module folder itself), and TestFile the
repository-relative test files that were inspected (empty when none exists). Returns nothing when every function is covered.

It rests on [ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically).

### parameter `ModulesRoot`

Path to the modules folder. Defaults to the loaded code root (Get-CatzcModulesRoot).

### parameter `Dependency`

The inventory to check. Defaults to Get-InternalAssetDependency over -ModulesRoot.

### outputs

`[pscustomobject]` One record per uncovered function.
