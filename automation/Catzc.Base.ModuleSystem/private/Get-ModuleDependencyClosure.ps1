<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyClosure.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1
  config:
    synopsis: |-
      Returns the transitive declared-dependency closure of a set of modules — the seeds plus every module they
      depend on (directly or indirectly), per configs/dependencies.yml.
    description: |-
      Breadth-first over the declared dependency map (Get-ModuleDependencyMap). The declared graph is a superset
      of the real code edges (Test-ModuleDependency enforces actual ⊆ declared), so the closure is guaranteed
      to contain every module the seeds need to load — copying it (Get-ModuleProfile → Copy-Automation) yields a
      loadable subset. A group dependency was already expanded to its members when the map was built. Result is
      ordinal-sorted for determinism. Seeds that are not on-disk modules contribute themselves but no edges.
    parameters:
      Module: The seed module names to close over.
    examples:
      - |-
        Get-ModuleDependencyClosure -Module Catzc.Azure.Templates
        # -> Catzc.Azure.Templates plus its Base/Tooling/Catzc.Azure dependencies
---
#>

function Get-ModuleDependencyClosure {
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Module
    )

    $dependencyMap = Get-ModuleDependencyMap
    $closure = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $queue = [System.Collections.Generic.Queue[string]]::new()

    foreach ($seed in $Module) {
        if ($seed -and $closure.Add($seed)) {
            $queue.Enqueue($seed)
        }
    }
    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        if ($dependencyMap.ContainsKey($current)) {
            foreach ($dependency in $dependencyMap[$current]) {
                if ($closure.Add($dependency)) {
                    $queue.Enqueue($dependency)
                }
            }
        }
    }

    $ret = [string[]] @($closure)
    [System.Array]::Sort($ret, [System.StringComparer]::Ordinal)
    $ret
}
