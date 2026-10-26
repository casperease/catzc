# pwsh/Base.ModuleSystem/Get-ModuleDependencyEdges.ps1

Returns the module dependency graph as typed [ModuleDependencyEdge](types/module-dependency-edge.md) objects, either the actual edges of
the code or, with `-Declared`, the allowed edges of `dependencies.yml`. `ConvertTo-ModuleDependencyDiagram` renders them.

## help

### synopsis

Returns the module dependency graph as typed ModuleDependencyEdge objects.

### description

By default returns the ACTUAL cross-module call edges derived from the code (via Get-ModuleDependency) — each carrying its call count and
the calling functions. With -Declared, returns the ALLOWED edges from configs/dependencies.yml instead: each module's permitted dependencies
(a target may be a GROUP name), plus each group's internal member->member layering.

Pipe the result to ConvertTo-ModuleDependencyDiagram to render JSON / YAML / Markdown / PlantUML.

### parameter `Declared`

Return the declared (allowed) graph from dependencies.yml instead of the actual code-derived graph.

### example 1

```powershell
Get-ModuleDependencyEdges
```

### example 2

```powershell
Get-ModuleDependencyEdges -Declared | ConvertTo-ModuleDependencyDiagram -As Puml
```
