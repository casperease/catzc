<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Test-HaveCustomers.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether the repo has customer deployments enabled — for all customers, or for specific names.
.DESCRIPTION
    Enabled means by repo policy only; whether a name is a defined customer is left to customer.yml.
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
    # Both name sets are lowercase-validated, so case-insensitive -notin is equivalent to a case-sensitive match.
    # [comment:2](/docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md#comment2)
    foreach ($customer in $Name) {
        if ("$customer" -notin $enabledList) {
            return $false
        }
    }
    $true
}
