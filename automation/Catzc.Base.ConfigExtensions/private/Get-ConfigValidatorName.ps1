<#
.SYNOPSIS
    Returns the conventional PowerShell validator name for a config: Assert-<TitleCase(name)>Config.
.DESCRIPTION
    The one place the validator naming convention lives: each kebab-case segment of the config name is title-cased...
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
