<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-AdoNaming.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the active Azure resource-name component order for this repo ('standard' or 'classic').
.DESCRIPTION
    Changing it re-spells every resource name, so all typed names in template configs need re-editing.
    [comment:1](/docs/references/automation/catzc-base-variants/Get-AdoNaming.ps1.md#comment1)
.EXAMPLE
    Get-AdoNaming   # -> 'standard'
#>
function Get-AdoNaming {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name ado_naming -Default 'standard')"
}
