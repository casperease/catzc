# catzc:
#   path: automation/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1
#   module: Catzc.Azure.Templates
#   visibility: public

<#
.SYNOPSIS
    Returns the names of all discovered bicep templates as a flat string array.
.DESCRIPTION
    Centralised so completers avoid the member-enumeration trap of the comma-wrapped Get-BicepTemplates return.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateNames.ps1.md#comment1)
.EXAMPLE
    Get-BicepTemplateNames   # -> sample, sample-indexed, sample-subscription, sample-with-prepost
#>
function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
