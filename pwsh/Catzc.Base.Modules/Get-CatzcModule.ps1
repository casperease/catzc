function Get-CatzcModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Modules.Module])]
    param(
        [ArgumentCompleter({ Get-CatzcModule | ForEach-Object name })]
        [string[]] $Name,

        [ArgumentCompleter({ Get-Track | ForEach-Object name })]
        [string[]] $Track,

        [ArgumentCompleter({ (Get-Config -Config track-types).types.id })]
        [string[]] $TrackType,

        [switch] $IncludeInternal,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $anchored = -not $PSBoundParameters.ContainsKey('RepositoryRoot')
    $trackTypes = Get-Config -Config track-types
    $moduleTypes = Get-Config -Config module-types
    $languages = Get-Config -Config languages
    $byName = [System.Comparison[Catzc.Base.Modules.Module]] { param($a, $b) [string]::CompareOrdinal($a.name, $b.name) }

    $tracks = $Track ? @(Get-Track -Name $Track) : @(Get-Track)
    if ($TrackType) {
        $tracks = @($tracks.Where({ $TrackType -ccontains $_.type }))
    }
    foreach ($trackEntry in $tracks) {
        $typeEntry = $trackTypes.TypeOf($trackEntry.type)
        if ($null -eq $typeEntry -or $typeEntry.role -cne 'deployable') {
            continue
        }

        # A module is laid out when its track's primary language, the first it declares, owns layout rows.
        $primary = $trackEntry.languages.Count -gt 0 ? @($languages.languages.Where({ $_.name -ceq $trackEntry.languages[0] })) : @()
        $laidOut = $primary.Count -gt 0 -and $primary[0].layout.Count -gt 0

        $found = [System.Collections.Generic.List[Catzc.Base.Modules.Module]]::new()
        foreach ($moduleType in $moduleTypes.types.Where({ $typeEntry.admits -ccontains $_.id })) {
            foreach ($place in $moduleType.places) {
                $trackPlace = @($trackEntry.places.Where({ $place.root -ceq $_ -or $place.root.StartsWith("$_/", [System.StringComparison]::Ordinal) }))
                if ($trackPlace.Count -eq 0 -or ($place.root -cne $trackPlace[0] -and -not $IncludeInternal)) {
                    continue
                }

                $directory = if ($anchored -and $typeEntry.id -ceq 'modules') {
                    $tail = $place.root.Substring($trackPlace[0].Length).TrimStart('/')
                    $tail ? (Join-Path (Get-CatzcModulesRoot) $tail) : (Get-CatzcModulesRoot)
                }
                else {
                    Join-Path $RepositoryRoot $place.root
                }
                if (-not (Test-Path -LiteralPath $directory -PathType Container)) {
                    continue
                }

                foreach ($entry in Get-PlaceModuleEntry -Place $place -Directory $directory) {
                    if ($Name -and $Name -cnotcontains $entry.Name) {
                        continue
                    }

                    $files = [System.Collections.Generic.List[string]]::new()
                    if ($entry.Shape -ceq 'file') {
                        $files.Add($entry.Root.Substring($place.root.Length + 1))
                    }
                    else {
                        # A whole module tree is listed on purpose, a named exception to the bounded walk: tests nest fixtures up to six levels below the module.
                        $prefixLength = $entry.Folder.TrimEnd('\', '/').Length + 1
                        foreach ($path in Get-ChildPath $entry.Folder -File -Depth 8) {
                            $files.Add($path.Substring($prefixLength).Replace('\', '/'))
                        }
                    }

                    $languageNames = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
                    $unplaced = [System.Collections.Generic.List[string]]::new()
                    foreach ($file in $files) {
                        $row = $laidOut -and $entry.Shape -ceq 'folder' ? $languages.PlaceOf($file) : $null
                        if ($laidOut -and $entry.Shape -ceq 'folder' -and $null -eq $row) {
                            $unplaced.Add($file)
                        }
                        # The languages of a module are those of its live files: a test, or a README, is no second tech-stack.
                        $language = $null -eq $row -or $row.live ? $languages.ForPath($file) : $null
                        if ($language) {
                            [void] $languageNames.Add($language.name)
                        }
                    }

                    $found.Add([Catzc.Base.Modules.Module]::new(
                            $entry.Name, $trackEntry.name, $moduleType.id, $place.root, $entry.Root, $entry.Shape,
                            $files.ToArray(), [string[]]$languageNames, [string[]]$trackEntry.EnginesOf($entry.Name), $unplaced.ToArray()))
                }
            }
        }

        $found.Sort($byName)
        $found
    }
}
