<#
---
catzc:
  immutable:
    with_body_sha: c414f6b7fc15
  edges:
    docs: "[Write-DiagramMinimapData.ps1.md](docs/references/pwsh/catzc-base-slides/private/Write-DiagramMinimapData.ps1.md)"
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
        $source = Join-Path $RepositoryRoot "$folderPath/diagram.drawio.yml"
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
        $ids = [string[]] @(if ($content -and $content.Contains('minimaps') -and $content['minimaps']) {
                $content['minimaps']
            }
            else {
                $maps.MinimapsOf($kind).defaults
            })
        foreach ($id in $ids) {
            Assert-True ($maps.minimap_data.ContainsKey($id)) -ErrorText "Write-DiagramMinimapData: $folderPath names minimap '$id', which is not one of: $(@($maps.minimap_data.Keys) -join ', ')"
        }
        [pscustomobject]@{ Folder = $folderPath; Adr = $adrs; Ids = $ids }
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
        $null = New-Item -ItemType Directory -Force -Path $target
        foreach ($id in $ids) {
            $draw = @{ Adr = $entry.Adr; AsJson = $true }
            $parameters = (Get-Command $maps.minimap_data[$id]).Parameters
            if ($parameters.ContainsKey('WorldMap')) {
                $draw.WorldMap = $worldMap
            }
            if ($parameters.ContainsKey('Facts')) {
                $draw.Facts = $facts
            }
            $json = & $maps.minimap_data[$id] @draw
            [System.IO.File]::WriteAllText((Join-Path $target "$id.json"), "$json`n", $utf8)
        }
        [System.IO.File]::WriteAllText((Join-Path $target 'minimaps.json'), (ConvertTo-Json -InputObject $ids -Compress) + "`n", $utf8)
        $target
    }
}
