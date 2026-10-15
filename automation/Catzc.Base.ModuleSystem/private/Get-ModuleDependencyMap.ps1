# catzc:
#   path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1
#   module: Catzc.Base.ModuleSystem
#   visibility: private

<#
.SYNOPSIS
    Builds the declared module -> dependency-set map from configs/dependencies.yml (the edges of the declared
    graph), shared by Get-ModuleTestOrder (topological order) and Get-ModuleDependencyClosure (subset closure).
.DESCRIPTION
    A group target expands to its members except for a member of that group, whose order step 1 already governs.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md#comment1)
.PARAMETER Module
    The module set to build the map over. Defaults to all on-disk modules (Get-AutomationModules).
.EXAMPLE
    $dependencyMap = Get-ModuleDependencyMap
    $dependencyMap['Catzc.Azure.Templates']   # -> the modules it depends on
#>
function Get-ModuleDependencyMap {
    [OutputType([hashtable])]
    param(
        [string[]] $Module = (Get-AutomationModules)
    )

    $groups = Get-ModuleGroupConfig        # group -> (member -> [members it may depend on])
    $allowed = Get-ModuleDependencyConfig  # module -> [group|module deps]

    # group name -> its member modules, to expand a module -> group dependency to each member.
    $groupMembers = @{}
    foreach ($group in $groups.Keys) {
        $groupMembers[$group] = @($groups[$group].Keys)
    }

    # The loop variable avoids $module: names are case-insensitive, so the typed $Module parameter would coerce it.
    # [comment:2](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md#comment2)
    $dependencyMap = @{}
    foreach ($moduleName in $Module) {
        $dependencyMap[$moduleName] = [System.Collections.Generic.HashSet[string]]::new()
    }

    # 1) Group-internal layering: member -> the members it may depend on.
    foreach ($group in $groups.Keys) {
        $members = $groups[$group]
        foreach ($member in $members.Keys) {
            foreach ($dependency in @($members[$member])) {
                if ($dependencyMap.ContainsKey($member) -and $dependencyMap.ContainsKey($dependency)) {
                    [void] $dependencyMap[$member].Add($dependency)
                }
            }
        }
    }

    # A group target skips a module's own group: step 1 governs that order, and expanding would couple siblings.
    # [comment:3](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md#comment3)
    foreach ($moduleName in $allowed.Keys) {
        if (-not $dependencyMap.ContainsKey($moduleName)) {
            continue
        }
        foreach ($dependency in @($allowed[$moduleName])) {
            if ($groupMembers.ContainsKey($dependency)) {
                if ($moduleName -in $groupMembers[$dependency]) {
                    continue
                }
                foreach ($target in $groupMembers[$dependency]) {
                    if ($dependencyMap.ContainsKey($target) -and $target -ne $moduleName) {
                        [void] $dependencyMap[$moduleName].Add($target)
                    }
                }
            }
            elseif ($dependencyMap.ContainsKey($dependency) -and $dependency -ne $moduleName) {
                [void] $dependencyMap[$moduleName].Add($dependency)
            }
        }
    }

    $dependencyMap
}
