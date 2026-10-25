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

    # The stamp of every file on disk a writer's inputs match, committed, changed or ignored alike, so a pull or a drifted ignored file
    # changes it as surely as an edit; salted with the folders a wildcard glob's leaf could be written into, so a new folder that should
    # receive a generated file makes the writer due before the file exists. The files and folders are the shared walk's.
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
    Get-InputStamp -Path @($matched | ForEach-Object { [System.IO.Path]::Combine($RepositoryRoot, $_) }) -Root $RepositoryRoot -Salt $salt
}
