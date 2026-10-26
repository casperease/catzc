# pwsh/Base.ModuleSystem/Test-ModuleCycles.ps1

A quality gate that finds cycles in the real cross-module call graph. It covers every module, including those the declared allow-list leaves
unconstrained, so it catches what `Test-ModuleDependency` cannot.

## help

### synopsis

Checks that the real module-to-module call graph has no cycle.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the actual
cross-module function calls (Get-ModuleDependency). It sorts the graph topologically (Kahn's algorithm) and reports every module the sort
cannot place — each sits on a dependency cycle or is called from one.

This is the whole graph, every module included: Test-ModuleDependency checks the declared modules' edges against the allow-list in
configs/dependencies.yml, and an unconstrained module is outside that list, so a cycle through one is caught only here. It analyses the
per-function source files (Get-ModuleDependency).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-module-cycles/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules; Edges }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ModuleCycles
```
