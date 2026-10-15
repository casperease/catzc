---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/ConvertTo-AdrDomainDiagram.ps1.md
    kind: comment-page
    body_sha: "48fa3c3e536a"
---

# automation/Catzc.Base.Docs/ConvertTo-AdrDomainDiagram.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Serializes the edges from Get-AdrDomainEdges to the format chosen by -As — the ADR-domain counterpart of
ConvertTo-ModuleDependencyDiagram, so the domain DAG (which the ASM/flow reasoning depends on) is drawn the
same way the module graph is:

  - Puml     — a `@startuml … @enduml` graph (a dashed arrow per declared edge).
  - Mermaid  — a `flowchart LR` graph for inline rendering in Markdown.
  - Markdown — a `| From | To |` table.

Each domain's `role` (from Get-Config -Config adrs) annotates its node, so a reader sees which domains are
axioms / architecture / implementation / reference at a glance.
```
