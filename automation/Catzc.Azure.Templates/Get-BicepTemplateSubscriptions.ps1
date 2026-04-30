<#
.SYNOPSIS
    Returns a template's configured subscription names as a flat string array.
.DESCRIPTION
    The single source of the subscription list used by the -Subscription ArgumentCompleter on the deploy
    paths, and the candidate set for resolving which subscription a deploy targets. A template's
    subscriptions are its config subfolders (configuration/<subscription>/). This returns the distinct
    subscription names, optionally filtered to one environment (and slot), so `-Subscription <TAB>`
    offers exactly the subscriptions that have a config for the bound -Template (and -Environment / -Slot).

    Returns an empty array when -Template is omitted/unknown — completers must degrade quietly, never throw.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Optional filter — return only subscriptions with a config for this environment name.
.PARAMETER Slot
    Optional filter — return only subscriptions with a config for this slot discriminator.
.EXAMPLE
    Get-BicepTemplateSubscriptions discovery             # -> shared_nonprod, shared_prod, apex_nonprod, ...
.EXAMPLE
    Get-BicepTemplateSubscriptions discovery dev         # -> the subscriptions that have a dev config
#>
function Get-BicepTemplateSubscriptions {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Template,

        [Parameter(Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [string] $Slot
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

    # slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form.
    $wantSlot = [string]$Slot
    @($templateDescriptor.slots |
            Where-Object { [string]::IsNullOrEmpty($Environment) -or $_.environment -eq $Environment } |
            Where-Object { [string]::IsNullOrEmpty($wantSlot) -or $_.slot -eq $wantSlot } |
            ForEach-Object { $_.subscription } |
            Select-Object -Unique)
}
