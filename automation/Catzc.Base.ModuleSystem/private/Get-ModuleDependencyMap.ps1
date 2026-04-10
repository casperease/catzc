<#
.SYNOPSIS
    Builds the declared module -> dependency-set map from configs/dependencies.yml (the edges of the declared
    graph), shared by Get-ModuleTestOrder (topological order) and Get-ModuleDependencyClosure (subset closure).
.DESCRIPTION
    Returns a hashtable: module name -> [HashSet[string]] of the modules it is declared to depend on. Edges:

      1. Group-internal layering — each group's member -> the members it may depend on.
      2. Per-module allowed deps — a specific-module target is a direct edge; a GROUP target expands to every
         member of that group, EXCEPT when the module is itself a member of that group (its intra-group order
         is governed by step 1; expanding would wrongly couple it to siblings that depend back on it).

    Only modules in -Module are kept as keys/targets, so the map is closed over the requested set.
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

    # module -> the set of modules it depends on. The loop variable must NOT be named $module: it would
    # collide (names are case-insensitive) with the [string[]] $Module parameter, whose type constraint
    # persists on the shared variable and would coerce each scalar element back into a 1-element array.
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

    # 2) Per-module allowed deps. A specific-module target is a direct edge. A GROUP target adds every member
    #    of that group — EXCEPT when the module is itself a member of that group (see .DESCRIPTION).
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
