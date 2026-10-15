<#
.SYNOPSIS
    Assigns a run's parallel test files to worker shards by their measured duration, longest first, so the shards
    finish together.
.DESCRIPTION
    A file with no recorded duration counts as the median, so a first run is a fair even split; ties keep their order.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Select-TestShardAssignment.ps1.md#comment1)
.PARAMETER File
    The parallel test files, absolute paths.
.PARAMETER WorkerCount
    How many shards to fill.
.PARAMETER DurationMs
    The known durations, repository-relative '/'-separated file path -> milliseconds.
.PARAMETER RepositoryRoot
    The root the history's paths are relative to.
.OUTPUTS
    [string[][]] One array of files per shard, in shard order; a shard with no file is an empty array.
#>
function Select-TestShardAssignment {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [ValidateRange(1, 64)]
        [int] $WorkerCount,

        [System.Collections.IDictionary] $DurationMs = @{},

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $known = @($DurationMs.Values | ForEach-Object { [double] $_ } | Sort-Object)
    $fallback = if ($known.Count -gt 0) {
        $known[[int][Math]::Floor($known.Count / 2)]
    }
    else {
        1000
    }

    $weighted = for ($index = 0; $index -lt $File.Count; $index++) {
        $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $File[$index]) -replace '\\', '/'
        [pscustomobject]@{
            File   = $File[$index]
            Weight = if ($DurationMs.Contains($relative)) {
                [double] $DurationMs[$relative]
            }
            else {
                $fallback
            }
            Order  = $index
        }
    }

    $shards = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()
    for ($index = 0; $index -lt $WorkerCount; $index++) {
        $shards.Add([System.Collections.Generic.List[string]]::new())
    }
    $load = [double[]]::new($WorkerCount)
    foreach ($entry in @($weighted | Sort-Object -Property @{ Expression = 'Weight'; Descending = $true }, @{ Expression = 'Order'; Descending = $false })) {
        $target = 0
        for ($index = 1; $index -lt $WorkerCount; $index++) {
            if ($load[$index] -lt $load[$target]) {
                $target = $index
            }
        }
        $shards[$target].Add($entry.File)
        $load[$target] += $entry.Weight
    }

    foreach ($shard in $shards) {
        , [string[]] $shard.ToArray()
    }
}
