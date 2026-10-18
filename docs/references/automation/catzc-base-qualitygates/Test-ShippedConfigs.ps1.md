# automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every shipped config has a registered C# config type and loads through it.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the config
registry ([ADR-CONF-LOADING#4](../../../adr/configuration/module-config-loading.md#rule-adr-conf-loading4)). It walks
the module folders of the loaded code root (Get-CatzcModulesRoot) — the source tree or a built package — and
lists every issue:

- a shipped `configs/<name>.yml` with no `type:` entry in configs.yml;
- a configs.yml entry that names no shipped config;
- a configs.yml type that does not resolve;
- a shipped config that does not load through Get-Config (its type rejects it).

A config several modules ship (glossary) is loaded once per owner, with -Module.

### parameter OutputFolder

The report base folder. Defaults to out/test-shipped-configs/ (Write-QualityGateReport).

### parameter PassThru

Return the result ({ Subject; IssueCount; Issues; ReportPath; Configs; Types }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-ShippedConfigs
```
