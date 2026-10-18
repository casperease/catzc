function Get-ScriptAnalyzerDiagnostics {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $SettingsPath,

        [switch] $NoCache
    )

    # Drop any null/empty entries; an empty list means nothing to analyze (no shards spawned).
    $requested = @($Path | Where-Object { $_ })
    if ($requested.Count -eq 0) {
        return @()
    }

    $fullRoot = [System.IO.Path]::GetFullPath((Get-RepositoryRoot))
    $spellingRule = 'Measure-CatzcSpelling'
    $passes = @(
        [pscustomobject]@{ Label = 'rules'; Cache = 'script-analyzer.json'; IncludeRule = @(); ExcludeRule = @($spellingRule) }
        [pscustomobject]@{ Label = 'spelling'; Cache = 'script-analyzer-spelling.json'; IncludeRule = @($spellingRule); ExcludeRule = @() }
    )

    $batch = [System.Collections.Generic.List[object]]::new()
    foreach ($pass in $passes) {
        $inputs = Get-ScriptAnalyzerInputs -RepositoryRoot $fullRoot -SettingsPath $SettingsPath -Pass $pass.Label
        $stamp = Get-ContentStamp -Label "script-analyzer-$($pass.Label)" -File $inputs -RepositoryRoot $fullRoot
        $cachePath = Join-Path (Get-OutputRoot) "cache/$($pass.Cache)"
        $cache = if ($NoCache) {
            @{}
        }
        else {
            Get-ResultCache -Path $cachePath
        }
        $split = Split-CachedFile -File $requested -Cache $cache -Stamp $stamp -RepositoryRoot $fullRoot
        Write-Message "$($pass.Label) pass: $($split.CachedCount) of $($requested.Count) file(s) unchanged since the analyzer last found them clean."
        if (@($split.Pending).Count -gt 0) {
            $batch.Add([pscustomobject]@{
                    Label        = $pass.Label
                    Files        = [string[]] @($split.Pending)
                    SettingsPath = $SettingsPath
                    IncludeRule  = $pass.IncludeRule
                    ExcludeRule  = $pass.ExcludeRule
                    Cache        = $cache
                    CachePath    = $cachePath
                    Key          = $split.Key
                })
        }
    }
    if ($batch.Count -eq 0) {
        return @()
    }

    $diagnostics = Invoke-ScriptAnalyzerShards -Batch $batch.ToArray() -RepositoryRoot $fullRoot
    $allDiagnostics = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $batch) {
        $found = @($diagnostics[$entry.Label])
        # Record every analyzed file without a diagnostic as clean; a file with one is checked again next time.
        $flagged = @($found | Where-Object { $_.ScriptPath } | ForEach-Object { $_.ScriptPath })
        Update-ResultCache -Cache $entry.Cache -Key $entry.Key -Checked $entry.Files -Flagged $flagged
        Save-ResultCache -Path $entry.CachePath -Cache $entry.Cache
        foreach ($diagnostic in $found) {
            $allDiagnostics.Add($diagnostic)
        }
    }
    $allDiagnostics.ToArray()
}
