<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-AdoNaming.ps1
    kind: public-function
    module: Catzc.Base.Variants
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the active Azure resource-name component order for this repo ('standard' or 'classic').
.DESCRIPTION
    Changing it re-spells every resource name, so all typed names in template configs need re-editing.
.EXAMPLE
    Get-AdoNaming   # -> 'standard'
#>
function Get-AdoNaming {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name ado_naming -Default 'standard')"
}
