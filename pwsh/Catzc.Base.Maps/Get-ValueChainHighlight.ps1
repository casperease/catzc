<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
    name: get-value-chain-highlight
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
    test: pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
    docs: "[Get-ValueChainHighlight.ps1.md](docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md)"
    cites:
      - ADR-AUTO-TEST
      - ADR-DSGN-TRACK-ONETECHSTACK
      - ADR-DSGN-TRACK-LITCELL
      - ADR-DSGN-TRACK-VALUECHAINMAP
      - ADR-FLOW-CD
      - ADR-THES-ONETRUTH-TRUTHISQUERYABLE
---
#>

function Get-ValueChainHighlight {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainHighlight], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config adrs).RuleSets.External })]
        [string[]] $Adr,

        [switch] $AsJson
    )

    $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr((Get-ValueChainMap), $Adr)
    if ($AsJson) {
        return $highlight.ToJson()
    }
    $highlight
}
