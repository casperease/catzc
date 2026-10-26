<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestPoolSize.ps1.md"
  header: "generated"
---
#>

function Get-TestPoolSize {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, 64)]
        [int] $ParallelShardCount,

        [Parameter(Mandatory)]
        [ValidateRange(0, 100000)]
        [int] $GreedyFileCount,

        [Parameter(Mandatory)]
        [ValidateRange(1, 64)]
        [int] $GreedyGroupSize
    )

    # Every shard starts with the run, and the greedy files get workers of their own up to the group size.
    [Math]::Max($ParallelShardCount + [Math]::Min($GreedyGroupSize, $GreedyFileCount), 1)
}
