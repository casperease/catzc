<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Get-GitCurrentBranch.ps1
    kind: public-function
    module: Catzc.Base.Files
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the current git branch name (or 'HEAD' when detached).
.DESCRIPTION
    Reads the HEAD file directly, so no git process starts; a detached HEAD yields the name HEAD.
.EXAMPLE
    Get-GitCurrentBranch
#>
function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
