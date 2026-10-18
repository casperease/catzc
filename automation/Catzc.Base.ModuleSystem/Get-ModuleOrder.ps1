<#
---
catzc:
  immutable:
    repo_status: clean
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
