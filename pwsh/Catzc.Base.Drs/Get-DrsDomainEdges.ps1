<#
---
catzc:
  immutable:
    with_body_sha: "70a334194e27"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1
    docs: "[Get-DrsDomainEdges.ps1.md](../../docs/references/pwsh/catzc-base-drs/Get-DrsDomainEdges.ps1.md)"
---
#>

function Get-DrsDomainEdges {
    [OutputType([Catzc.Base.Drs.DrsDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config drs).Edges)
}
