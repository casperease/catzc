function Get-TestRunGrowth {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $File,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Context
    )

    # A file is keyed by its module folder, tests folder and name, so a snapshot run's paths match an in-place run's.
    $addSeconds = {
        param([System.Collections.Generic.Dictionary[string, double]] $Seconds, [object[]] $Entries)
        foreach ($entry in $Entries) {
            $segments = @("$($entry.File)" -split '[\\/]' | Where-Object { $_ })
            if ($segments.Count -eq 0) {
                continue
            }
            $key = ($segments | Select-Object -Last 3) -join '/'
            # A bridged test reports one shared script for several rows, so a key's seconds add up.
            $previous = 0.0
            [void] $Seconds.TryGetValue($key, [ref] $previous)
            $Seconds[$key] = $previous + ([double] $entry.DurationMs / 1000)
        }
    }
    # Runs of one kind share a budget key, a selection and a tier range; any other pair is never compared.
    $kindOf = {
        param([System.Collections.IDictionary] $RunContext)
        '{0}|{1}|{2}|{3}' -f $RunContext['run'], $RunContext['selection'], $RunContext['tiersRunning'], [bool] $RunContext['postBuild']
    }
    $kind = & $kindOf $Context
    $currentName = [System.IO.Path]::GetFileName($RunDirectory.TrimEnd('\', '/'))

    try {
        $candidates = [System.Collections.Generic.List[string]]::new()
        if ([System.IO.Directory]::Exists($OutputFolder)) {
            $candidates.AddRange([System.IO.Directory]::EnumerateDirectories($OutputFolder))
        }
    }
    catch {
        Write-Verbose "No earlier run to compare with: $($_.Exception.Message)"
        return
    }
    # A run folder is named by its start stamp, so the newest sorts last.
    $candidates.Sort([System.StringComparer]::Ordinal)
    $candidates.Reverse()

    $earlier = $null
    foreach ($directory in $candidates) {
        $manifestPath = [System.IO.Path]::Combine($directory, 'run.json')
        if ([System.IO.Path]::GetFileName($directory) -eq $currentName -or -not [System.IO.File]::Exists($manifestPath)) {
            continue
        }
        try {
            $manifest = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json -AsHashtable
        }
        catch {
            Write-Verbose "Skipped unreadable run manifest: $manifestPath — $($_.Exception.Message)"
            continue
        }
        if ($manifest -isnot [System.Collections.IDictionary] -or $manifest['status'] -ne 'passed' -or
            $manifest['context'] -isnot [System.Collections.IDictionary] -or (& $kindOf $manifest['context']) -ne $kind) {
            continue
        }
        $earlier = [pscustomobject]@{ Directory = $directory; Seconds = [double] $manifest['durationSeconds'] }
        break
    }
    if ($null -eq $earlier) {
        return
    }

    $before = [System.Collections.Generic.Dictionary[string, double]]::new([System.StringComparer]::OrdinalIgnoreCase)
    try {
        foreach ($sidecar in [System.IO.Directory]::EnumerateFiles($earlier.Directory, 'files-shard-*.json')) {
            & $addSeconds $before @([System.IO.File]::ReadAllText($sidecar) | ConvertFrom-Json)
        }
    }
    catch {
        Write-Verbose "No comparison with $($earlier.Directory): $($_.Exception.Message)"
        return
    }
    $now = [System.Collections.Generic.Dictionary[string, double]]::new([System.StringComparer]::OrdinalIgnoreCase)
    & $addSeconds $now $File

    # The growth is summed over the files both runs ran, so a file added or removed since never reads as growth.
    $growth = 0.0
    $topKey = $null
    $topGrowth = 0.0
    foreach ($key in $now.Keys) {
        if (-not $before.ContainsKey($key)) {
            continue
        }
        $delta = $now[$key] - $before[$key]
        $growth += $delta
        if ($null -eq $topKey -or $delta -gt $topGrowth) {
            $topKey = $key
            $topGrowth = $delta
        }
    }
    if ($null -eq $topKey -or $growth -le 0) {
        return
    }

    [pscustomobject]@{
        Run              = [System.IO.Path]::GetFileName($earlier.Directory)
        Seconds          = $earlier.Seconds
        GrowthSeconds    = $growth
        TopFile          = [System.IO.Path]::GetFileName($topKey)
        TopGrowthSeconds = $topGrowth
        Spread           = $topGrowth -lt ($growth / 3)
    }
}
