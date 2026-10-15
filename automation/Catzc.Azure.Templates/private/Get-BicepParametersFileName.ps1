<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
    adrs:
      - ADR-AZ-DATAMOD
---
#>

<#
.SYNOPSIS
    The build-artifact parameters filename for a (customer?, env, slot) config.
.DESCRIPTION
    Build-Bicep writes and Get-BicepDeploymentContext reads this name, so the two can never drift.
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
