<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
    name: get-bicep-resource-name
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
    test: automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
    cites:
      - ADR-AZ-NAMING#8
---
#>

# cspell:ignore deweuzctsmplst
function Get-BicepResourceName {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string] $Template,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 2)]
        [ArgumentCompleter({ (Get-AzureResourceTypeSet).Keys })]
        [string] $Type,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateSlots -Template $fakeBoundParameters['Template'] -Environment $fakeBoundParameters['Environment'] -Customer $fakeBoundParameters['Customer']
            })]
        [string] $Slot,

        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-BicepTemplateCustomers -Template $fakeBoundParameters['Template']
            })]
        [string] $Customer,
        [string] $Role
    )

    $templateDescriptor = Get-BicepTemplate $Template
    $azure = Get-Config -Config azure
    $envEntry = $azure.environments[$Environment]

    $nameArgs = @{
        Env        = $Environment
        Shortcode  = $envEntry.shortcode
        RegionCode = $envEntry.region_code
        Org        = $azure.org
        ShortName  = $templateDescriptor.short_name
        Type       = $Type
        Order      = Get-AdoNaming
    }
    if (-not [string]::IsNullOrEmpty($Slot)) {
        $nameArgs['Slot'] = $Slot
    }
    if (-not [string]::IsNullOrEmpty($Customer)) {
        $resolvedCustomer = Get-AzureCustomer $Customer
        $nameArgs['Customer'] = $resolvedCustomer.key
        $nameArgs['CustomerShortcode'] = $resolvedCustomer.shortcode
    }
    if (-not [string]::IsNullOrEmpty($Role)) {
        $nameArgs['Role'] = $Role
    }

    Get-AzureResourceName @nameArgs
}
