# catzc:
#   path: automation/Catzc.Base.Docs/Get-AdrDomainEdges.ps1
#   module: Catzc.Base.Docs
#   visibility: public

<#
.SYNOPSIS
    The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
.DESCRIPTION
    The edge type is Docs-local, so this module takes no dependency on the ModuleSystem module.
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
