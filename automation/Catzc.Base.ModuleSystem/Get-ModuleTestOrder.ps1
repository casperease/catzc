<#
.SYNOPSIS
    Returns all automation module names in foundation-first order — a topological sort of the declared
    dependency graph (configs/dependencies.yml), so a module is ordered after every module it may depend on.
.DESCRIPTION
    Builds the module -> dependencies map from the declared graph: each group's internal member -> member layering,...
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md#comment1)
.EXAMPLE
    Get-ModuleTestOrder
    # -> Catzc.Base.Asserts, Catzc.Base.Environment, Catzc.Base.Objects, Catzc.Base.Repository, ...
#>
function Get-ModuleTestOrder {
    [OutputType([string[]])]
    param()

    # Ordinal-sort the module set ourselves (not relying on the caller's order) so the topological sort's tie-break...
    # [comment:2](/docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md#comment2)
    $modules = [string[]] @(Get-AutomationModules)
    [System.Array]::Sort($modules, [System.StringComparer]::Ordinal)

    # module -> the set of modules it must run AFTER — the declared-graph edges (group-internal layering plus each...
    # [comment:3](/docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md#comment3)
    $dependencyMap = Get-ModuleDependencyMap -Module $modules

    # Kahn's topological sort.
    # [comment:4](/docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md#comment4)
    $inDegree = @{}
    foreach ($module in $modules) {
        $inDegree[$module] = $dependencyMap[$module].Count
    }

    $order = [System.Collections.Generic.List[string]]::new()
    $ready = [System.Collections.Generic.List[string]]::new()
    foreach ($module in $modules) {
        if ($inDegree[$module] -eq 0) {
            $ready.Add($module)
        }
    }

    while ($ready.Count -gt 0) {
        $current = $ready[0]
        $ready.RemoveAt(0)
        $order.Add($current)

        $newlyReady = [System.Collections.Generic.List[string]]::new()
        foreach ($module in $modules) {
            if ($dependencyMap[$module].Contains($current)) {
                $inDegree[$module]--
                if ($inDegree[$module] -eq 0) {
                    $newlyReady.Add($module)
                }
            }
        }
        if ($newlyReady.Count -gt 0) {
            foreach ($module in $newlyReady) {
                $ready.Add($module)
            }
            $merged = [string[]] $ready.ToArray()
            [System.Array]::Sort($merged, [System.StringComparer]::Ordinal)
            $ready = [System.Collections.Generic.List[string]] $merged
        }
    }

    if ($order.Count -ne $modules.Count) {
        $missing = @($modules | Where-Object { $_ -notin $order })
        throw "Cycle in the module dependency graph (configs/dependencies.yml) among: $($missing -join ', ')"
    }

    $order.ToArray()
}
