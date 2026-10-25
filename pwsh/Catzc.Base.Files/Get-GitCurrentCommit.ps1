<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Get-GitCurrentCommit.ps1.md"
  warning: "Generated Header"
---
#>

function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
