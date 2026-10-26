function Get-CatsDrsRuleIds {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath "$((Get-Config -Config drs).Root)/index.md")
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrRuleIdsCache')) {
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:catsAdrRuleIdsCache = @{}
    }
    if ($script:catsAdrRuleIdsCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrRuleIdsCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    # Index rows are relative to the index's own folder, so a fixture index beside fixture records resolves the same way.
    $adrRoot = Split-Path $IndexPath -Parent
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in (Get-CatsDrsIndex -IndexPath $IndexPath)) {
        $adrFile = Join-Path $adrRoot $entry.Path
        foreach ($rule in (Get-CatsDrsRules -DrsPath $adrFile)) {
            [void]$ids.Add($rule.Id)
        }
    }

    $ret = @($ids | Sort-Object)
    $script:catsAdrRuleIdsCache[$IndexPath] = $ret
    , $ret
}
