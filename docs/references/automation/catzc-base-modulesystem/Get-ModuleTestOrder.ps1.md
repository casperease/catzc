---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-ModuleTestOrder.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a1f371bece65
---

# automation/Catzc.Base.ModuleSystem/Get-ModuleTestOrder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$modules = [string[]] @(Get-AutomationModules)`, written with `#`.

```text
Ordinal-sort the module set ourselves (not relying on the caller's order) so the topological sort's
tie-break among same-layer modules is deterministic and alphabetical.
```

## comment:2

Above `$dependencyMap = Get-ModuleDependencyMap -Module $modules`, written with `#`.

```text
module -> the set of modules it must run AFTER — the declared-graph edges (group-internal layering plus
each module's allowed deps, groups expanded to members). Shared with Get-ModuleDependencyClosure.
```

## comment:3

Above `$inDegree = @{}`, written with `#`.

```text
Kahn's topological sort. $modules is ordinal-sorted, so seeding/relaxing in that order keeps the
result deterministic and alphabetical among otherwise-equal (same-layer) modules.
```
