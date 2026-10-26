# pwsh/Base.ModuleSystem/private/Get-ModuleDependencyClosure.ps1

Expands a set of seed modules to their transitive declared-dependency closure, so copying the result yields a loadable subset.
`Get-ModuleProfile` uses it.

## help

### synopsis

Returns the transitive declared-dependency closure of a set of modules — the seeds plus every module they depend on (directly or
indirectly), per configs/dependencies.yml.

### description

Breadth-first over the declared dependency map (Get-ModuleDependencyMap). The declared graph is a superset of the real code edges
(Test-ModuleDependency enforces actual ⊆ declared), so the closure is guaranteed to contain every module the seeds need to load — copying it
(Get-ModuleProfile → Copy-CatzcModule) yields a loadable subset. A group dependency was already expanded to its members when the map was
built. Result is ordinal-sorted for determinism. Seeds that are not on-disk modules contribute themselves but no edges.

### parameter `Module`

The seed module names to close over.

### example 1

```powershell
Get-ModuleDependencyClosure -Module Catzc.Azure.Templates
# -> Catzc.Azure.Templates plus its Base/Tooling/Catzc.Azure dependencies
```
