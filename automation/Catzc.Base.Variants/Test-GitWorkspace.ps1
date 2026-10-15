<#
.SYNOPSIS
    Tests whether the repo's git workspace mode (the `git_workspace` variant) is the one named.
.DESCRIPTION
    A predicate over the `git_workspace` repo-wide variant (see Get-GitWorkspace).
    [comment:1](/docs/references/automation/catzc-base-variants/Test-GitWorkspace.ps1.md#comment1)
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
