---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md
    kind: comment-page
    body_sha: "06bddf378df8"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/Get-ModuleTestOrder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the module -> dependencies map from the declared graph: each group's internal member -> member
layering, plus each module's allowed dependencies (a group target expands to all the group's members).
Then topologically sorts (Kahn's algorithm) with an ordinal-alphabetical tie-break for a stable order.

Every on-disk module (Get-AutomationModules) appears exactly once; a module with no declared dependencies
sorts among the roots. Throws on a cycle (which the DependenciesConfig type already prevents at load).

Test-Automation uses this to run module tests foundation-first, so a broken base module's failures
surface before the dependents that cascade from it.
```

## comment:2

Above `$modules = [string[]] @(Get-AutomationModules)`.

```text
Ordinal-sort the module set ourselves (not relying on the caller's order) so the topological sort's
tie-break among same-layer modules is deterministic and alphabetical.
```

## comment:3

Above `$dependencyMap = Get-ModuleDependencyMap -Module $modules`.

```text
module -> the set of modules it must run AFTER — the declared-graph edges (group-internal layering plus
each module's allowed deps, groups expanded to members). Shared with Get-ModuleDependencyClosure.
```

## comment:4

Above `$inDegree = @{}`.

```text
Kahn's topological sort. $modules is ordinal-sorted, so seeding/relaxing in that order keeps the
result deterministic and alphabetical among otherwise-equal (same-layer) modules.
```
