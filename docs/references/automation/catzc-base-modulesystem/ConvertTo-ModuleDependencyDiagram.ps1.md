# docs/references/automation/catzc-base-modulesystem/ConvertTo-ModuleDependencyDiagram.ps1.md

`automation/Catzc.Base.ModuleSystem/ConvertTo-ModuleDependencyDiagram.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Serializes ModuleDependencyEdge objects (from Get-ModuleDependencyEdges) to the format chosen by -As:

  - Puml     — a `@startuml … @enduml` graph for visualization (a solid arrow per actual edge,
               labelled with the call count; a dashed arrow per declared/allowed edge).
  - Markdown — a `| From | To | Kind | Calls |` table.
  - Json     — the edge objects as JSON.
  - Yaml     — the edges as a YAML sequence of `from/to/kind/call_count` maps.

The format is a typed parameter (ModuleDependencyFormat), so `-As <TAB>` validates and tab-completes.
```
