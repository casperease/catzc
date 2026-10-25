<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/private/Get-GeneratedWriterStamp.ps1.md"
  header: "generated"
---
#>

function Get-GeneratedWriterStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $InputGlob,

        [Parameter(Mandatory)]
        [pscustomobject] $Walk,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # Every matching file on disk counts, committed or ignored, so a pull or a hand-drifted file changes the stamp as surely as an edit.
    $globs = [string[]] @($InputGlob | Where-Object { $_ })
    $matched = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($globs, [string[]] @($Walk.File))
    $folderGlobs = [string[]] @(foreach ($glob in $globs) {
            $slash = $glob.LastIndexOf('/')
            if ($slash -gt 0 -and $glob.IndexOfAny([char[]] '*?[') -ge 0 -and $glob.IndexOfAny([char[]] '*?[') -lt $slash) {
                $glob.Substring(0, $slash)
            }
        })
    $folders = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($folderGlobs, [string[]] @($Walk.Folder))
    $salt = (@($folders | Sort-Object) | ForEach-Object { "folder:$_" }) -join ';'
    if ($matched.Count -eq 0) {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($salt)
        return [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes))
    }
    Get-InputStamp -Path ([string[]] @($matched) -replace '^', ($RepositoryRoot.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar)) -Root $RepositoryRoot -Salt $salt -By Metadata
}
