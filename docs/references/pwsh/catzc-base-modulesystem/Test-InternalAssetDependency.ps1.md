# pwsh/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every internal asset dependency is inventoried and covered by a test that runs in both run modes.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) enforcing the coverage rule
[ADR-AUTO-ASSETDEP#4](../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4) over the module code. It collects an
issue for:

- every Get-CatzcModuleRoot call site whose -ChildPath or -Module is not a string literal
  ([ADR-AUTO-ASSETDEP#2](../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)) — such a site cannot be
  inventoried (Get-InternalAssetDependency -Violation);
- every function with an internal asset dependency that no test citing
  [ADR-AUTO-ASSETDEP#3](../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3) and not source-only covers, so the
  read is exercised in the source run and the build run (Get-UncoveredInternalAssetDependency).

It scans the per-function source files and tests, which exist only in the source tree.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-internal-asset-dependency/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-InternalAssetDependency
```
