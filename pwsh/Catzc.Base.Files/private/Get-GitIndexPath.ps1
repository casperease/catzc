<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-files/private/Get-GitIndexPath.ps1.md"
  header: "generated"
---
#>

function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Catzc.Base.Git.GitRefs]::IndexPath([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
