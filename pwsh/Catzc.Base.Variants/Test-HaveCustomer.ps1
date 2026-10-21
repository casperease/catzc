<#
---
catzc:
  immutable:
    with_body_sha: f11dae437a80
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-HaveCustomer.Tests.ps1
    docs: "[Test-HaveCustomer.ps1.md](docs/references/pwsh/catzc-base-variants/Test-HaveCustomer.ps1.md)"
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
