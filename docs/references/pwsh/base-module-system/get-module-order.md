# pwsh/Base.ModuleSystem/Get-ModuleOrder.ps1

The one function that sorts the declared module graph into foundation-first order, so a module comes after every module it may depend on.
Every command that needs modules in dependency order calls it and never sorts again.

## help

### synopsis

Returns module names in foundation-first order — a topological sort of the declared dependency graph (configs/dependencies.yml), so a module
is ordered after every module it may depend on.

### description

The one function that sorts the graph
([ADR-AUTO-MODULE-TOPOLOGICALORDER](../../../drs/automation/module-model.md#rule-adr-auto-module-topologicalorder)); every command that
needs modules in dependency order calls it and never sorts again.

Builds the module -> dependencies map from the declared graph: each group's internal member -> member layering, plus each module's allowed
dependencies (a group target expands to all the group's members). Then topologically sorts (Kahn's algorithm) with an ordinal-alphabetical
tie-break for a stable order.

Every module in -Module appears exactly once; a module with no declared dependencies sorts among the roots. Throws on a cycle (which the
DependenciesConfig type already prevents at load).

Test-Automation uses this to run module tests foundation-first, so a broken base module's failures surface before the dependents that
cascade from it.

### parameter `Module`

The module names to order. Defaults to the modules of the code track (Get-CatzcModule).

### example 1

```powershell
Get-ModuleOrder
# -> Catzc.Base.Asserts, Catzc.Base.Environment, Catzc.Base.Objects, Catzc.Base.Repository, ...
```
