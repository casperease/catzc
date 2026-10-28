function Get-GridMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Rule,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [switch] $AsJson
    )

    $map = if ($WorldMap) {
        $WorldMap
    }
    else {
        Get-WorldMap
    }
    # Tracks down, file languages across: a cell is lit by the subject's files in it.
    $data = [Catzc.Base.Maps.MinimapData]::FromWorldMap($map, (Get-WorldMapHighlight -Rule $Rule -WorldMap $map))
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
