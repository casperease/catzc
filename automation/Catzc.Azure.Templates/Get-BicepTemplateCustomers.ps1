<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplateCustomers.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns a template's configured customer names as a flat string array.
.DESCRIPTION
    Completers must degrade quietly, so an omitted, unknown or core-only template returns an empty array.
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
