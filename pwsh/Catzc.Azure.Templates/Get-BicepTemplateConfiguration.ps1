<#
---
catzc:
  immutable:
    with_body_sha: df804dee3230
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
    docs: "[Get-BicepTemplateConfiguration.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
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
    # A bicepparam slot is read by the Bicep compiler, not here: its descriptor carries its source path
    # ([ADR-AZ-DATAMOD-BICEPPARAMSLOT](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-bicepparamslot)).
    $bicepParamFile = Join-Path $folder "$configName.bicepparam"
    if ([System.IO.File]::Exists($bicepParamFile)) {
        return [ordered]@{ BicepParamFile = $bicepParamFile }
    }
    Assert-PathExist $environmentFile -PathType Leaf -ErrorText "Template '$Template' has no config '$configName.yml' or '$configName.bicepparam' $where ($environmentFile)"

    Get-Content $environmentFile -Raw | ConvertFrom-Yaml -Ordered
}
