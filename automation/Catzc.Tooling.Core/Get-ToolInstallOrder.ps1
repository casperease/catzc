<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md
      test: automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
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
