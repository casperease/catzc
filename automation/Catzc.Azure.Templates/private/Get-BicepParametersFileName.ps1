<#
.SYNOPSIS
    The build-artifact parameters filename for a (customer?, env, slot) config.
.DESCRIPTION
    The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes
    it) and Get-BicepDeploymentContext (which reads it) so the two can never drift — the same principle
    as the derived RG name (Get-BicepResourceGroupName).

    `parameters.<config>.json` for a configuration-root (shared-platform) slot, or
    `parameters.<customer>.<config>.json` for a customer slot — where `<config>` is `<env>[-<slot>]`
    (Get-BicepConfigName). The artifact names mirror the configuration tree exactly: all of a template's
    slots render into one build folder, and keying on the customer keeps them structurally
    collision-free ((customer?, env, slot) is unique) with no guard to remember. See
    docs/adr/azure/azure-data-model.md.
.PARAMETER Environment
    Environment name.
.PARAMETER Slot
    Optional special-slot discriminator; omitted ⇒ the base slot.
.PARAMETER Customer
    The customer (configuration subfolder) the slot belongs to; omitted/'' ⇒ a configuration-root slot.
.EXAMPLE
    Get-BicepParametersFileName -Environment dev                     # -> parameters.dev.json
.EXAMPLE
    Get-BicepParametersFileName -Environment dev -Slot 001 -Customer apex   # -> parameters.apex.dev-001.json
#>
function Get-BicepParametersFileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot,

        [Parameter(Position = 2)]
        [AllowEmptyString()]
        [string] $Customer
    )

    $config = Get-BicepConfigName $Environment $Slot
    if ([string]::IsNullOrEmpty($Customer)) {
        "parameters.$config.json"
    }
    else {
        "parameters.$Customer.$config.json"
    }
}
