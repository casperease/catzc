<#
.SYNOPSIS
    Returns the value-chain map cells that ADR codes light.
.DESCRIPTION
    Builds the value-chain map (Get-ValueChainMap) and lights its cells with Catzc.Base.Maps.ValueChainHighlight: each
    code (ADR-<CODE>, or one rule as ADR-<CODE>#n or ADR-<CODE>:n) lights the cells its ADR sits in, its ADR domain's
    row crossed with each of its value-chain concerns
    ([ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
    [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). A rule sits where its ADR sits, so a
    citation of one rule lights the same cells as its ADR. Each lit cell lists the requested ADRs that light it. It is
    the value-chain counterpart of Get-WorldMapHighlight -Adr, which lights where the ADR's files sit.
.PARAMETER Adr
    The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.
.PARAMETER AsJson
    Return the highlight as JSON (the request and the lit cells with their ADRs) instead of the object
    ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
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
