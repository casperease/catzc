# pwsh/Catzc.Base.Docs/Get-AdrDomainEdges.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.

### description

Returns the Edges of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the type): for each domain, one
Catzc.Base.Docs.AdrDomainEdge per entry in its DependsOn, in declaration order. Mirrors the module dependency graph
(Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies; pipe the result to ConvertTo-AdrDomainDiagram. The edge type is
Docs-local, so this module takes no dependency on Catzc.Base.ModuleSystem.

### outputs

`[Catzc.Base.Docs.AdrDomainEdge[]]` { From; To } — From depends on To.
