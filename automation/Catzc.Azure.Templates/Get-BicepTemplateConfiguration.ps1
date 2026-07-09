<#
.SYNOPSIS
    Loads a template's per-slot config and returns the ordered dictionary.
.DESCRIPTION
    Returns the parsed yml as an ordered dictionary — typically just a `ParametersFile` (the
    template's ARM parameters, written statically). No merge with global config happens here;
    PrePost's Invoke-BicepPrepareParameterSet is the merge seam. The resource-group name is not
    read from this file — it is derived by Get-BicepResourceGroupName.

    The config address is literal (docs/adr/azure/azure-data-model.md): a configuration-root file
    `configuration/<env>[-<slot>].yml` (the shared-platform deployment), or a customer's file
    `configuration/<customer>/<env>[-<slot>].yml` when -Customer is given. No resolution machinery —
    the coordinate IS the file.
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Environment shortname. Must be configured for the template.
.PARAMETER Slot
    Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …). Selects
    `<env>-<slot>.yml`; omitted selects the env's base slot `<env>.yml`. The selected config must exist.
.PARAMETER Customer
    Optional customer key (a configuration subfolder). Selects the config under
    `configuration/<customer>/`; omitted selects the configuration-root (shared-platform) config.
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration sample dev
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration sample dev -Customer apex
.EXAMPLE
    $configuration = Get-BicepTemplateConfiguration indexed-template prod -Slot 001
    $configuration.ParametersFile.parameters.storageAccountName.value
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

    # One config file per (customer?, env, slot): the coordinate is the file address — root for the
    # shared platform, configuration/<customer>/ for a customer deployment.
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
