<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ModuleSourceFunctions.ps1
    folder: private
    name: get-module-source-functions
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ModuleSourceFunctions.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleSourceFunctions.ps1.md)"
---
#>

function Get-ModuleSourceFunctions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $folder = Join-Path $ModulesRoot $Name
    $privateFolder = Join-Path $folder 'private'
    $names = {
        param([string] $Directory)
        $found = [string[]] @(if ([System.IO.Directory]::Exists($Directory)) {
                foreach ($file in [System.IO.Directory]::GetFiles($Directory, '*.ps1')) {
                    [System.IO.Path]::GetFileNameWithoutExtension($file)
                }
            })
        [System.Array]::Sort($found, [System.StringComparer]::Ordinal)
        , $found
    }

    [pscustomobject]@{
        Public  = & $names $folder
        Private = & $names $privateFolder
    }
}
