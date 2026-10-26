function Get-ModuleSourceFunctions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [Parameter(Mandatory)]
        [string] $Name
    )

    # A source module's folder drops the namespace its name carries, so the name resolves through the modules track.
    $folder = Join-Path $ModulesRoot (Get-Track -Name pwsh).FolderNameOf($Name)
    $privateFolder = Join-Path $folder (Get-Config -Config languages).FolderOf('private-function')
    $names = {
        param([string] $Directory)
        $found = [string[]] @(foreach ($file in [Catzc.Base.Folders.PathSet]::new().AddPattern($Directory, '*.ps1',
                    1).ToArray()) {
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
