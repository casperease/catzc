<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1
    folder: private
    name: get-module-dependency-config
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
---
#>

function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
