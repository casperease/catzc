# automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every `Assert-<Name>Config` validator maps to a `configs/<name>.yml` in its own module.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the
PowerShell validator convention of Invoke-ConfigValidator: a validator is found by name — the
`Assert-<TitleCase(name)>Config` of the module that ships `configs/<name>.yml` — so a validator whose name maps to
no shipped config is never called. It lists every such orphan.

It walks the module folders of the loaded code root (Get-CatzcModulesRoot), so it checks the shipped configs of
whichever tree the modules were loaded from — the source tree or a built package
([ADR-DSGN-RUNMODE#2](../../../adr/design/run-modes.md#rule-adr-dsgn-runmode2)) — and reads each loaded module's own
validators from its scope (private functions are scope-isolated, so a module lists only its own).

### parameter OutputFolder

The report base folder. Defaults to out/test-config-validators/ (Write-QualityGateReport).

### parameter PassThru

Return the result ({ Subject; IssueCount; Issues; ReportPath; Validators }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-ConfigValidators
```
