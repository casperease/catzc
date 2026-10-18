<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleGroupConfig.ps1
    folder: private
    name: get-module-group-config
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1
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
