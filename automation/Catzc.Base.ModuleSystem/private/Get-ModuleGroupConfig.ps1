<#
.SYNOPSIS
    Returns the declared module GROUPS from configs/dependencies.yml.
.DESCRIPTION
    A group is a named set of on-disk modules with its own internal dependency DAG — a concept,
    not a disk module. A consumer module's allowed-deps list may name a group (which permits an
    edge to any member) and/or a specific module. The group's member->member map is the layering
    contract that an ex-monolith enforced "inside one module".

    Loads the optional top-level 'groups' map via Get-Config (same parse + validation +
    session cache as Get-ModuleDependencyConfig). The returned object is an ordered dictionary:
    group name -> (ordered dictionary: member module -> list of members it may depend on).
    A file with no 'groups' key returns an empty ordered dictionary (groups are optional).
.EXAMPLE
    (Get-ModuleGroupConfig)['Base']['Catzc.Base.Writers']
#>
function Get-ModuleGroupConfig {
    param()

    $config = Get-Config -Config dependencies
    if ($config.Contains('groups')) {
        $config['groups']
    }
    else {
        [ordered]@{}
    }
}
