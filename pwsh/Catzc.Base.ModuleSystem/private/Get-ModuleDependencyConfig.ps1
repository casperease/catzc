<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1
    folder: private
    name: get-module-dependency-config
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ModuleDependencyConfig.ps1.md](docs/references/pwsh/catzc-base-modulesystem/private/Get-ModuleDependencyConfig.ps1.md)"
---
#>

function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
