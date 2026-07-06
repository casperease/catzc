<#
.SYNOPSIS
    Returns the repo's git workspace mode ('main-direct' or 'main-via-pr').
.DESCRIPTION
    The `git_workspace` repo-wide variant (configs/variants.yml), fixed for the importer session: how
    changes reach main. 'main-direct' (the default) is the solo-author trunk — direct commits to main are
    allowed, including automation's own (Sync-GeneratedFile). 'main-via-pr' means everything reaches main
    through a PR: local work always happens on a branch, so committing is still always allowed there — the
    single stop condition is a direct commit made while standing on main locally (Test-GitWorkspace guards
    it). Flip to 'main-via-pr' when the repo goes from one author to more.
.EXAMPLE
    Get-GitWorkspace   # -> 'main-direct'
#>
function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace -Default 'main-direct')"
}
