<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleOrder.ps1
    name: get-module-order
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleOrder.Tests.ps1
    cites:
      - ADR-AUTO-MODULE#5
  config:
    synopsis: |-
      Returns module names in foundation-first order — a topological sort of the declared dependency graph
      (configs/dependencies.yml), so a module is ordered after every module it may depend on.
    description: |-
      The one function that sorts the graph ([ADR-AUTO-MODULE#5](/docs/adr/automation/module-model.md#rule-adr-auto-module5)); every
      command that needs modules in dependency order calls it and never sorts again.

      Builds the module -> dependencies map from the declared graph: each group's internal member -> member
      layering, plus each module's allowed dependencies (a group target expands to all the group's members).
      Then topologically sorts (Kahn's algorithm) with an ordinal-alphabetical tie-break for a stable order.

      Every module in -Module appears exactly once; a module with no declared dependencies sorts among the roots. Throws on a cycle
      (which the DependenciesConfig type already prevents at load).

      Test-Automation uses this to run module tests foundation-first, so a broken base module's failures
      surface before the dependents that cascade from it.
    parameters:
      Module: The module names to order. Defaults to the modules of the code track (Get-CatzcModule).
    examples:
      - |-
        Get-ModuleOrder
        # -> Catzc.Base.Asserts, Catzc.Base.Environment, Catzc.Base.Objects, Catzc.Base.Repository, ...
---
#>

function Get-ModuleOrder {
    [OutputType([string[]])]
    param(
        [string[]] $Module = (Get-CatzcModule -TrackType modules).name
    )

    $modules = [string[]] @($Module)
    [System.Array]::Sort($modules, [System.StringComparer]::Ordinal)

    $dependencyMap = Get-ModuleDependencyMap -Module $modules

    $inDegree = @{}
    foreach ($name in $modules) {
        $inDegree[$name] = $dependencyMap[$name].Count
    }

    $order = [System.Collections.Generic.List[string]]::new()
    $ready = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $modules) {
        if ($inDegree[$name] -eq 0) {
            $ready.Add($name)
        }
    }

    while ($ready.Count -gt 0) {
        $current = $ready[0]
        $ready.RemoveAt(0)
        $order.Add($current)

        $newlyReady = [System.Collections.Generic.List[string]]::new()
        foreach ($name in $modules) {
            if ($dependencyMap[$name].Contains($current)) {
                $inDegree[$name]--
                if ($inDegree[$name] -eq 0) {
                    $newlyReady.Add($name)
                }
            }
        }
        if ($newlyReady.Count -gt 0) {
            foreach ($name in $newlyReady) {
                $ready.Add($name)
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
