<#
.SYNOPSIS
    Returns the value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, and the ADRs
    in each cell.
.DESCRIPTION
    Builds the value-chain map with Catzc.Base.Maps.ValueChainMap from adrs.yml: the rows are the value-chain stack...
    [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
    [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14),
    [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)
    [comment:1](/docs/references/automation/catzc-base-maps/Get-ValueChainMap.ps1.md#comment1)
.PARAMETER AsJson
    Return the map as JSON (the rows, the columns, and every cell with its ADRs) instead of the object.
    [ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
    [comment:2](/docs/references/automation/catzc-base-maps/Get-ValueChainMap.ps1.md#comment2)
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
