<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-templates/Get-AzureNameOrderSet.ps1.md"
  warning: "Generated Header"
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
