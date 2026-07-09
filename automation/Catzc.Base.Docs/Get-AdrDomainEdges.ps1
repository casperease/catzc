<#
.SYNOPSIS
    The ADR domain dependency graph as From/To edges — one per declared `depends_on` link.
.DESCRIPTION
    Reads the typed ADR registry (Get-Config -Config adrs, an AdrsConfig validated acyclic by the type) and
    returns its domain DAG as edges: for each domain, one edge per entry in its DependsOn. Mirrors the module
    dependency graph (Get-ModuleDependencyEdges) so the same edge-list → diagram shape applies; pipe the result
    to ConvertTo-AdrDomainDiagram. Kept Docs-local (a plain {From, To} record) so this module takes no
    dependency on Catzc.Base.ModuleSystem.
.OUTPUTS
    [pscustomobject[]] { From; To } — From depends on To.
#>
function Get-AdrDomainEdges {
    [OutputType([object[]])]
    [CmdletBinding()]
    param()

    $ret = foreach ($domain in (Get-Config -Config adrs).Domains) {
        foreach ($target in $domain.DependsOn) {
            [pscustomobject]@{ From = $domain.Name; To = $target }
        }
    }
    @($ret)
}
