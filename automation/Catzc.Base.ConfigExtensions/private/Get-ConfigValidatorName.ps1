<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1
    kind: function
    module: Catzc.Base.ConfigExtensions
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the conventional PowerShell validator name for a config: Assert-<TitleCase(name)>Config.
.DESCRIPTION
    Title-casing is invariant-culture, so the validator name is the same on every machine and locale.
    [comment:1](/docs/references/automation/catzc-base-configextensions/private/Get-ConfigValidatorName.ps1.md#comment1)
.PARAMETER Name
    The config's kebab-case name, without the .yml extension.
.EXAMPLE
    Get-ConfigValidatorName -Name widget-parts
#>
function Get-ConfigValidatorName {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('(?-i)^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Name
    )

    $title = -join ($Name -split '-' | ForEach-Object {
            [cultureinfo]::InvariantCulture.TextInfo.ToTitleCase($_)
        })
    "Assert-${title}Config"
}
