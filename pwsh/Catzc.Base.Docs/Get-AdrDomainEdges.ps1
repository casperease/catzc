<#
---
catzc:
  immutable:
    with_body_sha: "0f6c944afb3c"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
    docs: "[Get-AdrDomainEdges.ps1.md](docs/references/pwsh/catzc-base-docs/Get-AdrDomainEdges.ps1.md)"
---
#>

function Get-AdrDomainEdges {
    [OutputType([Catzc.Base.Docs.AdrDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
