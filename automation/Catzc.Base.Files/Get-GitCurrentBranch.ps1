<#
.SYNOPSIS
    Returns the current git branch name (or 'HEAD' when detached).
.DESCRIPTION
    The branch HEAD is on in the checkout at Get-RepositoryRoot, read from its HEAD file in-process
    ([Catzc.Base.Git.GitRefs]) — what `git rev-parse --abbrev-ref HEAD` answers, without starting git.
.EXAMPLE
    Get-GitCurrentBranch
#>
function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
