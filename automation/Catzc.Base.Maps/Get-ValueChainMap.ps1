<#
.SYNOPSIS
    Returns the value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, and the ADRs
    in each cell.
.DESCRIPTION
    Builds the value-chain map ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)) with
    Catzc.Base.Maps.ValueChainMap from adrs.yml: the rows are the value-chain stack the registry type declares
    (Catzc.Base.Docs.AdrsConfig Stacks, [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)), the
    columns its value-chain concerns (AdrsConfig Concerns,
    [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)), and each ADR (Get-AdrRuleSet) sits on
    its ADR domain's row in the column of each of its value-chain concerns. Every row meets every column, so the map
    holds every cell, empty ones included, row by row.
.PARAMETER AsJson
    Return the map as JSON (the rows, the columns, and every cell with its ADRs) instead of the object
    ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
.OUTPUTS
    [Catzc.Base.Maps.ValueChainMap], or [string] with -AsJson.
.EXAMPLE
    (Get-ValueChainMap).Cells | Where-Object AdrCount -gt 0
.EXAMPLE
    (Get-ValueChainMap).Cell('AUTO', 'quality-control').Adrs
.EXAMPLE
    Get-ValueChainMap -AsJson
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
