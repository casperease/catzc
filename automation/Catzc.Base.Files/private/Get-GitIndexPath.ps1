<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/private/Get-GitIndexPath.ps1
    kind: function
    module: Catzc.Base.Files
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the absolute path of the repository's git index file.
.DESCRIPTION
    The file may be absent (a fresh git init with nothing added); the caller reads that as nothing tracked.
.OUTPUTS
    [string]
#>
function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
