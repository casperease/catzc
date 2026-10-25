<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Select-TestShardAssignment.ps1.md"
  warning: "Generated Header"
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
