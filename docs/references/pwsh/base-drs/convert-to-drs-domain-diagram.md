# pwsh/Base.Drs/ConvertTo-DrsDomainDiagram.ps1

Draws the DRS domain dependency edges as PlantUML, Mermaid or a Markdown table, so the domain graph reads like the module graph.

## help

### synopsis

Renders DRS domain dependency edges to PlantUML, Mermaid, or a Markdown table.

### description

Serializes the edges from Get-DrsDomainEdges to the format chosen by -As — the DRS-domain counterpart of ConvertTo-ModuleDependencyDiagram,
so the domain DAG (which the ASM/flow reasoning depends on) is drawn the same way the module graph is:

- Puml — a `@startuml … @enduml` graph (a dashed arrow per declared edge).
- Mermaid — a `flowchart LR` graph for inline rendering in Markdown.
- Markdown — a `| From | To |` table.

Each domain's `role` (from Get-Config -Config drs) annotates its node, so a reader sees which domains are axioms / architecture /
implementation / reference at a glance.

### parameter `Edge`

The edges to render (pipeline), as Catzc.Base.Drs.DrsDomainEdge. Produced by Get-DrsDomainEdges.

### parameter `As`

Output format: Puml | Mermaid | Markdown. Defaults to Puml.

### example 1

```powershell
Get-DrsDomainEdges | ConvertTo-DrsDomainDiagram -As Mermaid
```
