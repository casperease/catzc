<#
.SYNOPSIS
    Returns a template's configured (non-base) slot discriminators as a flat string array.
.DESCRIPTION
    The single source of the slot list used by the -Slot ArgumentCompleter on every deploy/name path.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Optional filter — return only slots configured for this environment name.
.PARAMETER Customer
    Customer filter — only the slots of this customer's configuration subfolder (omitted/empty = the...
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

    # slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the `Where-Object prop -EQ`...
    # [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md#comment3)
    $wantCustomer = [string]$Customer
    @($templateDescriptor.slots |
            Where-Object { -not [string]::IsNullOrEmpty($_.slot) } |
            Where-Object { $_.customer -eq $wantCustomer } |
            Where-Object { [string]::IsNullOrEmpty($Environment) -or $_.environment -eq $Environment } |
            ForEach-Object { $_.slot } |
            Select-Object -Unique)
}
