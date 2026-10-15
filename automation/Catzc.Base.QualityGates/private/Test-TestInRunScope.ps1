<#
.SYNOPSIS
    Whether a discovered test is inside a test run's tier and category scope.
.DESCRIPTION
    The one scope check behind the work-list filter and the opt-out exclusion, so both agree on what a run executes.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md#comment1)
.PARAMETER Test
    A test from the run's discovery-only Pester result (Get-TestDiscovery).
.PARAMETER ExcludeTag
    The run's tier/category exclude tags.
.OUTPUTS
    [bool]
#>
function Test-TestInRunScope {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        $Test,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @()
    )

    # Never wrap this result in @(): that would nest the single array object it returns, and every count would read 1.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md#comment2)
    $level = Get-TestBlockTag -Test $Test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
    $category = Get-TestBlockTag -Test $Test -Valid 'logic', 'integrity'
    @(@($level) + @($category) | Where-Object { $_ -in $ExcludeTag }).Count -eq 0
}
