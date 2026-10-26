# pwsh/Base.QualityGates/Test-AnalyzerDrsMap.ps1

The gate over `analyzer-drs-map.yml`: it checks that the map cites only real ADR rules and that every custom analyzer rule is mapped.

## help

### synopsis

Checks that analyzer-drs-map.yml cites only real ADR rules and maps every custom analyzer rule.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the shipped
analyzer map (configs/analyzer-drs-map.yml), the source of the 'pssa-rule' enforcer kind in the rule-coverage report
([ADR-PWSH-FORMAT-ANALYZERADRMAPPING](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-analyzeradrmapping)). The
config load checks only its shape, so it stays hermetic; this gate cross-checks it against the repository and collects an issue for:

- every rule id an analyzer cites that is not a real ADR rule (Get-CatsDrsRuleIds, in '#' citation form);
- every custom analyzer check — a `Measure-*` function in `pwsh/.scriptanalyzer/*.psm1`, except the entry rule CatzcRules.psm1, which only
  dispatches — the map does not list, so a new custom rule cannot ship unmapped.

It reads the ADR tree and the .scriptanalyzer rule files, which exist only in the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-analyzer-adr-map/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Analyzers; CustomRules }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-AnalyzerDrsMap
```

## Rule ids

The rule ids are the codes the map cites, so they compare as they are. The typed `[string[]]` assignment receives the comma-wrapped getter
result intact, where `@()` would nest it.
