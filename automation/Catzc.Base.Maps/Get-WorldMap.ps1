<#
---
catzc:
  immutable:
    repo_status: clean
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
