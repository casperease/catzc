<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
    name: get-value-chain-map
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#{14-16}
      - ADR-THES-ONETRUTH#3
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
