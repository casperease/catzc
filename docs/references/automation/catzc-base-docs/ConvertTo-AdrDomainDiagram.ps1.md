# automation/Catzc.Base.Docs/ConvertTo-AdrDomainDiagram.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders ADR domain dependency edges to PlantUML, Mermaid, or a Markdown table.

### description

Serializes the edges from Get-AdrDomainEdges to the format chosen by -As — the ADR-domain counterpart of
ConvertTo-ModuleDependencyDiagram, so the domain DAG (which the ASM/flow reasoning depends on) is drawn the
same way the module graph is:

- Puml     — a `@startuml … @enduml` graph (a dashed arrow per declared edge).
- Mermaid  — a `flowchart LR` graph for inline rendering in Markdown.
- Markdown — a `| From | To |` table.

Each domain's `role` (from Get-Config -Config adrs) annotates its node, so a reader sees which domains are
axioms / architecture / implementation / reference at a glance.

### parameter Edge

The edges to render (pipeline), as Catzc.Base.Docs.AdrDomainEdge. Produced by Get-AdrDomainEdges.

### parameter As

Output format: Puml | Mermaid | Markdown. Defaults to Puml.

### example 1

```powershell
Get-AdrDomainEdges | ConvertTo-AdrDomainDiagram -As Mermaid
```
