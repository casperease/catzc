<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Get-AdrDomainEdges.ps1
    name: get-adr-domain-edges
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
