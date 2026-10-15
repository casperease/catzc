<#
.SYNOPSIS
    The build-artifact parameters filename for a (customer?, env, slot) config.
.DESCRIPTION
    The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes it) and...
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md#comment1)
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
