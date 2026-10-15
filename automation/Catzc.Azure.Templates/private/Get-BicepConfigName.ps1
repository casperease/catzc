<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
    adrs:
      - ADR-AZ-DATAMOD#2
---
#>

<#
.SYNOPSIS
    Builds a config / resource-group identity name from an (environment, slot) pair.
.DESCRIPTION
    The name is 1:1 with the resource group and also names the config file and the build parameters artifact.
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
