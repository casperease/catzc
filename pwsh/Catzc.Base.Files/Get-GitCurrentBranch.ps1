<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Get-GitCurrentBranch.ps1
    name: get-git-current-branch
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
    test: pwsh/Catzc.Base.Files/tests/Get-GitCurrentBranch.Tests.ps1
    docs: "[Get-GitCurrentBranch.ps1.md](docs/references/pwsh/catzc-base-files/Get-GitCurrentBranch.ps1.md)"
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
