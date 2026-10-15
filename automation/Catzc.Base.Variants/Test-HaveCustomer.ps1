<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Test-HaveCustomer.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether one named customer is enabled for the repo (singular cover over Test-HaveCustomers).
.DESCRIPTION
    True when the variant is 'all' or lists the name; a thin cover that adds no logic.
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
