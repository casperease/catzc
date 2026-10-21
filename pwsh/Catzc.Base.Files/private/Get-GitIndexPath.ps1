<#
---
catzc:
  immutable:
    with_body_sha: ee622bb74788
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
