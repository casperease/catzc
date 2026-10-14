<#
.SYNOPSIS
    Returns the paths the working tree changes: modified, added, deleted and untracked files.
.DESCRIPTION
    The default request of Get-WorldMapHighlight, "where does my change sit on the map": every path
    `git status --porcelain` lists against HEAD and the index, staged or not, with each untracked file listed on its
    own (--untracked-files=all) and a rename split into its old and new path (--no-renames). The paths come back
    repository-relative and '/'-separated, as git writes them (core.quotepath=off, NUL-separated, so no path is
    quoted), distinct, in ordinal order. Nothing changed gives an empty list.

    Runs through Invoke-Executable -Silent: read-only, no console output, throws on a git failure.

    Private helper of Catzc.Base.Maps; not exported. Get-WorldMapHighlight calls it, and its tests mock it.
.OUTPUTS
    [string]
.EXAMPLE
    Get-WorldMapChangedPath
#>
function Get-WorldMapChangedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $status = Invoke-Executable 'git -c core.quotepath=off status --porcelain=v1 -z --untracked-files=all --no-renames' -PassThru -Silent
    $paths = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in ([string] $status.Output) -split "`0") {
        # Each entry is two status letters, a space and the path.
        if ($entry.Length -gt 3) {
            $null = $paths.Add($entry.Substring(3).Replace('\', '/'))
        }
    }
    @($paths)
}
