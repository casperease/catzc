<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Repository/Get-CatzcModulesRoot.ps1
    name: get-catzc-modules-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Get-CatzcModulesRoot.Tests.ps1
---
#>

function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    Join-Path (Get-RepositoryRoot) 'automation'
}
