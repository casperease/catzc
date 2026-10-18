<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleSourceFunctions.ps1
    folder: private
    name: get-module-source-functions
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
---
#>

function Get-ModuleSourceFunctions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $AutomationRoot,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $folder = Join-Path $AutomationRoot $Name
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
