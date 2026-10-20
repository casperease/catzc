<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestPoolSize.ps1
    folder: private
    name: get-test-pool-size
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestPoolSize.Tests.ps1
    docs: "[Get-TestPoolSize.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestPoolSize.ps1.md)"
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

    # Every parallel shard starts with the run; the greedy files get workers of their own, up to the group size, so the longest start with it too.
    [Math]::Max($ParallelShardCount + [Math]::Min($GreedyGroupSize, $GreedyFileCount), 1)
}
