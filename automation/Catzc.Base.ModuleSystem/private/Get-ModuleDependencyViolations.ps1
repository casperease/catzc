<#
.SYNOPSIS
    Collects conformance violations of the real code against the declared dependency graph.
.DESCRIPTION
    Compares the actual module-to-module edges against the declared allow-list
    (Get-ModuleDependencyConfig + Get-ModuleGroupConfig). Edges come from TWO sources, both governed
    by the same allow-list: PowerShell function calls (Get-ModuleDependency) and cross-module C# type
    references (Get-CSharpTypeDependency).

    Allow-list resolution is GROUP-AWARE. A source module is constrained if it is a declared module
    (top-level 'modules' key) or a member of a declared group; otherwise it is unconstrained and skipped.
    Its allowed target set is:

    - if a declared module: each name in its declared list, with group names expanded to their members
      (so pinning a group permits an edge to any member; naming a module is the tight form), plus plain
      module names as-is.
    - if a group member: the members listed for it in that group's internal DAG (the layering contract).

    An actual edge whose target is not in the resolved allowed set is an UndeclaredDependency (function)
    or UndeclaredTypeDependency (C# type). A declared module — or a group member — that does not exist on
    disk is an UnknownModule (typo catch). Group names themselves are concepts and are not checked on disk.

    Returns a list of violation objects { Kind, Message }; empty when the code conforms.
    This is the shared collector behind Test-ModuleDependency and Assert-ModuleDependency.
.EXAMPLE
    Get-ModuleDependencyViolations
#>
function Get-ModuleDependencyViolations {
    param()

    $declared = Get-ModuleDependencyConfig
    $groups = Get-ModuleGroupConfig
    $modules = Get-AutomationModules
    $edges = Get-ModuleDependency

    $violations = [System.Collections.Generic.List[PSObject]]::new()

    # group name -> member set; member module -> its in-group allowed list (internal DAG).
    $groupMembers = @{}
    $memberAllowed = @{}
    foreach ($group in $groups.Keys) {
        $groupMembers[$group] = @($groups[$group].Keys)
        foreach ($member in $groups[$group].Keys) {
            $memberAllowed[$member] = @($groups[$group][$member])
        }
    }

    # Resolves a source module to { Constrained; Allowed }. An unconstrained source (not a declared
    # module and not a group member) is skipped by callers regardless of its (empty) Allowed set.
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
            $violations.Add([PSCustomObject]@{
                    Kind    = 'UnknownModule'
                    Message = "[UnknownModule] $module  -- declared in configuration but no such module on disk"
                })
        }
    }

    # Group members must exist on disk too (the group is a concept, but its members are real modules).
    foreach ($group in $groups.Keys) {
        foreach ($member in $groups[$group].Keys) {
            if ($member -notin $modules) {
                $violations.Add([PSCustomObject]@{
                        Kind    = 'UnknownModule'
                        Message = "[UnknownModule] $member  -- declared in group '$group' but no such module on disk"
                    })
            }
        }
    }

    # Allow-list: every actual function-call edge from a constrained module must be in its resolved set.
    foreach ($edge in $edges) {
        $resolved = & $resolveAllowed $edge.From
        if (-not $resolved.Constrained) {
            continue
        }   # unconstrained source
        if ($edge.To -notin $resolved.Allowed) {
            $funcs = $edge.Functions -join ', '
            $violations.Add([PSCustomObject]@{
                    Kind    = 'UndeclaredDependency'
                    Message = "[UndeclaredDependency] $($edge.From) -> $($edge.To)  ($funcs)  -- not allowed for $($edge.From)"
                })
        }
    }

    # Same allow-list, applied to cross-module C# type references (one combined types assembly, so the
    # compiler permits them — see Get-CSharpTypeDependency).
    $typeEdges = Get-CSharpTypeDependency
    foreach ($edge in $typeEdges) {
        $resolved = & $resolveAllowed $edge.From
        if (-not $resolved.Constrained) {
            continue
        }   # unconstrained source
        if ($edge.To -notin $resolved.Allowed) {
            $refs = $edge.References -join ', '
            $violations.Add([PSCustomObject]@{
                    Kind    = 'UndeclaredTypeDependency'
                    Message = "[UndeclaredTypeDependency] $($edge.From) -> $($edge.To)  ($refs)  -- not allowed for $($edge.From)"
                })
        }
    }

    $violations
}
