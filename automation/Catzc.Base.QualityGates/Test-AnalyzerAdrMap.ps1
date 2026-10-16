<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
    name: test-analyzer-adr-map
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-FORMAT#7
  config:
    synopsis: 'Quality gate: analyzer-adr-map.yml cites only real ADR rules and maps every custom analyzer rule.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the shipped
      analyzer map (configs/analyzer-adr-map.yml), the source of the 'pssa-rule' enforcer kind in the rule-coverage
      report ([ADR-PWSH-FORMAT#7](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format7)). The config load checks
      only its shape, so it stays hermetic; this gate cross-checks it against the repository and collects an issue for:

        - every rule id an analyzer cites that is not a real ADR rule (Get-CatsAdrRuleIds, in '#' citation form);
        - every custom analyzer check — a Measure-* function in automation/.scriptanalyzer/*.psm1, except the entry
          rule CatzcRules.psm1, which only dispatches — the map does not list, so a new custom rule cannot ship
          unmapped.

      It reads the ADR tree and the .scriptanalyzer rule files, which exist only in the source tree (Assert-SourceTree).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-analyzer-adr-map/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Analyzers; CustomRules }) instead of throwing on
        issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AnalyzerAdrMap
---
#>

function Test-AnalyzerAdrMap {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $map = Get-Config -Config analyzer-adr-map
    $ruleIds = Get-CatsAdrRuleIds
    [string[]] $citations = $ruleIds -replace ':', '#'
    $validIds = [System.Collections.Generic.HashSet[string]]::new($citations, [System.StringComparer]::Ordinal)

    $issues = [System.Collections.Generic.List[string]]::new()
    $mapped = @($map.analyzers.Keys)
    foreach ($analyzer in $mapped) {
        foreach ($id in @($map.analyzers[$analyzer])) {
            if (-not $validIds.Contains($id)) {
                $issues.Add("${analyzer}: cites $id, which is not a rule in docs/adr")
            }
        }
    }

    $customRules = [System.Collections.Generic.List[string]]::new()
    $ruleFiles = [System.IO.Directory]::EnumerateFiles((Resolve-RepoPath 'automation/.scriptanalyzer'), '*.psm1') |
        Where-Object { [System.IO.Path]::GetFileName($_) -ne 'CatzcRules.psm1' } |
        Sort-Object
    foreach ($file in $ruleFiles) {
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file), '(?m)^\s*function\s+(Measure-\w+)')) {
            $rule = $match.Groups[1].Value
            $customRules.Add($rule)
            if ($rule -notin $mapped) {
                $issues.Add("${rule}: a custom analyzer rule missing from analyzer-adr-map.yml — map it to the ADR rule(s) it enforces")
            }
        }
    }

    Write-QualityGateReport -Subject 'analyzer-adr-map' -Title 'Test-AnalyzerAdrMap' -Issues $issues `
        -Facts ([ordered]@{ Analyzers = $mapped.Count; CustomRules = $customRules.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
