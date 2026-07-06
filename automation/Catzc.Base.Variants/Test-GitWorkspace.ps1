<#
.SYNOPSIS
    Tests whether the repo's git workspace mode (the `git_workspace` variant) is the one named.
.DESCRIPTION
    A predicate over the `git_workspace` repo-wide variant (see Get-GitWorkspace). Pass exactly one of
    -MainDirect or -MainViaPr; returns $true when the repo's mode matches. The canonical consumer shape is
    the stop condition for automated commits: `(Test-GitWorkspace -MainViaPr) -and <on main locally>` — in
    main-via-pr mode local work always happens on a branch, so standing on main is the only place a direct
    commit is forbidden.
.PARAMETER MainDirect
    Test for the 'main-direct' mode (solo-author trunk; direct commits to main allowed).
.PARAMETER MainViaPr
    Test for the 'main-via-pr' mode (changes reach main only through a PR).
.EXAMPLE
    if ((Test-GitWorkspace -MainViaPr) -and $branch -in 'main', 'master') { return }
#>
function Test-GitWorkspace {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'MainDirect')]
        [switch] $MainDirect,

        [Parameter(Mandatory, ParameterSetName = 'MainViaPr')]
        [switch] $MainViaPr
    )

    $mode = Get-GitWorkspace
    ($MainDirect -and $mode -eq 'main-direct') -or ($MainViaPr -and $mode -eq 'main-via-pr')
}
