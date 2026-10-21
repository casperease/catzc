<#
---
catzc:
  immutable:
    with_body_sha: "6cda7abcbfc7"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
    docs: "[Get-ValueChainMap.ps1.md](../../docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md)"
    cites:
      - DDR-TRACK-VALUECHAINSTACK
      - DDR-TRACK-VALUECHAINCONCERN
      - DDR-TRACK-VALUECHAINMAP
      - TDR-ONETRUTH-TRUTHISQUERYABLE
---
#>

function Get-ValueChainMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainMap], [string])]
    param(
        [switch] $AsJson
    )

    $map = [Catzc.Base.Maps.ValueChainMap]::Build([Catzc.Base.Drs.DrsConfig]::Stacks, [Catzc.Base.Drs.DrsConfig]::Concerns,
        (ConvertTo-BclValue @(Get-DrsRuleSet)))
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
