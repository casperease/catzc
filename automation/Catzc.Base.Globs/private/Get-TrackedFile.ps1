<#
.SYNOPSIS
    Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
.DESCRIPTION
    The one place this module shells to git. `git ls-files` defines "files under version control"
    (ADR-GLOBS:4): deterministic on every checkout, independent of build residue, blind to untracked and
    ignored files. `core.quotepath` is forced off so non-ASCII paths come back literal, not C-quoted.
    A tracked file may be missing on disk (an unstaged deletion) — it is still listed here; the hash layer
    folds a distinct marker for it.
.EXAMPLE
    Get-TrackedFile
#>
function Get-TrackedFile {
    param()
    $ret = Invoke-Executable 'git -c core.quotepath=off ls-files' -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
