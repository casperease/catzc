function Save-AbandonedRunDurationHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $RunDirectory,

        [Parameter(Mandatory)]
        [string] $Path
    )

    # A run killed past its roof never saved its durations, so the shards it finished feed the history the next run deals by.
    $repositoryRoot = Get-RepositoryRoot
    $measured = @{}
    foreach ($directory in $RunDirectory) {
        if (-not [System.IO.Directory]::Exists($directory)) {
            continue
        }
        foreach ($sidecar in [System.IO.Directory]::EnumerateFiles($directory, 'files-shard-*.json')) {
            try {
                $entries = @([System.IO.File]::ReadAllText($sidecar) | ConvertFrom-Json)
            }
            catch {
                Write-Verbose "Skipped unreadable shard sidecar: $sidecar — $($_.Exception.Message)"
                continue
            }
            foreach ($entry in $entries) {
                # A bridged test reports the shared bridge script, whose key only the live run knows; a snapshot path is outside the root.
                $relative = [System.IO.Path]::GetRelativePath($repositoryRoot, "$($entry.File)") -replace '\\', '/'
                if (-not $relative.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase) -or
                    $relative.StartsWith('..') -or [System.IO.Path]::IsPathRooted($relative)) {
                    continue
                }
                $measured[$relative] = [double] $entry.DurationMs
            }
        }
    }
    if ($measured.Count -gt 0) {
        Save-TestDurationHistory -Path $Path -DurationMs $measured
        Write-Message "Recorded $($measured.Count) file duration(s) from $(@($RunDirectory).Count) abandoned run(s)"
    }
}
