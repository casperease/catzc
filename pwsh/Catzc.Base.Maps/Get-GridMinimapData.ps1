function Get-GridMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [switch] $AsJson
    )

    # Tracks down, file languages across: a cell is lit by the subject's files in it.
    $data = [Catzc.Base.Maps.MinimapData]::FromWorldMap((Get-WorldMap), (Get-WorldMapHighlight -Adr $Adr))
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
