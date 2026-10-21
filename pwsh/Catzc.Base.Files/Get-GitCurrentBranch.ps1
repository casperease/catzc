<#
---
catzc:
  immutable:
    with_body_sha: "1e6194d9d134"
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitCurrentBranch.Tests.ps1
    docs: "[Get-GitCurrentBranch.ps1.md](../../docs/references/pwsh/catzc-base-files/Get-GitCurrentBranch.ps1.md)"
---
#>

function Get-GitCurrentBranch {
    param()
    [Catzc.Base.Git.GitRefs]::CurrentBranch([Catzc.Base.Git.GitRefs]::GitDirectory((Get-RepositoryRoot)))
}
