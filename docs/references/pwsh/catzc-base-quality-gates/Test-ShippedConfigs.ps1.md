# pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every shipped config has a registered C# config type and loads through it.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the config
registry ([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)).
It walks the module folders of the loaded code root (Get-CatzcModulesRoot) — the source tree or a built package — and lists every issue:

- a shipped `configs/<name>.yml` with no `type:` entry in configs.yml;
- a configs.yml entry that names no shipped config;
- a configs.yml type that does not resolve;
- a shipped config that does not load through Get-Config (its type rejects it).

A config several modules ship (glossary) is loaded once per owner, with -Module.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-shipped-configs/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Configs; Types }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ShippedConfigs
```

## comment:1

Above `$raw = if ($isFolder) {`, written with `#`.

```text
The shipped file shows the defaults its type declares; a key may differ only with its reason in
configs.yml ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
```
