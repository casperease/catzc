<#
.SYNOPSIS
    Validates the declared module dependency graph, throwing all violations at once.
.DESCRIPTION
    Config-internal integrity for configs/dependencies.yml. No code graph is
    involved — this only checks the declared graph is well-formed:

    - a required top-level 'modules' map
    - each entry maps to a list of names (not a single string)
    - no module declares a dependency on itself
    - every dependency target is itself a declared module OR a declared group ("exists in
      configuration"), so the declared graph is closed
    - the declared module graph is acyclic (a DAG); the first cycle found is reported

    An OPTIONAL top-level 'groups' map declares named module sets, each with its own internal
    member->member DAG (a group is a concept, not a disk module). When present it is validated:

    - each group maps to a map (member -> list of members), not a list or string
    - each member's deps are a list of members of the SAME group (the group is closed)
    - no member depends on itself
    - each group's internal member graph is acyclic

    Named by the Get-Config validator convention (Assert-<Name>Config for config 'dependencies')
    and run in the owning module's scope, so a malformed file throws at read time, everywhere it
    is read. A module absent from the map is unconstrained and is not the concern of this validator.
.PARAMETER Config
    The parsed dependencies.yml — an ordered dictionary with a 'modules' key and an optional 'groups' key.
.EXAMPLE
    Assert-DependenciesConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-DependenciesConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('modules')) {
        throw "module dependency configuration validation failed:`nMissing required top-level key: 'modules'"
    }

    $modules = $Config['modules']
    $groups = if ($Config.Contains('groups')) {
        $Config['groups']
    }
    else {
        [ordered]@{}
    }
    $errors = [System.Collections.Generic.List[string]]::new()
    $moduleKeys = @($modules.Keys)
    $groupNames = @($groups.Keys)

    # Returns the first cycle (as "A -> B -> A") in an adjacency hashtable of node -> string[], or $null.
    $findCycle = {
        param([hashtable] $Adjacency)

        $white = 0; $gray = 1; $black = 2
        $color = @{}
        foreach ($n in $Adjacency.Keys) {
            $color["$n"] = $white
        }
        $path = [System.Collections.Generic.List[string]]::new()
        $found = [System.Collections.Generic.List[string]]::new()

        $visit = {
            param([string] $Node)

            if ($found.Count -gt 0) {
                return
            }
            $color[$Node] = $gray
            $path.Add($Node)
            foreach ($next in $Adjacency[$Node]) {
                if ($found.Count -gt 0) {
                    break
                }
                if ($color["$next"] -eq $gray) {
                    $index = $path.IndexOf("$next")
                    $loop = $path.GetRange($index, $path.Count - $index)
                    $loop.Add("$next")
                    $found.Add(($loop -join ' -> '))
                    break
                }
                elseif ($color["$next"] -eq $white) {
                    & $visit -Node "$next"
                }
            }
            $path.RemoveAt($path.Count - 1)
            $color[$Node] = $black
        }

        foreach ($n in $Adjacency.Keys) {
            if ($color["$n"] -eq $white) {
                & $visit -Node "$n"
            }
        }
        if ($found.Count -gt 0) {
            $found[0]
        }
        else {
            $null
        }
    }

    # --- groups: shape, closed-within-group, internal a-cyclicity -------------------------------------
    foreach ($group in $groupNames) {
        $members = $groups[$group]
        if ($members -is [string] -or $members -is [System.Collections.IList]) {
            $errors.Add("group '$group' must map to a map of member modules, not a list or string")
            continue
        }
        $memberKeys = @($members.Keys)
        foreach ($member in $memberKeys) {
            $dependencies = $members[$member]
            if ($null -eq $dependencies) {
                continue
            }
            if ($dependencies -is [string]) {
                $errors.Add("group '$group' member '$member' must map to a list of member modules, not a single string")
                continue
            }
            foreach ($target in $dependencies) {
                if ("$target" -eq "$member") {
                    $errors.Add("group '$group' member '$member' declares a dependency on itself")
                    continue
                }
                if (-not $members.Contains("$target")) {
                    $errors.Add("group '$group' member '$member' depends on '$target', which is not a member of group '$group'")
                }
            }
        }

        $adj = @{}
        foreach ($member in $memberKeys) {
            $adj["$member"] = @(@($members[$member]) |
                    Where-Object { $_ -and $members.Contains("$_") -and "$_" -ne "$member" } |
                    ForEach-Object { "$_" })
        }
        $cycle = & $findCycle $adj
        if ($cycle) {
            $errors.Add("group '$group' dependency cycle: $cycle")
        }
    }

    # --- modules: shape, self-dependency, target-is-declared (module or group) -----------------------
    foreach ($module in $moduleKeys) {
        $dependencies = $modules[$module]
        if ($null -eq $dependencies) {
            continue
        }                       # declared, depends on nothing
        if ($dependencies -is [string]) {
            $errors.Add("module '$module' must map to a list of names, not a single string")
            continue
        }
        foreach ($target in $dependencies) {
            if ("$target" -eq "$module") {
                $errors.Add("module '$module' declares a dependency on itself")
                continue
            }
            if (-not $modules.Contains("$target") -and "$target" -notin $groupNames) {
                $errors.Add("module '$module' depends on '$target', which is not declared in configuration (add a '$target' module or group entry so it exists in configuration)")
            }
        }
    }

    # Acyclic check over declared MODULE edges only (targets that are themselves declared modules, never
    # a group or self). Group references are a lower layer and cannot form a module-level cycle.
    $adj = @{}
    foreach ($module in $moduleKeys) {
        $dependencies = $modules[$module]
        $adj["$module"] = @(@($dependencies) |
                Where-Object { $_ -and $modules.Contains("$_") -and "$_" -ne "$module" } |
                ForEach-Object { "$_" })
    }
    $cycle = & $findCycle $adj
    if ($cycle) {
        $errors.Add("dependency cycle: $cycle")
    }

    if ($errors.Count -gt 0) {
        throw "module dependency configuration validation failed:`n$($errors -join "`n")"
    }
}
