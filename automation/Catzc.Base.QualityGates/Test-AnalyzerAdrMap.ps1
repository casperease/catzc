<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-FORMAT#7
---
#>

<#
.SYNOPSIS
    Quality gate: analyzer-adr-map.yml cites only real ADR rules and maps every custom analyzer rule.
.DESCRIPTION
    The config load checks only shape to stay hermetic; this gate cross-checks the map against the repository.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-analyzer-adr-map/ (Write-QualityGateReport).
.PARAMETER PassThru
    Without it the gate throws on issues, so the result object is how a caller reads them instead.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-AnalyzerAdrMap
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
    # Plain assignment keeps the comma-wrapped getter result intact; wrapping it in @() would nest it.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md#comment3)
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
