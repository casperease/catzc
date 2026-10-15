<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
    kind: function
    module: Catzc.Base.Maps
    visibility: public
    adrs:
      - ADR-AUTO-TEST
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#3
      - ADR-FLOW-CD
      - ADR-THES-ONETRUTH#3
---
#>

<#
.SYNOPSIS
    Returns the value-chain map cells that ADR codes light.
.DESCRIPTION
    A rule sits where its ADR sits, so one rule lights the same cells as its whole ADR, not the files that cite it.
.PARAMETER Adr
    The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.
.PARAMETER AsJson
    JSON carries the request and the lit cells, so a tool reads the highlight without PowerShell.
.OUTPUTS
    [Catzc.Base.Maps.ValueChainHighlight], or [string] with -AsJson.
.EXAMPLE
    (Get-ValueChainHighlight ADR-FLOW-CD).Cells
.EXAMPLE
    Get-ValueChainHighlight -Adr 'ADR-DSGN-TRACK#3', 'ADR-AUTO-TEST' -AsJson
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
