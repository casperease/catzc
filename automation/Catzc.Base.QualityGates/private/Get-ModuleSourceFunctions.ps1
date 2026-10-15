<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleSourceFunctions.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists a source module's public and private function names, from its files.
.DESCRIPTION
    Names come from file names, so a build can be compared with the source folder it was built from.
.PARAMETER AutomationRoot
    The automation folder of the source tree.
.PARAMETER Name
    The module folder name.
.OUTPUTS
    [pscustomobject] { Public = [string[]]; Private = [string[]] }, each ordinally sorted.
.EXAMPLE
    Get-ModuleSourceFunctions -AutomationRoot (Join-Path (Get-RepositoryRoot) 'automation') -Name Catzc.Base.Config
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
