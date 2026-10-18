<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/Get-AdrDomainEdges.ps1
    name: get-adr-domain-edges
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
---
#>

function Get-AdrDomainEdges {
    [OutputType([Catzc.Base.Docs.AdrDomainEdge[]])]
    [CmdletBinding()]
    param()

    @((Get-Config -Config adrs).Edges)
}
