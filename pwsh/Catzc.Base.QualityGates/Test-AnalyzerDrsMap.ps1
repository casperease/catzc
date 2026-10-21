<#
---
catzc:
  immutable:
    with_body_sha: "03c4b41236df"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-AnalyzerDrsMap.Tests.ps1
    docs: "[Test-AnalyzerDrsMap.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Test-AnalyzerDrsMap.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PWSH-FORMAT-ANALYZERADRMAPPING
---
#>

function Test-AnalyzerDrsMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $map = Get-Config -Config analyzer-drs-map
    [string[]] $ruleIds = Get-CatsDrsRuleIds
    $validIds = [System.Collections.Generic.HashSet[string]]::new($ruleIds, [System.StringComparer]::Ordinal)

    $issues = [System.Collections.Generic.List[string]]::new()
    $mapped = @($map.analyzers.Keys)
    foreach ($analyzer in $mapped) {
        foreach ($id in @($map.analyzers[$analyzer])) {
            if (-not $validIds.Contains($id)) {
                $issues.Add("${analyzer}: cites $id, which is not a rule in $((Get-Config -Config drs).Root)")
            }
        }
    }

    $customRules = [System.Collections.Generic.List[string]]::new()
    $modulesRoot = Get-CatzcModulesRoot
    # The entry rules the settings hand the engine only run checks, so the map holds the checks, never an entry rule.
    $settings = Import-PowerShellDataFile (Join-Path $modulesRoot '.internal/assets/PSScriptAnalyzerSettings.psd1')
    $entryRules = @($settings.CustomRulePath | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    $ruleFiles = [System.IO.Directory]::EnumerateFiles((Join-Path $modulesRoot '.scriptanalyzer'), '*.psm1') |
        Where-Object { [System.IO.Path]::GetFileName($_) -notin $entryRules } |
        Sort-Object
    foreach ($file in $ruleFiles) {
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file), '(?m)^\s*function\s+(Measure-\w+)')) {
            $rule = $match.Groups[1].Value
            $customRules.Add($rule)
            if ($rule -notin $mapped) {
                $issues.Add("${rule}: a custom analyzer rule missing from analyzer-drs-map.yml — map it to the ADR rule(s) it enforces")
            }
        }
    }

    Write-QualityGateReport -Subject 'analyzer-adr-map' -Title 'Test-AnalyzerDrsMap' -Issues $issues `
        -Facts ([ordered]@{ Analyzers = $mapped.Count; CustomRules = $customRules.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
