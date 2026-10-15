<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleDependencyEdges.ps1
    kind: public-function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the module dependency graph as typed ModuleDependencyEdge objects.
.DESCRIPTION
    A declared edge's target may be a group name, not only a module, so one edge can allow several modules.
.PARAMETER Declared
    Return the declared (allowed) graph from dependencies.yml instead of the actual code-derived graph.
.EXAMPLE
    Get-ModuleDependencyEdges
.EXAMPLE
    Get-ModuleDependencyEdges -Declared | ConvertTo-ModuleDependencyDiagram -As Puml
#>
function Get-ModuleDependencyEdges {
    [OutputType([Catzc.Base.ModuleSystem.ModuleDependencyEdge[]])]
    param(
        [switch] $Declared
    )

    $edges = [System.Collections.Generic.List[Catzc.Base.ModuleSystem.ModuleDependencyEdge]]::new()

    if ($Declared) {
        # Group-internal layering: each group's member -> the members it may depend on.
        $groups = Get-ModuleGroupConfig
        foreach ($group in $groups.Keys) {
            $members = $groups[$group]
            foreach ($member in $members.Keys) {
                foreach ($dependency in @($members[$member])) {
                    $edges.Add([Catzc.Base.ModuleSystem.ModuleDependencyEdge]::new($member, $dependency, 'declared', 0, @()))
                }
            }
        }

        # Per-module allowed dependencies (a target may be a group name or a specific module).
        $modules = Get-ModuleDependencyConfig
        foreach ($module in $modules.Keys) {
            foreach ($dependency in @($modules[$module])) {
                $edges.Add([Catzc.Base.ModuleSystem.ModuleDependencyEdge]::new($module, $dependency, 'declared', 0, @()))
            }
        }
    }
    else {
        foreach ($dependency in @(Get-ModuleDependency)) {
            $edges.Add([Catzc.Base.ModuleSystem.ModuleDependencyEdge]::new(
                    $dependency.From, $dependency.To, 'actual', [int]$dependency.CallCount, @($dependency.Functions)))
        }
    }

    $edges.ToArray()
}
