# pwsh/Base.Drs/Get-DrsDomainEdges.ps1

Returns the ADR domain dependency graph as From and To edges, one per declared `depends_on` link.

## help

### synopsis

The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.

### description

Returns the Edges of the typed ADR registry (Get-Config -Config drs, an DrsConfig validated acyclic by the type): for each domain, one
Catzc.Base.Drs.DrsDomainEdge per entry in its DependsOn, in declaration order. Mirrors the module dependency graph
(Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies; pipe the result to ConvertTo-DrsDomainDiagram. The edge type is
Docs-local, so this module takes no dependency on Catzc.Base.ModuleSystem.

### outputs

`[Catzc.Base.Drs.DrsDomainEdge[]]` { From; To } — From depends on To.
