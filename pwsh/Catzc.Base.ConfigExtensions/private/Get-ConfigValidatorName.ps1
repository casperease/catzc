<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1
    folder: private
    name: get-config-validator-name
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ConfigExtensions
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.ConfigExtensions/tests/Get-ConfigValidatorName.Tests.ps1
    docs: "[Get-ConfigValidatorName.ps1.md](docs/references/pwsh/catzc-base-configextensions/private/Get-ConfigValidatorName.ps1.md)"
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
