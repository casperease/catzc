<#
---
catzc:
  immutable:
    with_body_sha: a4a5b3162a4b
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyEdges.Tests.ps1
    docs: "[Get-ModuleDependencyEdges.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Get-ModuleDependencyEdges.ps1.md)"
---
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
