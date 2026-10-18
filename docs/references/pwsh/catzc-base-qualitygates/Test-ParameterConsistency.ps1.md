# pwsh/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: one parameter name means one type across the public functions.

### description

A caller learns a parameter once — `-Path` takes paths, `-TimeoutSeconds` takes whole seconds — so the same name carries the same type in
every public function ([ADR-PWSH-PARAM](../../../adr/pwsh/parameter-design.md),
[ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Reads every tracked public function file
(`pwsh/<Module>/<Name>.ps1`) and reports each parameter name whose declarations disagree on their element type
(Get-ParameterTypeConflict: `[string]` and `[string[]]` agree; untyped, `[object]` and `[psobject]` never conflict).

A name that genuinely means different things in different functions is listed in parameter-consistency.yml (`exempt`) with the reason; an
exempt name is not reported, and an exempt name that no longer conflicts is reported, so the list holds only what is real. Ends with
Write-QualityGateReport: the report lands in out/test-parameter-consistency/, and the gate throws once listing every issue (or returns the
result with -PassThru). Needs the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-parameter-consistency).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Functions; Exempt } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ParameterConsistency
```

### example 2

```powershell
(Test-ParameterConsistency -PassThru).Issues
```
