<#
.SYNOPSIS
    Returns the current git branch name (or 'HEAD' when detached).
.DESCRIPTION
    The branch HEAD is on in the checkout at Get-RepositoryRoot, read from its HEAD file in-process...
    [comment:1](/docs/references/automation/catzc-base-files/Get-GitCurrentBranch.ps1.md#comment1)
.EXAMPLE
    Get-GitCurrentBranch
#>
function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
