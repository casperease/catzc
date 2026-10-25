<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Assert-HaveCustomer.ps1.md"
  warning: "Generated Header"
---
#>

function Assert-HaveCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Assert-HaveCustomers -Name $Name
}
