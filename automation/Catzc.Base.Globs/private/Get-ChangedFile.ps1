<#
.SYNOPSIS
    The repo-relative paths changed across a git diff range — the diff counterpart to the tracked-file
    universe.
.DESCRIPTION
    The diff sibling of Get-TrackedFile (ADR-FLOW-CD-GLOBS:4): `git diff --name-only` over the range, with renames
    split into a delete + an add (--no-renames) so BOTH the old and the new path count as changed — a file
    moving INTO or OUT OF a globset must re-trigger it (rename correctness, the property vendor content-blind
    filters miss). `core.quotepath=off` keeps non-ASCII paths literal; paths come back '/'-separated and
    repo-relative, the same universe globsets match against. Unlike a tracked-file member, a changed path may
    be a deletion; it is still returned, matched on its path.

    A range that spans a commit absent from a shallow CI clone fails in git — a caller in a pipeline must
    ensure sufficient fetch depth (fetchDepth: 0); the reference-commit resolver owns that contract.
.PARAMETER Range
    The git diff range: a merge-base range 'origin/main...HEAD' (a PR's net change since it diverged) or a
    commit range 'HEAD^1..HEAD' (what a post-commit push added to main, first-parent of the squash commit).
.EXAMPLE
    Get-ChangedFile -Range 'HEAD^1..HEAD'
#>
function Get-ChangedFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Range
    )

    $ret = Invoke-Executable "git -c core.quotepath=off diff --name-only --no-renames $Range" -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
