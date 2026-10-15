<#
.SYNOPSIS
    The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
.DESCRIPTION
    Returns the Edges of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the...
    [comment:1](/docs/references/automation/catzc-base-docs/Get-AdrDomainEdges.ps1.md#comment1)
.OUTPUTS
    [Catzc.Base.Docs.AdrDomainEdge[]] { From; To } — From depends on To.
#>
function Get-AdrDomainEdges {
    [OutputType([object[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
