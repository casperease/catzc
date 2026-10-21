<#
---
catzc:
  immutable:
    with_body_sha: fe0822655eae
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Assert-HaveCustomer.Tests.ps1
    docs: "[Assert-HaveCustomer.ps1.md](../../docs/references/pwsh/catzc-base-variants/Assert-HaveCustomer.ps1.md)"
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
