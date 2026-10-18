<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
    name: get-value-chain-highlight
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
    test: automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
    cites:
      - ADR-AUTO-TEST
      - ADR-DSGN-TRACK#{3,12,16}
      - ADR-FLOW-CD
      - ADR-THES-ONETRUTH#3
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
