<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Assert-HaveCustomer.ps1
    kind: assert-function
    module: Catzc.Base.Variants
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts one named customer is enabled for the repo, else throws (singular cover over Assert-HaveCustomers).
.DESCRIPTION
    Throws unless the have_customers variant is 'all' or lists the name; a thin cover with no logic of its own.
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
