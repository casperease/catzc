<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-CatzcModulesRoot.ps1
    name: get-catzc-modules-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcModulesRoot.Tests.ps1
    docs: "[Get-CatzcModulesRoot.ps1.md](docs/references/pwsh/catzc-base-repository/Get-CatzcModulesRoot.ps1.md)"
---
#>

function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    Join-Path (Get-RepositoryRoot) 'pwsh'
}
