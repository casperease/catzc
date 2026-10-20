<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Assert-HaveCustomer.ps1
    name: assert-have-customer
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Assert-HaveCustomer.Tests.ps1
    docs: "[Assert-HaveCustomer.ps1.md](docs/references/pwsh/catzc-base-variants/Assert-HaveCustomer.ps1.md)"
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
