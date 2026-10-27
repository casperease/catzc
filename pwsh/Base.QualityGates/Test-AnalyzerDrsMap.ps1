function Test-AnalyzerDrsMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $map = Get-Config -Config analyzer-drs-map
    # A typed assignment keeps the comma-wrapped result intact, where @() would nest it.
    [string[]] $ruleIds = Get-DrsRuleIds
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
    $settings = Import-PowerShellDataFile ([Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::SettingsPath($modulesRoot))
    $entryRules = @($settings.CustomRulePath | ForEach-Object { [System.IO.Path]::GetFileName($_) })
    $ruleFiles = [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::RuleFiles($modulesRoot) |
        Where-Object { [System.IO.Path]::GetFileName($_) -notin $entryRules }
    foreach ($file in $ruleFiles) {
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($file), '(?m)^\s*function\s+(Measure-\w+)')) {
            $rule = $match.Groups[1].Value
            $customRules.Add($rule)
            if ($rule -notin $mapped) {
                $issues.Add("${rule}: a custom analyzer rule missing from analyzer-drs-map.yml — map it to the ADR rule(s) it enforces")
            }
        }
    }

    Write-QualityGateReport -Subject 'analyzer-drs-map' -Title 'Test-AnalyzerDrsMap' -Issues $issues `
        -Facts ([ordered]@{ Analyzers = $mapped.Count; CustomRules = $customRules.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
