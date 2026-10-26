<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/private/Get-ModuleDependencyMap.ps1.md"
  header: "generated"
---
#>

function Get-ModuleDependencyMap {
    [OutputType([hashtable])]
    param(
        [string[]] $Module = (Get-CatzcModule -EngineTrack).name
    )

    $groups = Get-ModuleGroupConfig        # group -> (member -> [members it may depend on])
    $allowed = Get-ModuleDependencyConfig  # module -> [group|module deps]

    # group name -> its member modules, to expand a module -> group dependency to each member.
    $groupMembers = @{}
    foreach ($group in $groups.Keys) {
        $groupMembers[$group] = @($groups[$group].Keys)
    }

    # The loop variable is never $module: it would share the typed [string[]] $Module parameter's variable and be coerced.
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

    # A group target adds every member of that group, except when the module is itself a member of it.
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
