<#
---
catzc:
  immutable:
    with_body_sha: "0f6c944afb3c"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1
    docs: "[Get-DrsDomainEdges.ps1.md](docs/references/pwsh/catzc-base-docs/Get-DrsDomainEdges.ps1.md)"
---
#>

function Get-DrsDomainEdges {
    [OutputType([Catzc.Base.Drs.DrsDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config drs).Edges)
}
