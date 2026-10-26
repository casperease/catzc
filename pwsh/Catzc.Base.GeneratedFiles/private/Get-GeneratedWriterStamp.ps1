<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/private/Get-GeneratedWriterStamp.ps1.md"
  header: "generated"
---
#>

function Get-GeneratedWriterStamp {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Writer,

        [Parameter(Mandatory)]
        [pscustomobject] $Walk,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # Every matching file on disk counts, committed or ignored, so a pull or a hand-drifted file changes the stamp as
    # surely as an edit.
    $prefix = $RepositoryRoot.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $stamps = @{}
    $names = [System.Collections.Generic.List[string]]::new()
    $sets = [System.Collections.Generic.List[string[]]]::new()
    $salts = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Writer) {
        $globs = [string[]] @($entry.inputs | Where-Object { $_ })
        $matched = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($globs, [string[]] @($Walk.File))
        $folderGlobs = [string[]] @(foreach ($glob in $globs) {
                $slash = $glob.LastIndexOf('/')
                if ($slash -gt 0 -and $glob.IndexOfAny([char[]] '*?[') -ge 0 -and
                    $glob.IndexOfAny([char[]] '*?[') -lt $slash) {
                    $glob.Substring(0, $slash)
                }
            })
        $folders = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($folderGlobs, [string[]] @($Walk.Folder))
        $salt = (@($folders | Sort-Object) | ForEach-Object { "folder:$_" }) -join ';'
        if ($matched.Count -eq 0) {
            $stamps[$entry.name] = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($salt)))
            continue
        }
        $names.Add($entry.name)
        $sets.Add([string[]] (@($matched) -replace '^', $prefix))
        $salts.Add($salt)
    }
    # One call stamps every writer, so a file several writers read is stat'ed once for all of them.
    if ($names.Count -gt 0) {
        $computed = [Catzc.Base.Files.InputStamp]::ComputeMany($sets.ToArray(), '*', [string[]] @(), $RepositoryRoot,
            $salts.ToArray(), [Catzc.Base.Files.InputStampIdentity]::Metadata)
        for ($i = 0; $i -lt $names.Count; $i++) {
            $stamps[$names[$i]] = $computed[$i]
        }
    }
    $stamps
}
