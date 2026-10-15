<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
    kind: automation-function
    module: Catzc.Azure.Templates
    visibility: private
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Get-BicepParametersFileName.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD
  config:
    synopsis: The build-artifact parameters filename for a (customer?, env, slot) config.
    description: |-
      The single source of the per-slot parameters artifact name, used by both Build-Bicep (which writes
      it) and Get-BicepDeploymentContext (which reads it) so the two can never drift — the same principle
      as the derived RG name (Get-BicepResourceGroupName).

      `parameters.<config>.json` for a configuration-root (shared-platform) slot, or
      `parameters.<customer>.<config>.json` for a customer slot — where `<config>` is `<env>[-<slot>]`
      (Get-BicepConfigName). The artifact names mirror the configuration tree exactly: all of a template's
      slots render into one build folder, and keying on the customer keeps them structurally
      collision-free ((customer?, env, slot) is unique) with no guard to remember. See
      [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
    parameters:
      Environment: Environment name.
      Slot: Optional special-slot discriminator; omitted ⇒ the base slot.
      Customer: The customer (configuration subfolder) the slot belongs to; omitted/'' ⇒ a configuration-root slot.
    examples:
      - 'Get-BicepParametersFileName -Environment dev                     # -> parameters.dev.json'
      - 'Get-BicepParametersFileName -Environment dev -Slot 001 -Customer apex   # -> parameters.apex.dev-001.json'
---
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
