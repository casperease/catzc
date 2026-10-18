---
catzc:
  immutable:
    with_body_sha: "9bd38d6287bb"
    repo_status: locked
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyMap.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/private
    name: get-module-dependency-map-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the declared module -> dependency-set map from configs/dependencies.yml (the edges of the declared
graph), shared by Get-ModuleOrder (topological order) and Get-ModuleDependencyClosure (subset closure).

### description

Returns a hashtable: module name -> `[HashSet[string]]` of the modules it is declared to depend on. Edges:

1. Group-internal layering — each group's member -> the members it may depend on.
2. Per-module allowed deps — a specific-module target is a direct edge; a GROUP target expands to every
   member of that group, EXCEPT when the module is itself a member of that group (its intra-group order
   is governed by step 1; expanding would wrongly couple it to siblings that depend back on it).

Only modules in -Module are kept as keys/targets, so the map is closed over the requested set.

### parameter Module

The module set to build the map over. Defaults to the modules of the code track (Get-CatzcModule).

### example 1

```powershell
$dependencyMap = Get-ModuleDependencyMap
$dependencyMap['Catzc.Azure.Templates']   # -> the modules it depends on
```

## comment:1

Above `$dependencyMap = @{}`, written with `#`.

```text
module -> the set of modules it depends on. The loop variable must NOT be named $module: it would
collide (names are case-insensitive) with the [string[]] $Module parameter, whose type constraint
persists on the shared variable and would coerce each scalar element back into a 1-element array.
```

## comment:2

Above `foreach ($moduleName in $allowed.Keys) {`, written with `#`.

```text
2) Per-module allowed deps. A specific-module target is a direct edge. A GROUP target adds every member
   of that group — EXCEPT when the module is itself a member of that group (see .DESCRIPTION).
```
