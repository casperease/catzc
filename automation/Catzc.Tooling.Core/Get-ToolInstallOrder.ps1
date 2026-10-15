<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns tool names from tools.yml in dependency-safe install order.
.DESCRIPTION
    Dependencies come before their dependents, and a circular DependsOn chain throws instead of looping.
.EXAMPLE
    Get-ToolInstallOrder
    # Returns @('python', 'java', 'dotnet', 'node_js', 'terraform', 'poetry', 'az_cli', 'py_spark')
#>
function Get-ToolInstallOrder {
    [OutputType([string[]])]
    param()

    $allTools = Get-Config -Config tools

    # Build adjacency: tool → list of tools it depends on
    $dependencies = @{}
    foreach ($name in $allTools.Keys) {
        # Index depends_on, as a dotted read of an absent key throws under strict mode, and keep the value an array.
        # [comment:2](/docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md#comment2)
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

    # A tool's in-degree is its own dependency count, since each dependency must be installed before it.
    # [comment:3](/docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md#comment3)
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
