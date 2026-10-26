# pwsh/Base.ModuleSystem/Test-ModuleDependency.ps1

A quality gate that holds the real module edges to the declared dependency graph. The rules live in the private query
`Get-ModuleDependencyViolations`. This command reports its findings through the quality-gate report.

## help

### synopsis

Checks that the actual module dependencies conform to the declared graph.

### description

Compares the real module-to-module edges — PowerShell function calls and cross-module C# type references — against the allow-list declared
in configs/dependencies.yml (see Get-ModuleDependencyViolations for the rules), collects every violation, and ends with
Write-QualityGateReport ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report
lands in out/test-module-dependency/, and the gate throws once listing every violation (or returns the result with -PassThru).

A structurally invalid config throws at load time (via Get-ModuleDependencyConfig) before any conformance check runs — a malformed config is
a bug to fix, not a conformance result.

Must run post-import so the actual call graph covers all loaded modules.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-module-dependency).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath } instead of throwing on violations.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ModuleDependency
```

### example 2

```powershell
(Test-ModuleDependency -PassThru).Issues
```
