<#
---
catzc:
  immutable:
    with_body_sha: "62f65ed72469"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcModulesRoot.Tests.ps1
    docs: "[Get-CatzcModulesRoot.ps1.md](../../docs/references/pwsh/catzc-base-repository/Get-CatzcModulesRoot.ps1.md)"
---
#>

function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    Join-Path (Get-RepositoryRoot) 'pwsh'
}
