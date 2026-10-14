<#
.SYNOPSIS
    Returns the world map: every tracked file placed in one cell of tracks by file languages.
.DESCRIPTION
    Gathers the repository's own registries and builds the map with Catzc.Base.Maps.WorldMapBuilder:
    the tracks (Get-Track, [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)), the file languages
    (Get-FileLanguage, [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)), the tracked files from the
    git index (Get-GitTrackedPath, [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)), each
    configured track's aspects (Get-Aspect), the adrs index (Get-AdrRuleSet: ADR code to domain), the owners of the
    repository-root files (files.yml, read through Get-Config), the globsets (Get-GlobSet), and the globs of the files
    whose citations light nothing (maps.yml highlight.citation_exclude; the generated slide descriptions under
    docs/.assets/ by default, so a minimap never lights its own description).

    The root folder gives a file's track and its extension gives its file language; a file under no track or in no file
    language lands in a bucket row or column, so every file has exactly one cell. A live file whose file language its
    track does not declare is a stack violation
    ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)); test, vendored and verification-track files
    are never one.

    The text of a file is read only when its kind cites ADRs (.ps1, .cs, .yml, .yaml, .md), once per session: the
    texts stay in a module cache until the importer runs again
    ([ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6)).
.PARAMETER AsJson
    Return the map as JSON (axes, cells and per-file placements) instead of the object, so a tool reads it without
    PowerShell ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
.OUTPUTS
    [Catzc.Base.Maps.WorldMap], or [string] with -AsJson.
.EXAMPLE
    (Get-WorldMap).Cells | Where-Object FileCount -gt 0
.EXAMPLE
    (Get-WorldMap).StackViolations
.EXAMPLE
    Get-WorldMap -AsJson
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
    if ($null -ne $configured) {
        foreach ($track in $tracks) {
            if ($configured.ContainsKey($track.name)) {
                $aspects[$track.name] = @(Get-Aspect -Track $track.name)
            }
        }
    }

    $adrIndex = [ordered]@{}
    foreach ($ruleSet in Get-AdrRuleSet) {
        $adrIndex[$ruleSet.External] = $ruleSet.Domain
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
        # strict-clean probe of the lazy cache entry
        # ([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
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
    $map = [Catzc.Base.Maps.WorldMapBuilder]::Build($tracks, @(Get-FileLanguage), $paths, $aspects, $adrIndex, $texts, $rootOwners, @(Get-GlobSet),
        $citationExclude)
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
