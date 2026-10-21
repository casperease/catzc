<#
---
catzc:
  immutable:
    with_body_sha: "5cc1ca1ae50a"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
    docs: "[Get-ValueChainHighlight.ps1.md](docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md)"
    cites:
      - ADR-AUTO-TEST
      - DDR-TRACK-ONETECHSTACK
      - DDR-TRACK-LITCELL
      - DDR-TRACK-VALUECHAINMAP
      - FDR-CD
      - TDR-ONETRUTH-TRUTHISQUERYABLE
---
#>

function Get-ValueChainHighlight {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainHighlight], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config drs).RuleSets.External })]
        [string[]] $Adr,

        [switch] $AsJson
    )

    $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr((Get-ValueChainMap), $Adr)
    if ($AsJson) {
        return $highlight.ToJson()
    }
    $highlight
}
