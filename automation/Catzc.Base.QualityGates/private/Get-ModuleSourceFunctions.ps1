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
