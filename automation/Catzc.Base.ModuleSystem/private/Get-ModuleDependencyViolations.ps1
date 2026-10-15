<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1
    kind: automation-function
    module: Catzc.Base.ModuleSystem
    visibility: private
  config:
    synopsis: Collects conformance violations of the real code against the declared dependency graph.
    description: |-
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

      Returns one message per violation, each led by its kind ('[UndeclaredDependency] A -> C ...'); empty when
      the code conforms. This is the query behind the Test-ModuleDependency quality gate.
    outputs: '[string[]] One message per violation.'
    examples:
      - Get-ModuleDependencyViolations
---
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

    # Resolves a source module to { Constrained; Allowed }.
    # [comment:4](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md#comment4)
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

    # Same allow-list, applied to cross-module C# type references (one combined types assembly, so the compiler...
    # [comment:5](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md#comment5)
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
