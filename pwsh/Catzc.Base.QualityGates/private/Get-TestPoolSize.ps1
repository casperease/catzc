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

    # Every parallel shard starts with the run; the greedy files get workers of their own, up to the group size, so the longest start with it too.
    [Math]::Max($ParallelShardCount + [Math]::Min($GreedyGroupSize, $GreedyFileCount), 1)
}
