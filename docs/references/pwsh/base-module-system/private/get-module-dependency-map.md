# pwsh/Base.ModuleSystem/private/Get-ModuleDependencyMap.ps1

Builds the declared module-to-dependency-set map from `dependencies.yml`, the edges of the declared graph. `Get-ModuleOrder` (topological
order) and `Get-ModuleDependencyClosure` (subset closure) share it.

## help

### synopsis

Builds the declared module -> dependency-set map from configs/dependencies.yml (the edges of the declared graph), shared by Get-ModuleOrder
(topological order) and Get-ModuleDependencyClosure (subset closure).

### description

Returns a hashtable: module name -> `[HashSet[string]]` of the modules it is declared to depend on. Edges:

1. Group-internal layering — each group's member -> the members it may depend on.
2. Per-module allowed deps — a specific-module target is a direct edge; a GROUP target expands to every member of that group, EXCEPT when
   the module is itself a member of that group (its intra-group order is governed by step 1; expanding would wrongly couple it to siblings
   that depend back on it).

Only modules in -Module are kept as keys/targets, so the map is closed over the requested set.

### parameter `Module`

The module set to build the map over. Defaults to the modules of the code track (Get-CatzcModule).

### example 1

```powershell
$dependencyMap = Get-ModuleDependencyMap
$dependencyMap['Catzc.Azure.Templates']   # -> the modules it depends on
```

## The loop variable

The loop variable is `$moduleName`, never `$module`. Variable names are case-insensitive, so `$module` would be the typed
`[string[]] $Module` parameter's own variable, whose type constraint persists on it and would coerce each scalar element back into a
one-element array.
