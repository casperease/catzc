# catzc:
#   path: automation/Catzc.Azure.Templates/Get-AzureNameOrderSet.ps1
#   module: Catzc.Azure.Templates
#   visibility: public

<#
.SYNOPSIS
    Returns the named component orders Get-AzureResourceName can assemble names in.
.DESCRIPTION
    Empty optional components and empty segments are dropped, so a name never gets a doubled separator.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureNameOrderSet.ps1.md#comment1)
.EXAMPLE
    (Get-AzureNameOrderSet).standard
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
