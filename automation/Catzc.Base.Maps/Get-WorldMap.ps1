<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/Get-WorldMap.ps1
    name: get-world-map
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
    test: automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#6
      - ADR-AUTO-TRACKED
      - ADR-DSGN-TRACK#{1,3,6}
      - ADR-PWSH-CACHE#4
      - ADR-THES-ONETRUTH#3
  config:
    synopsis: 'Returns the world map: every tracked file placed in one cell of tracks by file languages.'
    description: |-
      Gathers the repository's own registries and builds the map with Catzc.Base.Maps.WorldMapBuilder:
      the tracks (Get-Track, [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)), the file languages
      (Get-FileLanguage, [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)), the tracked files from the
      git index (Get-GitTrackedPath, [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)), each
      configured track's aspects (Get-Aspect), the adrs index (Get-AdrRuleSet: ADR code to domain), each ADR code's own
      file (Get-AdrCitationMap, the map the link engine uses; an ADR lights its own file, never its domain's), the
      owners of the repository-root files (files.yml, read through Get-Config), the globsets (Get-GlobSet), and the globs of the files
      whose citations light nothing (maps.yml highlight.citation_exclude; by default the generated slide descriptions
      under docs/.assets/, the explanation articles under docs/explanation/ and the drawing tooling under .claude/drawio/,
      so a slide's minimap lights the repository's citations of its ADRs, never the slide's own words).

      The root folder gives a file's track and its extension gives its file language; a file under no track or in no file
      language lands in a bucket row or column, so every file has exactly one cell. A live file whose file language its
      track does not declare is a stack violation
      ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)); test, vendored and verification-track files
      are never one.

      The text of a file is read only when its kind cites ADRs (.ps1, .cs, .yml, .yaml, .md), once per session: the
      texts stay in a module cache until the importer runs again
      ([ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6)).
    parameters:
      AsJson: |-
        Return the map as JSON (axes, cells and per-file placements) instead of the object, so a tool reads it without
        PowerShell ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
    outputs: '[Catzc.Base.Maps.WorldMap], or [string] with -AsJson.'
    examples:
      - (Get-WorldMap).Cells | Where-Object FileCount -gt 0
      - (Get-WorldMap).StackViolations
      - Get-WorldMap -AsJson
---
#>

function Get-WorldMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.WorldMap], [string])]
    param(
        [switch] $AsJson
    )

    $tracks = @(Get-Track)
    $paths = @(Get-GitTrackedPath '.')

    $aspects = [ordered]@{}
    $configured = (Get-Config -Config variants).aspects
    foreach ($track in $tracks) {
        # A code track derives its aspects from the layout; any other track has them only when variants.yml declares them.
        if ($track.type -ceq 'modules' -or ($null -ne $configured -and $configured.ContainsKey($track.name))) {
            $aspects[$track.name] = @(Get-Aspect -Track $track.name)
        }
    }

    $adrIndex = [ordered]@{}
    $adrFiles = [ordered]@{}
    $citationMap = Get-AdrCitationMap
    foreach ($ruleSet in Get-AdrRuleSet) {
        $adrIndex[$ruleSet.External] = $ruleSet.Domain
        $adrFile = $citationMap.PathOf($ruleSet.External)
        if ($adrFile) {
            $adrFiles[$ruleSet.External] = $adrFile
        }
    }

    # A repository-root file's owner is the folder of the module whose files.yml package lists it.
    $root = Get-RepositoryRoot
    $modulesFolder = [System.IO.Path]::GetRelativePath($root, (Get-CatzcModulesRoot)).Replace('\', '/')
    $rootOwners = [ordered]@{}
    $modules = (Get-Config -Config files).modules
    foreach ($module in $modules.Keys) {
        foreach ($package in $modules[$module].packages.Values) {
            foreach ($file in $package) {
                if (-not ([string] $file).Contains('/')) {
                    $rootOwners[[string] $file] = "$modulesFolder/$module"
                }
            }
        }
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:worldMapTextCache')) {
        $script:worldMapTextCache = @{}
    }
    $texts = @{}
    foreach ($path in $paths) {
        if (-not [Catzc.Base.Maps.CitationScanner]::Cites($path)) {
            continue
        }
        if (-not $script:worldMapTextCache.ContainsKey($path)) {
            $full = Join-Path $root $path
            $script:worldMapTextCache[$path] = [System.IO.File]::Exists($full) ? [System.IO.File]::ReadAllText($full) : $null
        }
        if ($null -ne $script:worldMapTextCache[$path]) {
            $texts[$path] = $script:worldMapTextCache[$path]
        }
    }

    $citationExclude = @((Get-Config -Config maps).highlight.citation_exclude)
    $map = [Catzc.Base.Maps.WorldMapBuilder]::Build($tracks, @(Get-FileLanguage), $paths, $aspects, $adrIndex, $adrFiles, $texts, $rootOwners,
        @(Get-GlobSet), $citationExclude)
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
