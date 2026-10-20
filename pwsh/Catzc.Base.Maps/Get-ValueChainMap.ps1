<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/Get-ValueChainMap.ps1
    name: get-value-chain-map
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
    docs: "[Get-ValueChainMap.ps1.md](docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-VALUECHAINSTACK
      - ADR-DSGN-TRACK-VALUECHAINCONCERN
      - ADR-DSGN-TRACK-VALUECHAINMAP
      - ADR-THES-ONETRUTH-TRUTHISQUERYABLE
---
#>

function Get-ValueChainMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainMap], [string])]
    param(
        [switch] $AsJson
    )

    $map = [Catzc.Base.Maps.ValueChainMap]::Build([Catzc.Base.Docs.AdrsConfig]::Stacks, [Catzc.Base.Docs.AdrsConfig]::Concerns,
        @(Get-AdrRuleSet))
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
