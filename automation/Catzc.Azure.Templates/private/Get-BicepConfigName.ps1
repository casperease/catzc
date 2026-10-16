<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
    folder: private
    name: get-bicep-config-name
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AZ-DATAMOD#2
  config:
    synopsis: Builds a config / resource-group identity name from an (environment, slot) pair.
    description: |-
      The config-name is `<environment>` for the base / index-0 slot, or `<environment>-<slot>` for a
      special slot. It names the config file (`<config>.yml`), the build artifact
      (`parameters.<config>.json`), and is 1:1 with the resource group. The inverse (parse) is
      Resolve-BicepConfigName. See [ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2).
    parameters:
      Environment: Environment name (a key in azure.yml's environments map).
      Slot: Optional special-slot discriminator (1-3 lowercase alphanumeric). Omitted ⇒ the base slot.
    examples:
      - 'Get-BicepConfigName dev          # -> ''dev'''
      - 'Get-BicepConfigName dev -Slot 001   # -> ''dev-001'''
---
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
