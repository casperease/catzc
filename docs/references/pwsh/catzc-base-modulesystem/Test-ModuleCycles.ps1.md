# automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the real module-to-module call graph has no cycle.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the actual cross-module function
calls (Get-ModuleDependency). It sorts the graph topologically (Kahn's algorithm) and reports every module the sort cannot place — each sits
on a dependency cycle or is called from one.

This is the whole graph, every module included: Test-ModuleDependency checks the declared modules' edges against the allow-list in
configs/dependencies.yml, and an unconstrained module is outside that list, so a cycle through one is caught only here. It analyses the
per-function source files (Get-ModuleDependency).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-module-cycles/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules; Edges }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-ModuleCycles
```
