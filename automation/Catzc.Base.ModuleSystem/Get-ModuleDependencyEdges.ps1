<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleDependencyEdges.ps1
    name: get-module-dependency-edges
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
    test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyEdges.Tests.ps1
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
