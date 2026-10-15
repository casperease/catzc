<#
.SYNOPSIS
    Tests whether the repo has customer deployments enabled — for all customers, or for specific names.
.DESCRIPTION
    A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers).
    [comment:1](/docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md#comment1)
.PARAMETER Name
    Zero or more customer names to test for enablement. Omit to test the repo-wide capability.
.EXAMPLE
    if (Test-HaveCustomers) { ... }              # any customers enabled?
.EXAMPLE
    Test-HaveCustomers -Name acme, globex        # are both enabled?
#>
function Test-HaveCustomers {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name
    )

    $enabled = Get-EnabledCustomers
    $isAll = ($enabled -is [string]) -and ($enabled -ceq 'all')
    # assigned in the branch, not from an if-expression, which would unroll a 0/1-item array to $null/a scalar
    $enabledList = @()
    if (-not $isAll) {
        $enabledList = @($enabled)
    }
    $any = $isAll -or ($enabledList.Count -gt 0)

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return [bool] $any
    }
    if (-not $any) {
        return $false
    }
    if ($isAll) {
        return $true
    }
    # Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership is...
    # [comment:2](/docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md#comment2)
    foreach ($customer in $Name) {
        if ("$customer" -notin $enabledList) {
            return $false
        }
    }
    $true
}
