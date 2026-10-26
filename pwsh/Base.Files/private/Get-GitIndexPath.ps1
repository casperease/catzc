function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
