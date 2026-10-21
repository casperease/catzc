<#
---
catzc:
  immutable:
    with_body_sha: bf93a71d77b7
  edges:
    docs: "[Get-ModuleDependencyViolations.ps1.md](docs/references/pwsh/catzc-base-module-system/private/Get-ModuleDependencyViolations.ps1.md)"
---
#>

function Get-ModuleDependencyViolations {
    [OutputType([string[]])]
    param()

    $declared = Get-ModuleDependencyConfig
    $groups = Get-ModuleGroupConfig
    $modules = (Get-CatzcModule -EngineTrack).name
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
