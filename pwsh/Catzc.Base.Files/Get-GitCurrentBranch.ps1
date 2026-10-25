<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Get-GitCurrentBranch.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
