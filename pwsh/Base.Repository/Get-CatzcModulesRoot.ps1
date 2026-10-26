<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-CatzcModulesRoot.ps1.md"
  header: "generated"
---
#>

function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    Join-Path (Get-RepositoryRoot) 'pwsh'
}
