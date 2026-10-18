# pwsh/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks that the actual module dependencies conform to the declared graph.

### description

Compares the real module-to-module edges — PowerShell function calls and cross-module C# type references — against the allow-list declared
in configs/dependencies.yml (see Get-ModuleDependencyViolations for the rules), collects every violation, and ends with
Write-QualityGateReport ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
out/test-module-dependency/, and the gate throws once listing every violation (or returns the result with -PassThru).

A structurally invalid config throws at load time (via Get-ModuleDependencyConfig) before any conformance check runs — a malformed config is
a bug to fix, not a conformance result.

Must run post-import so the actual call graph covers all loaded modules.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-module-dependency).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath } instead of throwing on violations.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-ModuleDependency
```

### example 2

```powershell
(Test-ModuleDependency -PassThru).Issues
```
