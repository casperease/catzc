<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Write-DiagramMinimapData.ps1.md"
  header: "generated"
---
#>

function Write-DiagramMinimapData {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Stem,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # Writes out/minimaps/<folder>/<id>.json and minimaps.json; the kit's put only draws them.
    $maps = Get-Config -Config maps
    # The world map is built once for every folder of the call; a minimap that draws on it is handed it rather than
    # building its own.
    $worldMap = Get-WorldMap
    $declared = foreach ($folderPath in $Stem) {
        $text = Get-DiagramDeclarationText -Stem $folderPath -RepositoryRoot $RepositoryRoot
        Assert-True ($null -ne $text) -ErrorText "Write-DiagramMinimapData: $folderPath has no declaration in its carrier (its .drawio.yml, or one ``yml drawio`` block above its image)."
        $declaration = ConvertFrom-Yaml -Yaml $text -Ordered
        $about = if ($declaration -and $declaration.Contains('about')) {
            $declaration['about']
        }
        $content = if ($declaration -and $declaration.Contains('content')) {
            $declaration['content']
        }
        $adrs = [string[]] @(if ($about -and $about.Contains('adrs')) {
                $about['adrs']
            })
        Assert-True ($adrs.Count -gt 0) -ErrorText "Write-DiagramMinimapData: $folderPath names no ADR code in about.adrs, so its minimaps have no subject."
        $kind = if ($content -and $content.Contains('kind') -and $content['kind']) {
            "$($content['kind'])"
        }
        elseif ($folderPath -match '(^|/)references?/') {
            'reference'
        }
        else {
            'explanation'
        }
        # A shown minimap is an id or { id: { exclude: [cells] } }; none listed shows the kind's defaults.
        $shown = $null
        if ($content -and $content.Contains('minimaps') -and $content['minimaps']) {
            $shown = $content['minimaps']
        }
        Assert-True ($null -eq $shown -or
            $shown -is [System.Collections.IList]) -ErrorText "Write-DiagramMinimapData: $folderPath lists content.minimaps as a map; it is a list of ids or { id: { exclude: [cells] } }, never the cells they light."
        $excluded = @{}
        $ids = [string[]] @(if ($shown) {
                foreach ($entry in $shown) {
                    if ($entry -is [System.Collections.IDictionary]) {
                        Assert-True ($entry.Count -eq 1) -ErrorText "Write-DiagramMinimapData: $folderPath lists a minimap entry with $($entry.Count) keys; one id per entry."
                        $id = "$($entry.Keys | Select-Object -First 1)"
                        $inputs = $entry[$id]
                        $excluded[$id] = [string[]] @(if ($inputs -is [System.Collections.IDictionary] -and
                            $inputs.Contains('exclude')) {
                                $inputs['exclude']
                            })
                        $id
                    }
                    else {
                        "$entry"
                    }
                }
            }
            else {
                $maps.MinimapsOf($kind).defaults
            })
        foreach ($id in $ids) {
            Assert-True ($maps.minimap_data.ContainsKey($id)) -ErrorText "Write-DiagramMinimapData: $folderPath names minimap '$id', which is not one of: $(@($maps.minimap_data.Keys) -join ', ')"
            if (-not $excluded.ContainsKey($id)) {
                $excluded[$id] = [string[]] @()
            }
            $excluded[$id] = [System.Collections.Generic.HashSet[string]]::new($excluded[$id],
                [System.StringComparer]::Ordinal)
        }
        # The drawing's own glyphs, handed to the minimaps that place them: the labels as written, resolved by the maps
        # module, never stored.
        $glyphs = @(if ($content -and $content.Contains('glyphs') -and $content['glyphs']) {
                @($content['glyphs']) | Where-Object { $_ -is [System.Collections.IDictionary] }
            })
        [pscustomobject]@{ Folder = $folderPath; Adr = $adrs; Glyph = $glyphs; Ids = $ids; Excluded = $excluded }
    }
    # The file facts of every folder's subject are read in one call; a minimap that draws on them is handed them rather
    # than reading its own.
    $subjectPaths = foreach ($entry in $declared) {
        if (@($entry.Ids | Where-Object { (Get-Command $maps.minimap_data[$_]).Parameters.ContainsKey('Facts') }).Count -gt 0) {
            foreach ($cell in (Get-WorldMapHighlight -Adr $entry.Adr -WorldMap $worldMap).Cells) {
                foreach ($reason in $cell.Reasons) {
                    if ($reason.Path) {
                        $reason.Path
                    }
                }
            }
        }
    }
    $facts = Get-MinimapFact -Path @($subjectPaths)
    $trackedPaths = @(Get-GitTrackedPath '.')
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    foreach ($entry in $declared) {
        $folderPath = $entry.Folder
        $ids = $entry.Ids
        $target = Join-Path (Join-Path $RepositoryRoot 'out/minimaps') $folderPath
        $null = New-Item -ItemType Directory -Force -Path $target
        foreach ($id in $ids) {
            $draw = @{ Adr = $entry.Adr }
            $parameters = (Get-Command $maps.minimap_data[$id]).Parameters
            if ($parameters.ContainsKey('WorldMap')) {
                $draw.WorldMap = $worldMap
            }
            if ($parameters.ContainsKey('Facts')) {
                $draw.Facts = $facts
            }
            if ($parameters.ContainsKey('Glyph')) {
                $draw.Glyph = $entry.Glyph
                $draw.TrackedPath = $trackedPaths
            }
            $data = & $maps.minimap_data[$id] @draw
            # The drawn data is the computed one less the cells the author excludes; nothing computed is written back to
            # the declaration.
            $excluded = $entry.Excluded[$id]
            if ($excluded.Count -gt 0) {
                $kept = [Catzc.Base.Maps.MinimapCell[]] @($data.Lit | Where-Object { -not $excluded.Contains($_.At -join '/') })
                $data = [Catzc.Base.Maps.MinimapData]::new($data.Id, [Catzc.Base.Maps.MinimapAxis[]] @($data.Axes),
                    [Catzc.Base.Maps.MinimapCell[]] @($data.Cells), $kept)
            }
            [System.IO.File]::WriteAllText((Join-Path $target "$id.json"), "$($data.ToJson())`n", $utf8)
        }
        [System.IO.File]::WriteAllText((Join-Path $target 'minimaps.json'),
            (ConvertTo-Json -InputObject $ids -Compress) + "`n", $utf8)
        $target
    }
}
