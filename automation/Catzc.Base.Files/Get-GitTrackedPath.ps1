<#
.SYNOPSIS
    Returns the subset of the given repository paths that git tracks.
.DESCRIPTION
    A thin, read-only query over `git ls-files -- <paths>`: every tracked file at or under the given paths, as
    a repo-relative, '/'-separated path. A path git does not track (new, ignored, or absent) contributes
    nothing, so "is this file under version control?" is a membership test on the result. `core.quotepath`
    is forced off so non-ASCII paths come back literal, not C-quoted.

    Runs through Invoke-Executable -Silent: read-only, no console output, throws on a git failure.
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) to look up.
.OUTPUTS
    [string]
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs/glossary.yml'
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs', 'docs/adr'
#>
function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $listing = Invoke-Executable "git -c core.quotepath=off ls-files -- $($quotedPaths -join ' ')" -PassThru -Silent
    $listing.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
