# catzc:
#   path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1
#   module: Catzc.Base.ModuleSystem
#   visibility: private

<#
.SYNOPSIS
    Collects conformance violations of the real code against the declared dependency graph.
.DESCRIPTION
    Function calls and cross-module C# type references are checked against one and the same group-aware allow-list.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md#comment1)
.OUTPUTS
    [string[]] One message per violation.
.EXAMPLE
    Get-ModuleDependencyViolations
#>
function Get-ModuleDependencyViolations {
    [OutputType([string[]])]
    param()

    $declared = Get-ModuleDependencyConfig
    $groups = Get-ModuleGroupConfig
    $modules = Get-AutomationModules
    $edges = Get-ModuleDependency

    $violations = [System.Collections.Generic.List[string]]::new()

    # group name -> member set; member module -> its in-group allowed list (internal DAG).
    $groupMembers = @{}
    $memberAllowed = @{}
    foreach ($group in $groups.Keys) {
        $groupMembers[$group] = @($groups[$group].Keys)
        foreach ($member in $groups[$group].Keys) {
            $memberAllowed[$member] = @($groups[$group][$member])
        }
    }

    # A source that is neither declared nor a group member is unconstrained, so callers skip it.
    # [comment:2](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md#comment2)
    $resolveAllowed = {
        param([string] $From)

        $allowed = [System.Collections.Generic.List[string]]::new()
        $constrained = $false

        if ($declared.Contains($From)) {
            $constrained = $true
            foreach ($name in @($declared[$From])) {
                if ($groupMembers.ContainsKey("$name")) {
                    $allowed.AddRange([string[]]$groupMembers["$name"])
                }
                else {
                    $allowed.Add("$name")
                }
            }
        }
        if ($memberAllowed.ContainsKey($From)) {
            $constrained = $true
            $allowed.AddRange([string[]]$memberAllowed[$From])
        }

        [PSCustomObject]@{ Constrained = $constrained; Allowed = $allowed }
    }

    # Declared modules must exist on disk (typo catch).
    foreach ($module in $declared.Keys) {
        if ($module -notin $modules) {
            $violations.Add("[UnknownModule] $module  -- declared in configuration but no such module on disk")
        }
    }

    # Group members must exist on disk too (the group is a concept, but its members are real modules).
    foreach ($group in $groups.Keys) {
        foreach ($member in $groups[$group].Keys) {
            if ($member -notin $modules) {
                $violations.Add("[UnknownModule] $member  -- declared in group '$group' but no such module on disk")
            }
        }
    }

    # Allow-list: every actual function-call edge from a constrained module must be in its resolved set.
    foreach ($edge in $edges) {
        $resolved = & $resolveAllowed $edge.From
        if (-not $resolved.Constrained) {
            continue
        }   # a source with no constraint
        if ($edge.To -notin $resolved.Allowed) {
            $funcs = $edge.Functions -join ', '
            $violations.Add("[UndeclaredDependency] $($edge.From) -> $($edge.To)  ($funcs)  -- not allowed for $($edge.From)")
        }
    }

    # C# types share one assembly, so the compiler permits cross-module references; only this check holds them back.
    # [comment:3](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md#comment3)
    $typeEdges = Get-CSharpTypeDependency
    foreach ($edge in $typeEdges) {
        $resolved = & $resolveAllowed $edge.From
        if (-not $resolved.Constrained) {
            continue
        }   # a source with no constraint
        if ($edge.To -notin $resolved.Allowed) {
            $refs = $edge.References -join ', '
            $violations.Add("[UndeclaredTypeDependency] $($edge.From) -> $($edge.To)  ($refs)  -- not allowed for $($edge.From)")
        }
    }

    $violations.ToArray()
}
