<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ModuleSourceFunctions.ps1.md"
  header: "generated"
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
    $privateFolder = Join-Path $folder (Get-Config -Config languages).FolderOf('private-function')
    $names = {
        param([string] $Directory)
        $found = [string[]] @(foreach ($file in [Catzc.Base.Folders.PathSet]::new().AddPattern($Directory, '*.ps1', 1).ToArray()) {
                [System.IO.Path]::GetFileNameWithoutExtension($file)
            })
        [System.Array]::Sort($found, [System.StringComparer]::Ordinal)
        , $found
    }

    [pscustomobject]@{
        Public  = & $names $folder
        Private = & $names $privateFolder
    }
}
