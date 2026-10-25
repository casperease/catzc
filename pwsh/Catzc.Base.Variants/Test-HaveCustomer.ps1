<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-HaveCustomer.ps1.md"
  header: "generated"
---
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
