<#
---
catzc:
  immutable:
    with_body_sha: a76450255c71
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Write-DiagramMinimapData.Tests.ps1
    docs: "[Write-DiagramMinimapData.ps1.md](../../../docs/references/pwsh/catzc-base-slides/private/Write-DiagramMinimapData.ps1.md)"
---
#>

function Write-DiagramMinimapData {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Folder,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $maps = Get-Config -Config maps
    # The world map is built once for every folder of the call; a minimap that draws on it is handed it rather than building its own.
    $worldMap = Get-WorldMap
    $declared = foreach ($folderPath in $Folder) {
        $source = Join-Path $RepositoryRoot "$folderPath.drawio.yml"
        $declaration = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($source)) -Ordered
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
        # The declared minimaps map each shown id to its lit cells, so the ids are the map's keys.
        $ids = [string[]] @(if ($content -and $content.Contains('minimaps') -and $content['minimaps']) {
                $content['minimaps'].Keys
            }
            else {
                $maps.MinimapsOf($kind).defaults
            })
        # The lit cells each minimap declares, as its at values joined by '/'; a minimap the declaration does not map declares none.
        $placed = @{}
        foreach ($id in $ids) {
            Assert-True ($maps.minimap_data.ContainsKey($id)) -ErrorText "Write-DiagramMinimapData: $folderPath names minimap '$id', which is not one of: $(@($maps.minimap_data.Keys) -join ', ')"
            $placed[$id] = [System.Collections.Generic.HashSet[string]]::new([string[]] @(
                    if ($content -and $content.Contains('minimaps') -and $content['minimaps'] -is [System.Collections.IDictionary] -and $content['minimaps'][$id]) {
                        foreach ($entry in $content['minimaps'][$id]) {
                            "$($entry['cell'])"
                        }
                    }), [System.StringComparer]::Ordinal)
        }
        [pscustomobject]@{ Folder = $folderPath; Adr = $adrs; Ids = $ids; Placed = $placed }
    }
    # The file facts of every folder's subject are read in one call; a minimap that draws on them is handed them rather than reading its own.
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
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    foreach ($entry in $declared) {
        $folderPath = $entry.Folder
        $ids = $entry.Ids
        $target = Join-Path (Join-Path $RepositoryRoot 'out/minimaps') $folderPath
        $computed = Join-Path $target 'computed'
        $null = New-Item -ItemType Directory -Force -Path $computed
        foreach ($id in $ids) {
            $draw = @{ Adr = $entry.Adr }
            $parameters = (Get-Command $maps.minimap_data[$id]).Parameters
            if ($parameters.ContainsKey('WorldMap')) {
                $draw.WorldMap = $worldMap
            }
            if ($parameters.ContainsKey('Facts')) {
                $draw.Facts = $facts
            }
            $data = & $maps.minimap_data[$id] @draw
            [System.IO.File]::WriteAllText((Join-Path $computed "$id.json"), "$($data.ToJson())`n", $utf8)
            $placed = $entry.Placed[$id]
            $kept = [Catzc.Base.Maps.MinimapCell[]] @($data.Lit | Where-Object { $placed.Contains($_.At -join '/') })
            if ($kept.Count -lt $data.Lit.Count) {
                $dropped = @($data.Lit | Where-Object { -not $placed.Contains($_.At -join '/') } | ForEach-Object { $_.At -join '/' })
                Write-Warning "Write-DiagramMinimapData: $folderPath minimap '$id' drops $($dropped.Count) lit cell(s) its .drawio.yml does not list under content.minimaps: $($dropped -join ', ')"
                $data = [Catzc.Base.Maps.MinimapData]::new($data.Id, [Catzc.Base.Maps.MinimapAxis[]] @($data.Axes), [Catzc.Base.Maps.MinimapCell[]] @($data.Cells), $kept)
            }
            [System.IO.File]::WriteAllText((Join-Path $target "$id.json"), "$($data.ToJson())`n", $utf8)
        }
        [System.IO.File]::WriteAllText((Join-Path $target 'minimaps.json'), (ConvertTo-Json -InputObject $ids -Compress) + "`n", $utf8)
        $target
    }
}
