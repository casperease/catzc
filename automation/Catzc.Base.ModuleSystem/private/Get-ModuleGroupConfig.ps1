<#
.SYNOPSIS
    Returns the declared module GROUPS from configs/dependencies.yml.
.DESCRIPTION
    A file without a groups key yields an empty dictionary, since groups are optional.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleGroupConfig.ps1.md#comment1)
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
