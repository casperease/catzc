# cspell:ignore minimaps
<#
.SYNOPSIS
    The minimap data step: reads the two map processors (module Catzc.Base.Maps) for a list of slides.
.DESCRIPTION
    Writes into -Data, for render.py and join.py next to this script (.claude/drawio/STYLE.md):
      world-map.json        Get-WorldMap -AsJson
      value-chain-map.json  Get-ValueChainMap -AsJson
      file-languages.json   each file language's extensions (Get-FileLanguage)
      palette.json          the maps.yml palette the minimaps share with the world-map PDFs
      labels.json           the printed terms: the two bucket keys' labels and the value_chain_* labels of maps.yml
      references.json       every ADR code's file (Get-AdrCitationMap) and every glossary term with its defining rule
      highlights.json       per slide id: the world-map and the value-chain highlight of the slide's ADR codes, each
                            with its reasons (Get-WorldMapHighlight, Get-ValueChainHighlight -Adr <codes> -AsJson)
    A slide whose ADR codes the maps do not know fails the run, listing every such slide.
.PARAMETER Slides
    The slide list: a JSON file { "slides": [ { "id", "stem", "lens", "adrs": [...], "xml" } ] }.
.PARAMETER Data
    The folder the data files go to; created when missing. Default: out/minimaps under the repository root.
.EXAMPLE
    pwsh -NoProfile -File .claude/drawio/minimaps/highlights.ps1 -Slides out/diagrams/k4/slides.docs.json
#>
param(
    [Parameter(Mandatory)]
    [string] $Slides,

    [string] $Data
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$repo = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
. (Join-Path $repo 'importer.ps1') *> $null

$utf8 = [System.Text.UTF8Encoding]::new($false)
$dataFolder = $Data ? [System.IO.Path]::GetFullPath($Data, $repo) : (Join-Path $repo 'out/minimaps')
$null = New-Item -ItemType Directory -Force -Path $dataFolder
$slideList = (Get-Content -Raw -Encoding utf8 ([System.IO.Path]::GetFullPath($Slides, $repo)) | ConvertFrom-Json).slides
$started = [System.Diagnostics.Stopwatch]::StartNew()

[System.IO.File]::WriteAllText((Join-Path $dataFolder 'world-map.json'), (Get-WorldMap -AsJson) + "`n", $utf8)
# Each file language's extensions: the grid's short column label is its first extension (.claude/drawio/STYLE.md).
$extensions = [ordered]@{}
foreach ($language in @(Get-FileLanguage)) {
    $extensions[$language.name] = @($language.extensions)
}
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'file-languages.json'), ($extensions | ConvertTo-Json) + "`n", $utf8)
$chainJson = Get-ValueChainMap -AsJson
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'value-chain-map.json'), $chainJson + "`n", $utf8)
$maps = Get-Config -Config maps
$palette = $maps.palette | Select-Object background, cell, shade, line, text, highlight | ConvertTo-Json
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'palette.json'), $palette + "`n", $utf8)
# The printed labels: a bucket key prints as its defined term (ADR-DSGN-TRACK#7, #8, #13), the value-chain map as its
# value_chain_* labels.
$printed = [ordered]@{
    buckets     = [ordered]@{
        [Catzc.Base.Maps.WorldMap]::NoTrack        = $maps.labels.root_files
        [Catzc.Base.Maps.WorldMap]::NoFileLanguage = $maps.labels.unlisted_files
    }
    value_chain = [ordered]@{
        title            = $maps.labels.value_chain_title
        row_axis         = $maps.labels.value_chain_row_axis
        column_axis      = $maps.labels.value_chain_column_axis
        legend_adrs      = $maps.labels.value_chain_legend_adrs
        legend_highlight = $maps.labels.value_chain_legend_highlight
    }
} | ConvertTo-Json
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'labels.json'), $printed + "`n", $utf8)

# One pair of highlights per distinct set of ADR codes; every unknown code is collected, then thrown.
$byRequest = @{}
$errors = [System.Collections.Generic.List[string]]::new()
$parts = [System.Collections.Generic.List[string]]::new()
foreach ($slide in $slideList) {
    $codes = @($slide.adrs | Sort-Object -Unique)
    $key = $codes -join ','
    if (-not $byRequest.ContainsKey($key)) {
        try {
            $byRequest[$key] = [ordered]@{
                world = Get-WorldMapHighlight -Adr $codes -AsJson
                chain = Get-ValueChainHighlight -Adr $codes -AsJson
            }
        }
        catch {
            $errors.Add("$($slide.id): $($_.Exception.Message)")
            continue
        }
    }
    $world = ($byRequest[$key].world -split "`n") -join "`n    "
    $chain = ($byRequest[$key].chain -split "`n") -join "`n    "
    $parts.Add("  `"$($slide.id)`": {`n    `"world`": $world,`n    `"chain`": $chain`n  }")
}
if ($errors.Count -gt 0) {
    throw "highlights.ps1: $($errors.Count) slides have no highlight:`n$($errors -join "`n")"
}
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'highlights.json'), "{`n" + ($parts -join ",`n") + "`n}`n", $utf8)

# The link targets of the sister .md files: every ADR code's file (the link engine's own map), and every glossary term
# with the rule that defines it.
$citations = Get-AdrCitationMap
$adrFiles = [ordered]@{}
foreach ($code in $citations.Codes) {
    $adrFiles[$code] = $citations.PathOf($code)
}
$terms = Get-Glossary  # one array object (Get-Glossary returns , $sorted), so assign before enumerating
$glossary = foreach ($entry in $terms) {
    [ordered]@{ term = $entry.Concept.term; defined_by = $entry.Concept.defined_by }
}
$references = [ordered]@{ adr_files = $adrFiles; glossary = @($glossary) } | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText((Join-Path $dataFolder 'references.json'), $references + "`n", $utf8)
"highlights.ps1: $($slideList.Count) slides, $($byRequest.Count) distinct requests, $([int]$started.Elapsed.TotalSeconds) s -> $dataFolder"
