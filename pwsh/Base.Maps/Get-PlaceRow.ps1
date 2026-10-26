function Get-PlaceRow {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]] $Path
    )

    begin {
        $places = (Get-Config -Config maps).minimap_places
    }
    process {
        $normal = @($Path | ForEach-Object { (New-Object Catzc.Base.Objects.RepoRelativePath $_).Relative })
        $facts = Get-MinimapFact -Path $normal
        foreach ($file in $normal) {
            $fact = $facts[$file]
            if (-not $fact -or -not $fact['track']) {
                continue
            }
            $place = Get-MinimapPlace -Path $file -Facts $fact
            [Catzc.Base.Maps.PlaceRows]::Form($place[0], $place[1], $place[2], $places)
        }
    }
}
