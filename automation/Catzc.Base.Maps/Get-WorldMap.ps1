<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/Get-WorldMap.ps1
    kind: function
    module: Catzc.Base.Maps
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the world map: every tracked file placed in one cell of tracks by file languages.
.DESCRIPTION
    File text is read only for kinds that cite ADRs, once per session, so the map costs one pass over the index.
    [ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6),
    [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md),
    [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
    [ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3),
    [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)
    [comment:1](/docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md#comment1)
.PARAMETER AsJson
    JSON carries axes, cells and per-file placements, so a tool reads the map without PowerShell.
    [ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
    [comment:2](/docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md#comment2)
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
        # A GetValue probe, not a bare read: under strict mode an unset script variable would throw.
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:3](/docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md#comment3)
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
