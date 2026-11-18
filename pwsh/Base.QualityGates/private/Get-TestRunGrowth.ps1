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
        [System.Collections.IDictionary] $Context,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The growth is concentrated when the top file holds at least this share of it; a file counts as grown from this many seconds.
    $concentratedShare = 0.5
    $grownFileSeconds = 2.0
    $root = $RepositoryRoot

    $addSeconds = {
        param([System.Collections.Generic.Dictionary[string, double]] $Seconds, [object[]] $Entries)
        foreach ($entry in $Entries) {
            $file = "$($entry.File)"
            $key = if ($entry.PSObject.Properties['Key'] -and $entry.Key) {
                "$($entry.Key)"
            }
            elseif ($file.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
            if (-not $key) {
                continue
            }
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

    # The baseline is the newest earlier run of the kind that ran to completion: passed or failed on its tests, every shard's rows on disk.
    $earlier = $null
    $before = $null
    foreach ($directory in $candidates) {
        $manifestPath = [System.IO.Path]::Combine($directory, 'run.json')
        if ([System.IO.Path]::GetFileName($directory) -eq $currentName -or -not [System.IO.File]::Exists($manifestPath)) {
            continue
        }
        try {
            $manifest = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json -AsHashtable
            if ($manifest -isnot [System.Collections.IDictionary] -or $manifest['status'] -notin 'passed', 'failed' -or
                $manifest['context'] -isnot [System.Collections.IDictionary] -or (& $kindOf $manifest['context']) -ne $kind) {
                continue
            }
            $shards = @($manifest['shards'] | Where-Object { $_ -is [System.Collections.IDictionary] })
            $seconds = [System.Collections.Generic.Dictionary[string, double]]::new([System.StringComparer]::OrdinalIgnoreCase)
            $complete = $shards.Count -gt 0
            foreach ($shard in $shards) {
                $sidecar = [System.IO.Path]::Combine($directory, "files-$($shard['label']).json")
                $rows = @(if ([System.IO.File]::Exists($sidecar)) {
                        [System.IO.File]::ReadAllText($sidecar) | ConvertFrom-Json
                    })
                if ($rows.Count -ne [int] $shard['files']) {
                    $complete = $false
                    break
                }
                & $addSeconds $seconds $rows
            }
        }
        catch {
            Write-Verbose "Skipped unreadable run: $directory — $($_.Exception.Message)"
            continue
        }
        if ($complete) {
            $earlier = [pscustomobject]@{ Directory = $directory; Seconds = [double] $manifest['durationSeconds'] }
            $before = $seconds
            break
        }
    }
    if ($null -eq $earlier) {
        return
    }
    $now = [System.Collections.Generic.Dictionary[string, double]]::new([System.StringComparer]::OrdinalIgnoreCase)
    & $addSeconds $now $File

    # The growth is summed over the files both runs ran, so a file added or removed since never reads as growth.
    $growth = 0.0
    $grownFiles = 0
    $topKey = $null
    $topGrowth = 0.0
    foreach ($key in $now.Keys) {
        if (-not $before.ContainsKey($key)) {
            continue
        }
        $delta = $now[$key] - $before[$key]
        $growth += $delta
        if ($delta -ge $grownFileSeconds) {
            $grownFiles++
        }
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
        GrownFiles       = $grownFiles
        TopFile          = if ($topKey.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
            [System.IO.Path]::GetFileName($topKey)
        }
        else {
            $topKey
        }
        TopGrowthSeconds = $topGrowth
        Spread           = $topGrowth -lt ($growth * $concentratedShare)
    }
}
