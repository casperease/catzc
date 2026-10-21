# pwsh/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every internal asset dependency is inventoried and covered by a test that runs in both run modes.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) enforcing the
coverage rule
[ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-enforcedmechanically)
over the module code. It collects an issue for:

- every Get-CatzcModuleRoot call site whose -ChildPath or -Module is not a string literal
  ([ADR-AUTO-ASSETDEP-LITERALCHILDPATH](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-literalchildpath)) —
  such a site cannot be inventoried (Get-InternalAssetDependency -Violation);
- every function with an internal asset dependency that no test citing
  [ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest) and
  not source-only covers, so the read is exercised in the source run and the build run (Get-UncoveredInternalAssetDependency).

It scans the per-function source files and tests, which exist only in the source tree.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-internal-asset-dependency/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-InternalAssetDependency
```
