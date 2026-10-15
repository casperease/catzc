<#
.SYNOPSIS
    Returns the active Azure resource-name component order for this repo ('standard' or 'classic').
.DESCRIPTION
    The `ado_naming` repo-wide variant (configs/variants.yml), fixed for the importer session.
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
