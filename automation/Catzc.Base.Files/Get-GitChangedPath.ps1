# catzc:
#   path: automation/Catzc.Base.Files/Get-GitChangedPath.ps1
#   module: Catzc.Base.Files
#   visibility: public

<#
.SYNOPSIS
    Returns the repository paths that differ from HEAD: what the working tree has changed.
.DESCRIPTION
    A rename counts as both paths and a deleted path is listed, so a caller that reads files must skip missing ones.
    [comment:1](/docs/references/automation/catzc-base-files/Get-GitChangedPath.ps1.md#comment1)
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) to look under; '.' (the default) for all.
.OUTPUTS
    [string]
.EXAMPLE
    Get-GitChangedPath
.EXAMPLE
    Get-GitChangedPath 'automation/Catzc.Base.Files', 'docs'
#>
function Get-GitChangedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Path = @('.')
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $status = Invoke-Executable "git status --porcelain=v1 -z --untracked-files=all --no-renames -- $($quotedPaths -join ' ')" `
        -WorkingDirectory (Get-RepositoryRoot) -PassThru -Silent
    # Each -z entry is 'XY <path>' (two status letters, a space, the path), NUL-terminated.
    $changed = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in ("$($status.Output)" -split "`0")) {
        if ($entry.Length -gt 3) {
            [void]$changed.Add($entry.Substring(3))
        }
    }
    $changed
}
