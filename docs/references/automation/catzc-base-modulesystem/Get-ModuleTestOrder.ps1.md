---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md
    kind: comment-page
    body_sha: a56d74694b03
---

# automation/Catzc.Base.ModuleSystem/Get-ModuleTestOrder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$modules = [string[]] @(Get-AutomationModules)`.

```text
Ordinal-sort the module set ourselves (not relying on the caller's order) so the topological sort's
tie-break among same-layer modules is deterministic and alphabetical.
```

## comment:6

Above `$dependencyMap = Get-ModuleDependencyMap -Module $modules`.

```text
module -> the set of modules it must run AFTER — the declared-graph edges (group-internal layering plus
each module's allowed deps, groups expanded to members). Shared with Get-ModuleDependencyClosure.
```

## comment:7

Above `$inDegree = @{}`.

```text
Kahn's topological sort. $modules is ordinal-sorted, so seeding/relaxing in that order keeps the
result deterministic and alphabetical among otherwise-equal (same-layer) modules.
```
