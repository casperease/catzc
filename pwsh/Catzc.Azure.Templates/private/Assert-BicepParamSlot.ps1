<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Assert-BicepParamSlot.ps1.md"
  header: "generated"
---
#>

function Assert-BicepParamSlot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $File,

        [Parameter(Mandatory)]
        [string] $Main,

        [Parameter(Mandatory)]
        [string] $Template,

        [Parameter(Mandatory)]
        [bool] $HasPrePost
    )

    $name = [System.IO.Path]::GetFileName($File)
    if ($HasPrePost) {
        throw "Template '$Template' has a PrePost hook, so it takes no bicepparam slot: write $name as a yml slot."
    }
    $using = [regex]::Match([System.IO.File]::ReadAllText($File), "(?m)^\s*using\s+'(?<path>[^']+)'")
    if (-not $using.Success) {
        throw "Template '$Template': $name has no using line; a bicepparam slot names its template's main.bicep."
    }
    $target = [System.IO.Path]::GetFullPath((Join-Path ([System.IO.Path]::GetDirectoryName($File)) $using.Groups['path'].Value))
    if (-not [string]::Equals($target, [System.IO.Path]::GetFullPath($Main),
            [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Template '$Template': $name uses '$($using.Groups['path'].Value)', which is not the template's main.bicep."
    }
}
