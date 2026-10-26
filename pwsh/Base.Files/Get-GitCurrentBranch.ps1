<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Get-GitCurrentBranch.ps1.md"
  header: "generated"
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
