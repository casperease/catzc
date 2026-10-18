<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Test-HaveCustomer.ps1
    name: test-have-customer
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Test-HaveCustomer.Tests.ps1
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
