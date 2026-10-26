# pwsh/Base.ModuleSystem/types/ModuleDependencyEdge.cs

A single module-to-module dependency edge, typed for rendering to JSON, YAML, Markdown and PlantUML. `Get-ModuleDependencyEdges` produces
them and `ConvertTo-ModuleDependencyDiagram` renders them. The properties are PascalCase because this is a result shape, not a YAML mirror.

## Kind

`Kind` is `actual` or `declared` (an empty kind becomes `actual`):

- **actual** — a real cross-module call edge from `Get-ModuleDependency`. `CallCount` and `Functions` are populated, the latter as
  `Caller->Target:line` entries.
- **declared** — an allowed edge from `dependencies.yml`. `CallCount` is 0 and `Functions` is empty. `To` may be a group name rather than a
  module.

`From` and `To` are required.
