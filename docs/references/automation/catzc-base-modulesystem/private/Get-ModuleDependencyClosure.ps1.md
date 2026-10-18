# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyClosure.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the transitive declared-dependency closure of a set of modules — the seeds plus every module they
depend on (directly or indirectly), per configs/dependencies.yml.

### description

Breadth-first over the declared dependency map (Get-ModuleDependencyMap). The declared graph is a superset
of the real code edges (Test-ModuleDependency enforces actual ⊆ declared), so the closure is guaranteed
to contain every module the seeds need to load — copying it (Get-ModuleProfile → Copy-Automation) yields a
loadable subset. A group dependency was already expanded to its members when the map was built. Result is
ordinal-sorted for determinism. Seeds that are not on-disk modules contribute themselves but no edges.

### parameter Module

The seed module names to close over.

### example 1

```powershell
Get-ModuleDependencyClosure -Module Catzc.Azure.Templates
# -> Catzc.Azure.Templates plus its Base/Tooling/Catzc.Azure dependencies
```
