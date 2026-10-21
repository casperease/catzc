<#
---
catzc:
  immutable:
    with_body_sha: "0b8c953d8359"
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
