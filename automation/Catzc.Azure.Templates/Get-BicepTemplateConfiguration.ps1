<#
.SYNOPSIS
    Loads a template's per-slot config and returns the ordered dictionary.
.DESCRIPTION
    No merge with global config happens here; the PrePost prepare hook is the merge seam.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md#comment1)
.PARAMETER Template
    Template name (folder under infrastructure/templates/).
.PARAMETER Environment
    Environment shortname. Must be configured for the template.
.PARAMETER Slot
    Omitted selects the env's base slot file; the selected config must exist or the call throws.
    [comment:2](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md#comment2)
.PARAMETER Customer
    Omitted selects the shared-platform config at the configuration root, never a customer's.
    [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md#comment3)
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

    # The coordinate is the file address, so no resolution machinery sits between a slot and its file.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md#comment4)
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
