---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md
    kind: comment-page
    body_sha: "78c8833643d4"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns a hashtable: module name -> [HashSet[string]] of the modules it is declared to depend on. Edges:

  1. Group-internal layering — each group's member -> the members it may depend on.
  2. Per-module allowed deps — a specific-module target is a direct edge; a GROUP target expands to every
     member of that group, EXCEPT when the module is itself a member of that group (its intra-group order
     is governed by step 1; expanding would wrongly couple it to siblings that depend back on it).

Only modules in -Module are kept as keys/targets, so the map is closed over the requested set.
```

## comment:2

Above `$dependencyMap = @{}`.

```text
module -> the set of modules it depends on. The loop variable must NOT be named $module: it would
collide (names are case-insensitive) with the [string[]] $Module parameter, whose type constraint
persists on the shared variable and would coerce each scalar element back into a 1-element array.
```

## comment:3

Above `foreach ($moduleName in $allowed.Keys) {`.

```text
2) Per-module allowed deps. A specific-module target is a direct edge. A GROUP target adds every member
   of that group — EXCEPT when the module is itself a member of that group (see .DESCRIPTION).
```
