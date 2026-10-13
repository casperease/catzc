<#
.SYNOPSIS
    The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
.DESCRIPTION
    Returns the Edges of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the
    type): for each domain, one Catzc.Base.Docs.AdrDomainEdge per entry in its DependsOn, in declaration order.
    Mirrors the module dependency graph (Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies;
    pipe the result to ConvertTo-AdrDomainDiagram. The edge type is Docs-local, so this module takes no
    dependency on Catzc.Base.ModuleSystem.
.OUTPUTS
    [Catzc.Base.Docs.AdrDomainEdge[]] { From; To } — From depends on To.
#>
function Get-AdrDomainEdges {
    [OutputType([object[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
