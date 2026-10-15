# catzc:
#   path: automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
#   module: Catzc.Base.Maps
#   visibility: public

<#
.SYNOPSIS
    Returns the value-chain map cells that ADR codes light.
.DESCRIPTION
    A rule sits where its ADR sits, so one rule lights the same cells as its whole ADR, not the files that cite it.
    [ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
    [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)
    [comment:1](/docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md#comment1)
.PARAMETER Adr
    The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.
.PARAMETER AsJson
    JSON carries the request and the lit cells, so a tool reads the highlight without PowerShell.
    [ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
    [comment:2](/docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md#comment2)
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
