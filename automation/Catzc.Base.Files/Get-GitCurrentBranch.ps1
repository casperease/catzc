<#
.SYNOPSIS
    Returns the current git branch name (or 'HEAD' when detached).
.DESCRIPTION
    Reads the HEAD file directly, so no git process starts; a detached HEAD yields the name HEAD.
    [comment:1](/docs/references/automation/catzc-base-files/Get-GitCurrentBranch.ps1.md#comment1)
.EXAMPLE
    Get-GitCurrentBranch
#>
function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
