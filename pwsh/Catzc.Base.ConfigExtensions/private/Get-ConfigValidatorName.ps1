<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config-extensions/private/Get-ConfigValidatorName.ps1.md"
  header: "generated"
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
