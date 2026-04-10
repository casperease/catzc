<#
.SYNOPSIS
    Returns the active Azure resource-name component order for this repo ('standard' or 'classic').
.DESCRIPTION
    The `ado_naming` repo-wide variant (configs/variants.yml), fixed for the importer session. It is the
    order key Get-BicepResourceName passes to Get-AzureResourceName (a key of Get-AzureNameOrderSet).
    Defaults to 'standard' when the variant is unset.

    *** Changing this value re-spells EVERY resource name. Resource names are typed out in each template's
    configuration/<subscription>/<slot>.yml, so flipping the order means re-editing all of them —
    build-time validation flags each that no longer matches. Deliberately not a flip-the-switch option. ***
.EXAMPLE
    Get-AdoNaming   # -> 'standard'
#>
function Get-AdoNaming {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name ado_naming -Default 'standard')"
}
