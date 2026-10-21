<#
---
catzc:
  immutable:
    with_body_sha: b03ea7878fcd
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitCurrentCommit.Tests.ps1
    docs: "[Get-GitCurrentCommit.ps1.md](../../docs/references/pwsh/catzc-base-files/Get-GitCurrentCommit.ps1.md)"
---
#>

function Get-GitCurrentCommit {
    param()
    [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)), 'HEAD')
}
