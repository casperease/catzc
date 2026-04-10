<#
.SYNOPSIS
    Tests whether the repo has customer deployments enabled — for all customers, or for specific names.
.DESCRIPTION
    A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers). With no -Name it
    answers "is the repo customer-enabled at all" (the variant is 'all' or a non-empty list). With -Name it
    answers "are all the named customers enabled" (the variant is 'all', or each name is in the list). A
    guard callable anywhere above the Config layer; use Assert-HaveCustomers to fail instead of branch.

    Enabled here means enabled by repo policy (the variant). Whether a name is a *defined* customer is a
    customer.yml (Azure-layer) concern.
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
    $enabledList = if ($isAll) {
        @()
    }
    else {
        @($enabled)
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
    # Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership
    # is equivalent here and needs no case-sensitive operator.
    foreach ($customer in $Name) {
        if ("$customer" -notin $enabledList) {
            return $false
        }
    }
    $true
}
