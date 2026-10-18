# automation/Catzc.Base.ModuleSystem/ConvertTo-ModuleDependencyDiagram.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders module dependency edges to JSON, YAML, Markdown, or PlantUML.

### description

Serializes ModuleDependencyEdge objects (from Get-ModuleDependencyEdges) to the format chosen by -As:

- Puml — a `@startuml … @enduml` graph for visualization (a solid arrow per actual edge, labelled with the call count; a dashed arrow per
  declared/allowed edge).
- Markdown — a `| From | To | Kind | Calls |` table.
- Json — the edge objects as JSON.
- Yaml — the edges as a YAML sequence of `from/to/kind/call_count` maps.

The format is a typed parameter (ModuleDependencyFormat), so `-As <TAB>` validates and tab-completes.

### parameter `Edge`

The edges to render (pipeline). Produced by Get-ModuleDependencyEdges.

### parameter `As`

Output format: Json | Yaml | Markdown | Puml. Defaults to Puml.

### example 1

```powershell
Get-ModuleDependencyEdges | ConvertTo-ModuleDependencyDiagram -As Puml
```

### example 2

```powershell
Get-ModuleDependencyEdges -Declared | ConvertTo-ModuleDependencyDiagram -As Markdown
```
