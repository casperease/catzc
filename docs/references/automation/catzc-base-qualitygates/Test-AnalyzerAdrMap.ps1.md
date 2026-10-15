# docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md

`automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the shipped
analyzer map (configs/analyzer-adr-map.yml), the source of the 'pssa-rule' enforcer kind in the rule-coverage
report ([ADR-PWSH-FORMAT#7](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format7)). The config load checks
only its shape, so it stays hermetic; this gate cross-checks it against the repository and collects an issue for:

  - every rule id an analyzer cites that is not a real ADR rule (Get-CatsAdrRuleIds, in '#' citation form);
  - every custom analyzer check — a Measure-* function in automation/.scriptanalyzer/*.psm1, except the entry
    rule CatzcRules.psm1, which only dispatches — the map does not list, so a new custom rule cannot ship
    unmapped.

It reads the ADR tree and the .scriptanalyzer rule files, which exist only in the source tree (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; Analyzers; CustomRules }) instead of throwing on
issues.
```

## comment:3

Above `$ruleIds = Get-CatsAdrRuleIds`.

```text
The rule ids in '#' citation form, so they compare to the map. Plain assignment receives the comma-wrapped
getter result intact — @() would nest it.
```
