---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md
    kind: comment-page
    body_sha: "8b7faa80dd9e"
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$dependencyMap = @{}`.

```text
module -> the set of modules it depends on. The loop variable must NOT be named $module: it would
collide (names are case-insensitive) with the [string[]] $Module parameter, whose type constraint
persists on the shared variable and would coerce each scalar element back into a 1-element array.
```

## comment:5

Above `foreach ($moduleName in $allowed.Keys) {`.

```text
2) Per-module allowed deps. A specific-module target is a direct edge. A GROUP target adds every member
   of that group — EXCEPT when the module is itself a member of that group (see .DESCRIPTION).
```
