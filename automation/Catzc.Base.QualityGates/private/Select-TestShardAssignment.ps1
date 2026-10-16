<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Select-TestShardAssignment.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
  config:
    synopsis: |-
      Assigns a run's parallel test files to worker shards by their measured duration, longest first, so the shards
      finish together.
    description: |-
      A phase lasts as long as its slowest shard, so the files are dealt longest first, each to the shard with the least
      work so far (longest-processing-time first). A file's work is its duration from the last run that ran it
      (Get-TestDurationHistory); a file without one counts as the median of the known durations, or 1 s when nothing is
      known yet, so a first run is a fair even split. Ties keep the files' given order, so the result is deterministic.
    parameters:
      File: The parallel test files, absolute paths.
      WorkerCount: How many shards to fill.
      DurationMs: The known durations, repository-relative '/'-separated file path -> milliseconds.
      RepositoryRoot: The root the history's paths are relative to.
    outputs: '[string[]] One array of files per shard, in shard order; a shard with no file is an empty array.'
---
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
