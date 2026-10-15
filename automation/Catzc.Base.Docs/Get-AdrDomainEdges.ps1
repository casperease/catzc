<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-AdrDomainEdges.ps1
    kind: public-function
    module: Catzc.Base.Docs
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
.DESCRIPTION
    The edge type is Docs-local, so this module takes no dependency on the ModuleSystem module.
.OUTPUTS
    [Catzc.Base.Docs.AdrDomainEdge[]] { From; To } — From depends on To.
#>
function Get-AdrDomainEdges {
    [OutputType([Catzc.Base.Docs.AdrDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
