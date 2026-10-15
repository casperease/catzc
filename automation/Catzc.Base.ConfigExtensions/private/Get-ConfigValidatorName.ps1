<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1
    kind: private-function
    module: Catzc.Base.ConfigExtensions
    visibility: private
  config:
    synopsis: 'Returns the conventional PowerShell validator name for a config: Assert-<TitleCase(name)>Config.'
    description: |-
      The one place the validator naming convention lives: each kebab-case segment of the config name is
      title-cased (invariant culture) and joined, so 'widget' becomes Assert-WidgetConfig and 'widget-parts'
      becomes Assert-WidgetPartsConfig.
    parameters:
      Name: The config's kebab-case name, without the .yml extension.
    examples:
      - Get-ConfigValidatorName -Name widget-parts
---
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
