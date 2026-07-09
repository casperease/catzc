<#
.SYNOPSIS
    Builds a config / resource-group identity name from an (environment, slot) pair.
.DESCRIPTION
    The config-name is `<environment>` for the base / index-0 slot, or `<environment>-<slot>` for a
    special slot. It names the config file (`<config>.yml`), the build artifact
    (`parameters.<config>.json`), and is 1:1 with the resource group. The inverse (parse) is
    Resolve-BicepConfigName. See docs/adr/azure/azure-data-model.md#rule-adr-datamod2.
.PARAMETER Environment
    Environment name (a key in azure.yml's environments map).
.PARAMETER Slot
    Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base slot.
.EXAMPLE
    Get-BicepConfigName dev          # -> 'dev'
.EXAMPLE
    Get-BicepConfigName dev -Slot 001   # -> 'dev-001'
#>
function Get-BicepConfigName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot
    )

    if ([string]::IsNullOrEmpty($Slot)) {
        $Environment
    }
    else {
        "$Environment-$Slot"
    }
}
