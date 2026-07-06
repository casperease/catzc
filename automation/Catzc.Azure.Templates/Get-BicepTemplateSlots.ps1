<#
.SYNOPSIS
    Returns a template's configured (non-base) slot discriminators as a flat string array.
.DESCRIPTION
    The single source of the slot list used by the -Slot ArgumentCompleter on every deploy/name
    path. A template's slots come from its config files: `<env>.yml` is the base slot (empty
    discriminator, NOT offered for completion) and `<env>-<slot>.yml` is the slot `<slot>`. This
    returns the distinct non-empty discriminators, optionally filtered to one environment, so
    `-Slot <TAB>` offers exactly the real special slots for the bound -Template (and -Environment).

    Returns an empty array when -Template is omitted/unknown or the template has only base slots —
    completers must degrade quietly, never throw.

    Centralising it (like Get-BicepTemplateNames does for -Template) keeps the completer scriptblocks
    one-liners and avoids the [ordered]-dict / comma-wrapped Get-BicepTemplates enumeration traps.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Optional filter — return only slots configured for this environment name.
.PARAMETER Customer
    Customer filter — return slots for this customer's configuration subfolder (omitted/empty = the
    configuration-root, shared-platform slots).
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

    # slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the
    # `Where-Object prop -EQ` shortcut does not bind ordered-dict keys). Filter by customer — the
    # configuration axis; empty/unbound = the configuration-root (shared-platform) slots.
    $wantCustomer = [string]$Customer
    @($templateDescriptor.slots |
            Where-Object { -not [string]::IsNullOrEmpty($_.slot) } |
            Where-Object { $_.customer -eq $wantCustomer } |
            Where-Object { [string]::IsNullOrEmpty($Environment) -or $_.environment -eq $Environment } |
            ForEach-Object { $_.slot } |
            Select-Object -Unique)
}
