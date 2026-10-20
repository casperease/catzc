<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/private/Get-GitIndexPath.ps1
    folder: private
    name: get-git-index-path
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitIndexPath.Tests.ps1
    docs: "[Get-GitIndexPath.ps1.md](docs/references/pwsh/catzc-base-files/private/Get-GitIndexPath.ps1.md)"
---
#>

function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
