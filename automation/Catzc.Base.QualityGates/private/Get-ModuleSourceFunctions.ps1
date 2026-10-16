<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleSourceFunctions.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
  config:
    synopsis: Lists a source module's public and private function names, from its files.
    description: |-
      A module is its folder: <Module>/*.ps1 are its public functions and <Module>/private/*.ps1 its private ones,
      one function per file named for the file. This reads the names from the file names, so a build can be
      compared with the source folder it was built from (Test-BuildArtifact's parity facet).
    parameters:
      AutomationRoot: The automation folder of the source tree.
      Name: The module folder name.
    outputs: '[pscustomobject] { Public = [string[]]; Private = [string[]] }, each ordinally sorted.'
    examples:
      - Get-ModuleSourceFunctions -AutomationRoot (Join-Path (Get-RepositoryRoot) 'automation') -Name Catzc.Base.Config
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
