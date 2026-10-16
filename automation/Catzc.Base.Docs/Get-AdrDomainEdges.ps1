<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-AdrDomainEdges.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
  config:
    synopsis: The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
    description: |-
      Returns the Edges of the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the
      type): for each domain, one Catzc.Base.Docs.AdrDomainEdge per entry in its DependsOn, in declaration order.
      Mirrors the module dependency graph (Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies;
      pipe the result to ConvertTo-AdrDomainDiagram. The edge type is Docs-local, so this module takes no
      dependency on Catzc.Base.ModuleSystem.
    outputs: '[Catzc.Base.Docs.AdrDomainEdge[]] { From; To } — From depends on To.'
---
#>

function Get-AdrDomainEdges {
    [OutputType([Catzc.Base.Docs.AdrDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
