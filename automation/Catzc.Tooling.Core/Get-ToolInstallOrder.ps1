<#
.SYNOPSIS
    Returns tool names from tools.yml in dependency-safe install order.
.DESCRIPTION
    Performs a topological sort based on DependsOn fields. Tools with no
    dependencies come first, tools that depend on others come after their
    dependencies. Throws on circular dependencies.
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
        $dependency = $allTools[$name].depends_on
        $dependencies[$name] = if ($dependency) {
            @($dependency)
        }
        else {
            @()
        }
    }

    # Kahn's algorithm — topological sort
    $order = [System.Collections.Generic.List[string]]::new()
    $noDependencies = [System.Collections.Generic.Queue[string]]::new()

    # In-degree: how many tools depend on me being installed first
    $inDegree = @{}
    foreach ($name in $dependencies.Keys) {
        $inDegree[$name] = 0
    }
    foreach ($name in $dependencies.Keys) {
        foreach ($dependencyName in $dependencies[$name]) {
            $inDegree[$dependencyName] = ($inDegree[$dependencyName] ?? 0) + 0  # ensure key exists
            $inDegree[$name]++
        }
    }

    # Wait — in-degree is wrong above. In-degree for a node = number of edges pointing TO it.
    # DependsOn means "I depend on X" = edge from X to me. So in-degree of me = count of my DependsOn.
    # Actually no: in Kahn's for install order, we want: if A depends on B, B must come first.
    # So edge is B → A (B must be installed before A). In-degree of A = number of dependencies A has.

    # Redo properly
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
