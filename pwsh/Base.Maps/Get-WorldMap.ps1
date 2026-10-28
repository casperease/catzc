function Get-WorldMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.WorldMap], [string])]
    param(
        [switch] $AsJson,

        [ValidatePattern('^[0-9a-f]{40}$')]
        [string] $Revision
    )

    # A revision reads every input from its commit: the configs, tracks, aspects, records and globsets as well as the cited texts.
    $source = Get-RepositoryTextSource
    if ($Revision -and -not ($source -and $source.Name -ceq $Revision)) {
        return Use-WorldMapRevision -Revision $Revision -ScriptBlock { Get-WorldMap -Revision $Revision -AsJson:$AsJson }
    }

    $tracks = @(Get-Track)
    # A revision reads its paths and texts from that commit alone; without one, the index and the working tree.
    $tree = if ($Revision) {
        Get-GitCommitTree -Revision $Revision
    }
    $paths = [string[]] @(if ($Revision) {
            $tree.Keys
        }
        else {
            Get-GitTrackedPath '.'
        })
    $languages = Get-Config -Config languages

    $aspects = [ordered]@{}
    foreach ($track in $tracks) {
        # A laid-out track derives its aspects from the layout; any other track has them only when variants.yml declares them.
        if ($languages.IsLaidOut($track.languages) -or (Test-AspectDeclaration -Track $track.name)) {
            $aspects[$track.name] = @(Get-Aspect -Track $track.name)
        }
    }

    $recordIndex = [ordered]@{}
    $recordFiles = [ordered]@{}
    $citationMap = Get-DrsCitationMap
    foreach ($ruleSet in Get-DrsRuleSet) {
        $recordIndex[$ruleSet.External] = $ruleSet.Domain
        $recordFile = $citationMap.PathOf($ruleSet.External)
        if ($recordFile) {
            $recordFiles[$ruleSet.External] = $recordFile
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
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:worldMapTextCache = @{}
    }
    $texts = @{}
    $resolver = [Catzc.Base.Languages.FileCarrierResolver]::new((Get-Config -Config file-carriers), $languages)
    $commentPages = Get-Config -Config comment-pages
    $citing = [string[]] @($paths | Where-Object { [Catzc.Base.Maps.CitationScanner]::Cites($_) })
    # A commit's texts are read in one git process and keyed by blob id: an index-only path or a working-tree edit never counts.
    $pageOf = @{}
    foreach ($path in $citing) {
        $pageOf[$path] = Get-CommentPage -Path $path -Config $commentPages
    }
    $blobTexts = if ($Revision) {
        $pageBlobs = foreach ($page in $pageOf.Values) {
            if ($page -and $tree.Contains($page)) {
                $tree[$page]
            }
        }
        Get-GitBlobText -Blob @(@($citing | ForEach-Object { $tree[$_] }) + @($pageBlobs))
    }
    foreach ($path in $citing) {
        $page = $pageOf[$path]
        # A commit's text is keyed by its blob ids, so it is never stale; the working tree's by path, for the session.
        $key = if ($Revision) {
            '{0}|{1}|{2}' -f $path, $tree[$path], $(if ($page -and $tree.Contains($page)) {
                    $tree[$page]
                })
        }
        else {
            $path
        }
        if (-not $script:worldMapTextCache.ContainsKey($key)) {
            $full = Join-Path $root $path
            $text = if ($Revision) {
                $blobTexts[$tree[$path]]
            }
            elseif ([System.IO.File]::Exists($full)) {
                [System.IO.File]::ReadAllText($full)
            }
            # A file's head is derived from its citations, never read back as them: the file cites from its body.
            $carrier = $resolver.For($path)
            $form = if ($null -ne $text -and $carrier -and -not $resolver.IsExcluded($carrier, $path)) {
                $carrier.Form()
            }
            if ($form) {
                $text = (Get-CodeMetaState -Text $text -Form $form).Body
            }
            if ($null -ne $text -and $page) {
                if ($Revision -and $tree.Contains($page)) {
                    $text += "`n" + $blobTexts[$tree[$page]]
                }
                elseif (-not $Revision -and [System.IO.File]::Exists((Join-Path $root $page))) {
                    $text += "`n" + [System.IO.File]::ReadAllText((Join-Path $root $page))
                }
            }
            $script:worldMapTextCache[$key] = $text
        }
        if ($null -ne $script:worldMapTextCache[$key]) {
            $texts[$path] = $script:worldMapTextCache[$key]
        }
    }

    $citationExclude = @((Get-Config -Config maps).highlight.citation_exclude)
    $map = [Catzc.Base.Maps.WorldMapBuilder]::Build((ConvertTo-BclValue $tracks),
        (ConvertTo-BclValue @(Get-FileLanguage)), (ConvertTo-BclValue $paths),
        (ConvertTo-BclValue $aspects), $recordIndex, $recordFiles, $texts, $rootOwners, (ConvertTo-BclValue @(Get-GlobSet)),
        (ConvertTo-BclValue $citationExclude))
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
