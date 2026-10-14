<#
.SYNOPSIS
    Returns the current git commit hash (full 40-char SHA).
.DESCRIPTION
    The commit HEAD names in the checkout at Get-RepositoryRoot, read from its ref files in-process
    ([Catzc.Base.Git.GitRefs]) — what `git rev-parse HEAD` answers, without starting git.
.EXAMPLE
    Get-GitCurrentCommit
#>
function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
