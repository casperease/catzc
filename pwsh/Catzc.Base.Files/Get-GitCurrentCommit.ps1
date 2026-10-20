<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Get-GitCurrentCommit.ps1
    name: get-git-current-commit
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitCurrentCommit.Tests.ps1
    docs: "[Get-GitCurrentCommit.ps1.md](docs/references/pwsh/catzc-base-files/Get-GitCurrentCommit.ps1.md)"
---
#>

function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
