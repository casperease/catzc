<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-AzureNameOrderSet.ps1
    name: get-azure-name-order-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureNameOrderSet.Tests.ps1
    docs: "[Get-AzureNameOrderSet.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureNameOrderSet.ps1.md)"
---
#>

function Get-AzureNameOrderSet {
    param()

    [ordered]@{
        standard = @(
            @('env'),
            @('slot'),
            @('region'),
            @('org'),
            @('short_name'),
            @('customer'),
            @('role'),
            @('type')
        )
        classic  = @(
            @('type'),
            @('org'),
            @('short_name'),
            @('customer'),
            @('env'),
            @('region'),
            @('slot'),
            @('role')
        )
    }
}
