---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-AdrDomainEdges.ps1.md
    kind: comment-page
    body_sha: "3002f39aed6f"
---

# automation/Catzc.Base.Docs/Get-AdrDomainEdges.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the Edges of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the
type): for each domain, one Catzc.Base.Docs.AdrDomainEdge per entry in its DependsOn, in declaration order.
Mirrors the module dependency graph (Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies;
pipe the result to ConvertTo-AdrDomainDiagram. The edge type is Docs-local, so this module takes no
dependency on Catzc.Base.ModuleSystem.
```
