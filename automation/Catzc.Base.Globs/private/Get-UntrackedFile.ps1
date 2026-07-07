<#
.SYNOPSIS
    Returns every untracked working-tree file (including gitignored) as a repo-relative, '/'-separated path
    — the NON-GIT universe for the companion's 'filtered' list.
.DESCRIPTION
    The companion complement to Get-TrackedFile (ADR-GLOBS:11): `git ls-files --others` WITHOUT
    `--exclude-standard`, so it lists everything on disk that is not git-bound — untracked AND gitignored
    (build residue, generated manifests, `out/` files). This is deliberately NOT reproducible — it is a
    fact of the local working tree — so it feeds only the gitignored, ungated companion file, never a
    marker or a durable SHA. `core.quotepath` is forced off so non-ASCII paths come back literal.
.EXAMPLE
    Get-UntrackedFile
#>
function Get-UntrackedFile {
    param()
    $ret = Invoke-Executable 'git -c core.quotepath=off ls-files --others' -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
