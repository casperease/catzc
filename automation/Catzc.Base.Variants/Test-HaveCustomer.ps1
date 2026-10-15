<#
.SYNOPSIS
    Tests whether one named customer is enabled for the repo (singular cover over Test-HaveCustomers).
.DESCRIPTION
    The single-customer form of Test-HaveCustomers, for the common "is this one customer enabled" check.
    [comment:1](/docs/references/automation/catzc-base-variants/Test-HaveCustomer.ps1.md#comment1)
.PARAMETER Name
    The customer name to test.
.EXAMPLE
    if (Test-HaveCustomer acme) { ... }
#>
function Test-HaveCustomer {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Test-HaveCustomers -Name $Name
}
