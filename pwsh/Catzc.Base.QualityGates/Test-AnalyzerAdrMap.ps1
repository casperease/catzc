<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
    name: test-analyzer-adr-map
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
    docs: "[Test-AnalyzerAdrMap.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PWSH-FORMAT-ANALYZERADRMAPPING
---
#>

function Test-AnalyzerAdrMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $map = Get-Config -Config analyzer-adr-map
    [string[]] $ruleIds = Get-CatsAdrRuleIds
    $validIds = [System.Collections.Generic.HashSet[string]]::new($ruleIds, [System.StringComparer]::Ordinal)

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
                $issues.Add("${rule}: a custom analyzer rule missing from analyzer-adr-map.yml — map it to the ADR rule(s) it enforces")
            }
        }
    }

    Write-QualityGateReport -Subject 'analyzer-adr-map' -Title 'Test-AnalyzerAdrMap' -Issues $issues `
        -Facts ([ordered]@{ Analyzers = $mapped.Count; CustomRules = $customRules.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
