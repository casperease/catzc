<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Get-GitCurrentCommit.ps1
    kind: public-function
    module: Catzc.Base.Files
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the current git commit hash (full 40-char SHA).
.DESCRIPTION
    Resolves HEAD from the ref files in-process, so no git process starts.
.EXAMPLE
    Get-GitCurrentCommit
#>
function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
