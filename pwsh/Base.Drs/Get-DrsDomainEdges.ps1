function Get-DrsDomainEdges {
    [OutputType([Catzc.Base.Drs.DrsDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config drs).Edges)
}
