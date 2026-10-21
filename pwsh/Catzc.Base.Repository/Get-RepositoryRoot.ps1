<#
---
catzc:
  immutable:
    with_body_sha: "2f0bd90ec9a4"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1
    docs: "[Get-RepositoryRoot.ps1.md](docs/references/pwsh/catzc-base-repository/Get-RepositoryRoot.ps1.md)"
---
#>

function Get-RepositoryRoot {
    param()

    $env:RepositoryRoot
}
