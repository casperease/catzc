<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1
    kind: automation-function
    module: Catzc.Tooling.Core
    visibility: public
  config:
    synopsis: Returns tool names from tools.yml in dependency-safe install order.
    description: |-
      Performs a topological sort based on DependsOn fields. Tools with no
      dependencies come first, tools that depend on others come after their
      dependencies. Throws on circular dependencies.
    examples:
      - |-
        Get-ToolInstallOrder
        # Returns @('python', 'java', 'dotnet', 'node_js', 'terraform', 'poetry', 'az_cli', 'py_spark')
---
#>

function Get-ToolInstallOrder {
    [OutputType([string[]])]
    param()

    $allTools = Get-Config -Config tools

    # Build adjacency: tool → list of tools it depends on
    $dependencies = @{}
    foreach ($name in $allTools.Keys) {
        # depends_on is optional: index it (a dotted read of an absent key throws under strict), and keep the value...
        # [comment:4](/docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md#comment4)
        $dependency = $allTools[$name]['depends_on']
        $dependencies[$name] = [string[]] @(
            if ($dependency) {
                $dependency
            }
        )
    }

    # Kahn's algorithm — topological sort
    $order = [System.Collections.Generic.List[string]]::new()
    $noDependencies = [System.Collections.Generic.Queue[string]]::new()

    # Kahn's algorithm for install order: if A depends on B, B must be installed first, so the edge runs B → A.
    # [comment:5](/docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md#comment5)
    $inDegree = @{}
    foreach ($name in $dependencies.Keys) {
        $inDegree[$name] = $dependencies[$name].Count
    }

    foreach ($name in $dependencies.Keys) {
        if ($inDegree[$name] -eq 0) {
            $noDependencies.Enqueue($name)
        }
    }

    while ($noDependencies.Count -gt 0) {
        $current = $noDependencies.Dequeue()
        $order.Add($current)

        # Find all tools that depend on $current and reduce their in-degree
        foreach ($name in $dependencies.Keys) {
            if ($dependencies[$name] -contains $current) {
                $inDegree[$name]--
                if ($inDegree[$name] -eq 0) {
                    $noDependencies.Enqueue($name)
                }
            }
        }
    }

    if ($order.Count -ne $dependencies.Count) {
        $missing = $dependencies.Keys | Where-Object { $_ -notin $order }
        throw "Circular dependency detected among tools: $($missing -join ', ')"
    }

    $order.ToArray()
}
