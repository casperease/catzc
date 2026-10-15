<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureNameOrderSet.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the named component orders Get-AzureResourceName can assemble names in.
.DESCRIPTION
    Empty optional components and empty segments are dropped, so a name never gets a doubled separator.
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
