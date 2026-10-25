<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/Get-DrsDomainEdges.ps1.md"
  warning: "Generated Header"
---
#>

function Get-DrsDomainEdges {
    [OutputType([Catzc.Base.Drs.DrsDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config drs).Edges)
}
