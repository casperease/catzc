<#
.SYNOPSIS
    Asserts one named customer is enabled for the repo, else throws (singular cover over Assert-HaveCustomers).
.DESCRIPTION
    The single-customer form of Assert-HaveCustomers.
    [comment:1](/docs/references/automation/catzc-base-variants/Assert-HaveCustomer.ps1.md#comment1)
.PARAMETER Name
    The customer name to require.
.EXAMPLE
    Assert-HaveCustomer acme
#>
function Assert-HaveCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Assert-HaveCustomers -Name $Name
}
