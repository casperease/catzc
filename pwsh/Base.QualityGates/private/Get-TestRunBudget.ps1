function Get-TestRunBudget {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [object] $TimeLimits,

        [switch] $PostBuild
    )

    # The post-build run takes its own roof, and the key says which timeouts.yml entry it is.
    if ($PostBuild) {
        return [pscustomobject]@{ Seconds = $TimeLimits.PostBuildSeconds; Key = 'tests.post_build_seconds' }
    }
    [pscustomobject]@{ Seconds = $TimeLimits.RunSeconds; Key = 'tests.run_seconds' }
}
