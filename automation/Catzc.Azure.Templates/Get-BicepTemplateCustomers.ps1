<#
.SYNOPSIS
    Returns a template's configured customer names as a flat string array.
.DESCRIPTION
    The single source of the customer list used by the -Customer ArgumentCompleter (the deploy paths
    are session-determined and take no customer). A template's customers ARE its configuration
    subfolders: each `configuration/<customer>/` folder contributes its customer key. This returns the
    distinct customer names from discovery, so `-Customer <TAB>` offers exactly the customers the bound
    -Template actually ships configs for.

    Returns an empty array when -Template is omitted/unknown or the template is core-only — completers
    must degrade quietly, never throw.

    Centralising it (like Get-BicepTemplateNames / Get-BicepTemplateSlots) keeps the completer
    scriptblocks one-liners and avoids the [ordered]-dict / comma-wrapped Get-BicepTemplates traps.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.EXAMPLE
    Get-BicepTemplateCustomers sample-customer   # -> acme
#>
function Get-BicepTemplateCustomers {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Template
    )

    if ([string]::IsNullOrEmpty($Template)) {
        return @()
    }

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    $templateDescriptor = $templates | Where-Object { $_.name -eq $Template } | Select-Object -First 1
    if (-not $templateDescriptor) {
        return @()
    }

    @($templateDescriptor.customers)
}
