<#
.SYNOPSIS
    Whether a discovered test is inside a test run's tier and category scope.
.DESCRIPTION
    A test is in scope when neither its tier nor its category — each resolved along its block chain (Get-TestBlockTag,
    nearest contributing block wins) — is one of the run's exclude tags (Get-TestExcludeTag). The one scope check
    behind the work-list's scope filter (Select-InScopeTestFiles) and the opt-out exclusion (Get-TestOptOutExclusion),
    so both agree on which tests a run would execute.
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

    # Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
    # wrapped in @() — that would nest it and every count would read 1.
    $level = Get-TestBlockTag -Test $Test -Valid 'L0', 'L1', 'L2', 'L3'
    $category = Get-TestBlockTag -Test $Test -Valid 'logic', 'integrity'
    @(@($level) + @($category) | Where-Object { $_ -in $ExcludeTag }).Count -eq 0
}
