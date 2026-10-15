<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleGroupConfig.ps1
    kind: private-function
    module: Catzc.Base.ModuleSystem
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the declared module GROUPS from configs/dependencies.yml.
.DESCRIPTION
    A file without a groups key yields an empty dictionary, since groups are optional.
.EXAMPLE
    (Get-ModuleGroupConfig)['Base']['Catzc.Base.Writers']
#>
function Get-ModuleGroupConfig {
    param()

    $groups = [ordered]@{}
    foreach ($group in (Get-Config -Config dependencies).groups.Values) {
        $groups[$group.name] = $group.members
    }
    $groups
}
