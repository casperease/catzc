function Get-DrsRuleIds {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath "$((Get-Config -Config drs).Root)/index.md")
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:drsRuleIdsCache')) {
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:drsRuleIdsCache = @{}
    }
    if ($script:drsRuleIdsCache.ContainsKey($IndexPath)) {
        return , $script:drsRuleIdsCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    # Index rows are relative to the index's own folder, so a fixture index beside fixture records resolves the same way.
    $drsRoot = Split-Path $IndexPath -Parent
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in (Get-DrsIndex -IndexPath $IndexPath)) {
        $recordFile = Join-Path $drsRoot $entry.Path
        foreach ($rule in (Get-DrsRules -DrsPath $recordFile)) {
            [void]$ids.Add($rule.Id)
        }
    }

    $ret = @($ids | Sort-Object)
    $script:drsRuleIdsCache[$IndexPath] = $ret
    , $ret
}
