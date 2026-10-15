<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AZ-NAMING#8
---
#>

# cspell:ignore deweuzctsmplst
<#
.SYNOPSIS
    Generates an Azure resource name for a template's slot from the naming standard.
.DESCRIPTION
    Serves two uses: validating a configured name against the generated one, and generating one to inject.
.PARAMETER Template
    Template name.
.PARAMETER Environment
    Environment shortname.
.PARAMETER Type
    Resource-type abbreviation — a key of Get-AzureResourceTypeSet (`rg`, `st`, `kv`, ...).
.PARAMETER Slot
    Optional special-slot discriminator; omitted selects the env's base / index-0 slot.
.PARAMETER Customer
    The readable key renders in generous names and the 2-char shortcode in restricted ones, both resolved here.
.PARAMETER Role
    Optional 2-3 char sibling discriminator among same-type resources (per resource).
.EXAMPLE
    Get-BicepResourceName -Template sample -Environment dev -Type st   # -> deweuzctsmplst
.EXAMPLE
    Get-BicepResourceName -Template sample-indexed -Environment dev -Slot 001 -Type rg
    # -> dev-001-weu-zct-sidx-rg
#>
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
    # The subscription group is a resolution axis only, never a name component, so azure.yml is read directly.
    # [comment:3](/docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md#comment3)
    $envEntry = $azure.environments[$Environment]

    # Both env forms and the slot are passed so the namer chooses per type; env and slot stay separate segments.
    # [comment:4](/docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md#comment4)
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
        # Get-AzureCustomer throws on an unknown token, so a mistyped customer fails here, not in the name.
        # [comment:5](/docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md#comment5)
        $resolvedCustomer = Get-AzureCustomer $Customer
        $nameArgs['Customer'] = $resolvedCustomer.key
        $nameArgs['CustomerShortcode'] = $resolvedCustomer.shortcode
    }
    if (-not [string]::IsNullOrEmpty($Role)) {
        $nameArgs['Role'] = $Role
    }

    Get-AzureResourceName @nameArgs
}
