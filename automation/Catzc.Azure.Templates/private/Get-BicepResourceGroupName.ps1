<#
.SYNOPSIS
    Derives a template slot's resource-group name from the Azure naming standard.
.DESCRIPTION
    The name is derived from the naming standard, never hand-typed in config, so deploy and tag scope agree.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepResourceGroupName.ps1.md#comment1)
.PARAMETER Template
    Template name.
.PARAMETER Environment
    Environment shortname.
.PARAMETER Slot
    Optional special-slot discriminator; omitted selects the env's base / index-0 slot.
.PARAMETER Customer
    Optional customer; renders into the RG name and is required to disambiguate a per-customer RG.
.EXAMPLE
    Get-BicepResourceGroupName -Template sample -Environment dev          # -> dev-weu-zct-smpl-rg
.EXAMPLE
    Get-BicepResourceGroupName -Template sample -Environment dev -Customer apex   # -> dev-weu-zct-smpl-apex-rg
.EXAMPLE
    Get-BicepResourceGroupName -Template sample-indexed -Environment dev -Slot 001
    # -> dev-001-weu-zct-sidx-rg
#>
function Get-BicepResourceGroupName {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'ArgumentCompleter scriptblocks require PowerShell''s fixed 5-parameter completer signature; only $fakeBoundParameters is used, but the other four are mandatory and cannot be removed')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
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

    Get-BicepResourceName -Template $Template -Environment $Environment -Slot $Slot -Customer $Customer -Type rg
}
