<#
.SYNOPSIS
    Returns a template's configured (non-base) slot discriminators as a flat string array.
.DESCRIPTION
    The base slot has an empty discriminator and is never offered; completion lists only the special slots.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Optional filter — return only slots configured for this environment name.
.PARAMETER Customer
    Omitted or empty means the configuration-root, shared-platform slots, not every customer's.
    [comment:2](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md#comment2)
.EXAMPLE
    Get-BicepTemplateSlots sample-indexed            # -> 001, 002
.EXAMPLE
    Get-BicepTemplateSlots sample-indexed dev        # -> 001, 002 (only env 'dev')
#>
function Get-BicepTemplateSlots {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Template,

        [Parameter(Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [string] $Customer
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

    # The Where-Object prop -EQ shortcut does not bind ordered-dict keys, so the script-block form is required.
    # [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md#comment3)
    $wantCustomer = [string]$Customer
    @($templateDescriptor.slots |
            Where-Object { -not [string]::IsNullOrEmpty($_.slot) } |
            Where-Object { $_.customer -eq $wantCustomer } |
            Where-Object { [string]::IsNullOrEmpty($Environment) -or $_.environment -eq $Environment } |
            ForEach-Object { $_.slot } |
            Select-Object -Unique)
}
