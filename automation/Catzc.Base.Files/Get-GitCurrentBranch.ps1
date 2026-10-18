<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Get-GitCurrentBranch.ps1
    name: get-git-current-branch
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-GitCurrentBranch.Tests.ps1
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
