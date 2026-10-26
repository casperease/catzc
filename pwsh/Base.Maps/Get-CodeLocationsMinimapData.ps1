function Get-CodeLocationsMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [System.Collections.IDictionary] $Facts,

        # The drawing's own glyphs, each { kind; label }: the places they name come first, the cited records' places while rows remain.
        [object[]] $Glyph = @(),

        # Every tracked path, the index a glyph label is resolved against; read once when not given.
        [string[]] $TrackedPath,

        [switch] $AsJson
    )

    # Where the subject's code lives, with no static frame: each place a track, its module ('-' outside one) and folder ('.' at its root).
    $count = @{}
    $reasons = @{}
    $primary = [System.Collections.Generic.List[string[]]]::new()
    $secondary = [System.Collections.Generic.List[string[]]]::new()
    $known = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    # Each glyph label is resolved to the files it names; a label that names none is dropped and counted.
    $dropped = 0
    $resolved = @()
    if (@($Glyph).Count -gt 0) {
        if (-not $PSBoundParameters.ContainsKey('TrackedPath')) {
            $TrackedPath = @(Get-GitTrackedPath '.')
        }
        $resolved = @(Resolve-MinimapGlyphPath -Glyph $Glyph -TrackedPath $TrackedPath)
        $dropped = @($resolved | Where-Object { @($_.Path).Count -eq 0 }).Count
        $glyphPaths = @($resolved | ForEach-Object { $_.Path } | Where-Object { $_ } | Select-Object -Unique)
        $glyphFacts = if ($glyphPaths.Count -gt 0) {
            Get-MinimapFact -Path $glyphPaths
        }
        else {
            @{}
        }
        foreach ($entry in $resolved) {
            foreach ($path in @($entry.Path)) {
                $fact = $glyphFacts[$path]
                if (-not $fact -or -not $fact['track']) {
                    continue
                }
                $place = Get-MinimapPlace -Path $path -Facts $fact
                if ($known.Add($place -join "`t")) {
                    $primary.Add($place)
                }
                Add-MinimapHit -Count $count -Reasons $reasons -At $place -Reason ([Catzc.Base.Maps.MinimapReason]::new($path, 'glyph', $entry.Label, $null))
            }
        }
        Write-Message "Get-CodeLocationsMinimapData: $(@($resolved).Count - $dropped) of $(@($resolved).Count) glyph label(s) resolved to a repository place, $dropped dropped."
    }
    $drawsDocs = @($primary | Where-Object { $_[0] -eq 'docs' }).Count -gt 0
    foreach ($item in @(Get-MinimapSubject -Adr $Adr -WorldMap $WorldMap -Facts $Facts)) {
        if (-not $item.Facts -or -not $item.Facts['track']) {
            continue
        }
        $place = Get-MinimapPlace -Path $item.Path -Facts $item.Facts
        if ($place[0] -eq 'docs' -and -not $drawsDocs) {
            continue
        }
        if ($known.Add($place -join "`t")) {
            $secondary.Add($place)
        }
        $reason = [Catzc.Base.Maps.MinimapReason]::new($item.Path, 'citation', $item.Requested, $null)
        Add-MinimapHit -Count $count -Reasons $reasons -At $place -Reason $reason
    }
    $sorted = @(@($primary) + @($secondary) | Sort-Object { $_ -join "`t" })
    $axes = [ordered]@{
        track  = [string[]] @($sorted | ForEach-Object { $_[0] } | Select-Object -Unique)
        module = [string[]] @($sorted | ForEach-Object { $_[1] } | Select-Object -Unique)
        folder = [string[]] @($sorted | ForEach-Object { $_[2] } | Select-Object -Unique)
    }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::CodeLocations) -Axes $axes -Cells ([string[][]] $sorted) -Count $count -Reasons $reasons
    # The rows the place list draws are computed here, from the place triples, so the drawing only draws them.
    $first = [System.Collections.Generic.HashSet[string]]::new([string[]] @($primary | ForEach-Object { $_ -join "`t" }), [System.StringComparer]::Ordinal)
    $primaryCells = [Catzc.Base.Maps.MinimapCell[]] @($data.Lit | Where-Object { $first.Contains($_.At -join "`t") })
    $secondaryCells = [Catzc.Base.Maps.MinimapCell[]] @($data.Lit | Where-Object { -not $first.Contains($_.At -join "`t") })
    $data = $data.WithPlaceRows([Catzc.Base.Maps.PlaceRows]::From($primaryCells, $secondaryCells,
            (Get-Config -Config maps).minimap_places))
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
