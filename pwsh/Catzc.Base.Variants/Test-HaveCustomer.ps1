<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-HaveCustomer.ps1
    name: test-have-customer
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
