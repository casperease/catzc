<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/private/Get-ModuleGroupConfig.ps1
    folder: private
    name: get-module-group-config
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
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1
    docs: "[Get-ModuleGroupConfig.ps1.md](docs/references/pwsh/catzc-base-modulesystem/private/Get-ModuleGroupConfig.ps1.md)"
---
#>

function Get-ModuleGroupConfig {
    param()

    $groups = [ordered]@{}
    foreach ($group in (Get-Config -Config dependencies).groups.Values) {
        $groups[$group.name] = $group.members
    }
    $groups
}
