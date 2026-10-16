<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleTestOrder.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md
      test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleTestOrder.Tests.ps1
  config:
    synopsis: |-
      Returns all automation module names in foundation-first order — a topological sort of the declared
      dependency graph (configs/dependencies.yml), so a module is ordered after every module it may depend on.
    description: |-
      Builds the module -> dependencies map from the declared graph: each group's internal member -> member
      layering, plus each module's allowed dependencies (a group target expands to all the group's members).
      Then topologically sorts (Kahn's algorithm) with an ordinal-alphabetical tie-break for a stable order.

      Every on-disk module (Get-AutomationModules) appears exactly once; a module with no declared dependencies
      sorts among the roots. Throws on a cycle (which the DependenciesConfig type already prevents at load).

      Test-Automation uses this to run module tests foundation-first, so a broken base module's failures
      surface before the dependents that cascade from it.
    examples:
      - |-
        Get-ModuleTestOrder
        # -> Catzc.Base.Asserts, Catzc.Base.Environment, Catzc.Base.Objects, Catzc.Base.Repository, ...
---
#>

function Get-ModuleTestOrder {
    [OutputType([string[]])]
    param()

    $modules = [string[]] @(Get-AutomationModules)
    [System.Array]::Sort($modules, [System.StringComparer]::Ordinal)

    $dependencyMap = Get-ModuleDependencyMap -Module $modules

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
