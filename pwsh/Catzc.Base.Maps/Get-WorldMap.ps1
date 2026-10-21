<#
---
catzc:
  immutable:
    with_body_sha: fe7fcd279c6d
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
    docs: "[Get-WorldMap.ps1.md](docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-IMPORTERINVALIDATES
      - ADR-AUTO-TRACKED
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-REPO-FILEMETA-NOREADBACK
      - DDR-TRACK-TRACKISPLACEDCLUSTER
      - DDR-TRACK-ONETECHSTACK
      - DDR-TRACK-FILELANGUAGE
      - TDR-ONETRUTH-TRUTHISQUERYABLE
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
    $citationMap = Get-DrsCitationMap
    foreach ($ruleSet in Get-DrsRuleSet) {
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
    $resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), $languages)
    $commentPages = Get-Config -Config comment-pages
    foreach ($path in $paths) {
        if (-not [Catzc.Base.Maps.CitationScanner]::Cites($path)) {
            continue
        }
        if (-not $script:worldMapTextCache.ContainsKey($path)) {
            $full = Join-Path $root $path
            $text = [System.IO.File]::Exists($full) ? [System.IO.File]::ReadAllText($full) : $null
            # A file's catzc head is derived from its citations, never read back as them
            # ([ADR-REPO-FILEMETA-NOREADBACK](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)): the
            # file cites from
            # its body and its comment page, the same source the head is built from.
            $carrier = $resolver.For($path)
            $form = if ($null -ne $text -and $carrier -and -not $resolver.IsExcluded($carrier, $path)) {
                $carrier.Form()
            }
            if ($form) {
                $text = (Get-CodeMetaState -Text $text -Form $form).Body
            }
            $page = if ($null -ne $text) {
                Get-CommentPage -Path $path -Config $commentPages
            }
            if ($page -and [System.IO.File]::Exists((Join-Path $root $page))) {
                $text += "`n" + [System.IO.File]::ReadAllText((Join-Path $root $page))
            }
            $script:worldMapTextCache[$path] = $text
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
