<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/private/Get-GitIndexPath.ps1
    folder: private
    name: get-git-index-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Files/tests/Get-GitIndexPath.Tests.ps1
---
#>

function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
