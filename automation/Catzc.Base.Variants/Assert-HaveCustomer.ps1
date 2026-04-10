<#
.SYNOPSIS
    Asserts one named customer is enabled for the repo, else throws (singular cover over Assert-HaveCustomers).
.DESCRIPTION
    The single-customer form of Assert-HaveCustomers. A thin cover: Assert-HaveCustomers -Name $Name. Throws
    when the named customer is not enabled by the `have_customers` variant.
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
