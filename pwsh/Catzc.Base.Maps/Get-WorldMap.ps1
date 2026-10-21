<#
---
catzc:
  immutable:
    with_body_sha: "95ec0b9b81c7"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
    docs: "[Get-WorldMap.ps1.md](docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-IMPORTERINVALIDATES
      - ADR-AUTO-TRACKED
      - ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER
      - ADR-DSGN-TRACK-ONETECHSTACK
      - ADR-DSGN-TRACK-FILELANGUAGE
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-THES-ONETRUTH-TRUTHISQUERYABLE
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
    $languages = Get-Config -Config languages

    $aspects = [ordered]@{}
    foreach ($track in $tracks) {
        # A laid-out track derives its aspects from the layout; any other track has them only when variants.yml declares them.
        if ($languages.IsLaidOut($track.languages) -or (Test-AspectDeclaration -Track $track.name)) {
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
    $map = [Catzc.Base.Maps.WorldMapBuilder]::Build((ConvertTo-BclValue $tracks), (ConvertTo-BclValue @(Get-FileLanguage)), (ConvertTo-BclValue $paths),
        (ConvertTo-BclValue $aspects), $adrIndex, $adrFiles, $texts, $rootOwners, (ConvertTo-BclValue @(Get-GlobSet)), (ConvertTo-BclValue $citationExclude))
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
