<#
---
catzc:
  immutable:
    with_body_sha: "45a10fd6b57d"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureNameOrderSet.Tests.ps1
    docs: "[Get-AzureNameOrderSet.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Get-AzureNameOrderSet.ps1.md)"
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
