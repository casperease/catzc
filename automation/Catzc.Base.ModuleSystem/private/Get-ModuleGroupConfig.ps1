<#
.SYNOPSIS
    Returns the declared module GROUPS from configs/dependencies.yml.
.DESCRIPTION
    A group is a named set of on-disk modules with its own internal dependency DAG — a concept, not a disk module.
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
