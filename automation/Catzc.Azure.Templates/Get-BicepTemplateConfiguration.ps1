<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
    kind: automation-function
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
      test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD
  config:
    synopsis: Loads a template's per-slot config and returns the ordered dictionary.
    description: |-
      Returns the parsed yml as an ordered dictionary — typically just a `ParametersFile` (the
      template's ARM parameters, written statically). No merge with global config happens here;
      PrePost's Invoke-BicepPrepareParameterSet is the merge seam. The resource-group name is not
      read from this file — it is derived by Get-BicepResourceGroupName.

      The config address is literal ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): a configuration-root file
      `configuration/<env>[-<slot>].yml` (the shared-platform deployment), or a customer's file
      `configuration/<customer>/<env>[-<slot>].yml` when -Customer is given. No resolution machinery —
      the coordinate IS the file.
    parameters:
      Template: Template name (folder under infrastructure/templates/).
      Environment: Environment shortname. Must be configured for the template.
      Slot: |-
        Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …). Selects
        `<env>-<slot>.yml`; omitted selects the env's base slot `<env>.yml`. The selected config must exist.
      Customer: |-
        Optional customer key (a configuration subfolder). Selects the config under
        `configuration/<customer>/`; omitted selects the configuration-root (shared-platform) config.
    examples:
      - '$configuration = Get-BicepTemplateConfiguration sample dev'
      - '$configuration = Get-BicepTemplateConfiguration sample dev -Customer apex'
      - |-
        $configuration = Get-BicepTemplateConfiguration indexed-template prod -Slot 001
        $configuration.ParametersFile.parameters.storageAccountName.value
---
#>

function Get-BicepTemplateConfiguration {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [string] $Environment,

        [Parameter(Position = 2)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string] $Customer
    )

    $templateDescriptor = Get-BicepTemplate $Template

    if (-not [string]::IsNullOrEmpty($Slot) -and $Slot -notmatch '(?-i)^[a-z0-9]{1,3}$') {
        throw "Invalid -Slot '$Slot' — must be 1-3 lowercase alphanumeric chars (e.g. 001)."
    }

    $configName = Get-BicepConfigName $Environment $Slot
    $folder = if ([string]::IsNullOrEmpty($Customer)) {
        $templateDescriptor.configuration_folder
    }
    else {
        Join-Path $templateDescriptor.configuration_folder $Customer
    }
    $environmentFile = Join-Path $folder "$configName.yml"
    $where = if ([string]::IsNullOrEmpty($Customer)) {
        'at the configuration root'
    }
    else {
        "under configuration/$Customer/"
    }
    Assert-PathExist $environmentFile -PathType Leaf -ErrorText "Template '$Template' has no config '$configName.yml' $where ($environmentFile)"

    Get-Content $environmentFile -Raw | ConvertFrom-Yaml -Ordered
}
