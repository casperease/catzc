<#
.SYNOPSIS
    Returns the absolute path of the repository's git index file.
.DESCRIPTION
    The index of the checkout at Get-RepositoryRoot: `<root>/.git/index` for a plain checkout, or `<gitdir>/index`...
    [comment:1](/docs/references/automation/catzc-base-files/private/Get-GitIndexPath.ps1.md#comment1)
.OUTPUTS
    [string]
#>
function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
