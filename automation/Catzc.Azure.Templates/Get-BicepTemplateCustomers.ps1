<#
.SYNOPSIS
    Returns a template's configured customer names as a flat string array.
.DESCRIPTION
    The single source of the customer list used by the -Customer ArgumentCompleter (the deploy paths are...
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateCustomers.ps1.md#comment1)
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
