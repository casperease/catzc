<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-modules/Get-CatzcModule.ps1.md"
  header: "generated"
---
#>

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

        [switch] $EngineTrack,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $anchored = -not $PSBoundParameters.ContainsKey('RepositoryRoot')
    $trackTypes = Get-Config -Config track-types
    $moduleTypes = Get-Config -Config module-types
    $languages = Get-Config -Config languages
    $byName = [System.Comparison[Catzc.Base.Modules.Module]] { param($a, $b) [string]::CompareOrdinal($a.name,
            $b.name) }
    $engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name

    $allTracks = @(Get-Track)
    $tracks = $Track ? @(Get-Track -Name $Track) : $allTracks
    if ($TrackType) {
        $tracks = @($tracks.Where({ $TrackType -ccontains $_.type }))
    }
    if ($EngineTrack) {
        $tracks = @($tracks.Where({ $_.execution_engines -ccontains $engine }))
    }
    foreach ($trackEntry in $tracks) {
        $typeEntry = $trackTypes.TypeOf($trackEntry.type)
        if ($null -eq $typeEntry -or $typeEntry.role -cne 'deployable') {
            continue
        }

        # A module is laid out when its track's primary language, the first it declares, owns layout rows.
        $primary = $trackEntry.languages.Count -gt 0 ? @($languages.languages.Where({ $_.name -ceq $trackEntry.languages[0] })) : @()
        $laidOut = $primary.Count -gt 0 -and $primary[0].layout.Count -gt 0
        $relocated = $anchored -and $trackEntry.execution_engines -ccontains $engine
        $admitted = @($moduleTypes.types.Where({ $typeEntry.admits -ccontains $_.id }))
        $admittedPlaces = @($admitted | ForEach-Object { $_.places })
        $nestedPlaces = @($allTracks.Where({ $_.name -cne $trackEntry.name }) | ForEach-Object { $_.places } |
                Where-Object {
                    $nested = $_
                    $trackEntry.places.Where({ $nested.StartsWith("$_/", [System.StringComparison]::Ordinal) }).Count -gt 0
                })

        $found = [System.Collections.Generic.List[Catzc.Base.Modules.Module]]::new()
        foreach ($moduleType in $admitted) {
            foreach ($place in $moduleType.places) {
                $trackPlace = @($trackEntry.places.Where({ $place.root -ceq $_ -or $place.root.StartsWith("$_/",
                                [System.StringComparison]::Ordinal) }))
                if ($trackPlace.Count -eq 0 -or ($place.internal -and -not $IncludeInternal)) {
                    continue
                }

                $directory = if ($relocated) {
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
                    # A module is named by its full name, its folder joined to the track's namespace (DDR-TRACK-MODULENAMESPACE).
                    # A file-shaped module (a pwsh/.internal Catzc.Internal.*.psm1) already carries its full name: a declared global exemption.
                    $fullName = $entry.Shape -ceq 'folder' ? $trackEntry.FullNameOf($entry.Name) : $entry.Name
                    if ($Name -and $Name -cnotcontains $fullName) {
                        continue
                    }

                    $files = [System.Collections.Generic.List[string]]::new()
                    if ($entry.Shape -ceq 'file') {
                        $files.Add($entry.Root.Substring($place.root.Length + 1))
                    }
                    else {
                        $prefixLength = $entry.Folder.TrimEnd('\', '/').Length + 1
                        foreach ($path in Get-ChildPath $entry.Folder -File -Depth 8) {
                            $relative = $path.Substring($prefixLength).Replace('\', '/')
                            if ($entry.Shape -ceq 'root') {
                                $full = "$($entry.Root)/$relative"
                                $slash = $relative.IndexOf('/')
                                if ($slash -gt 0 -and $relative.StartsWith('.')) {
                                    continue
                                }
                                if ($nestedPlaces.Where({ $full.StartsWith("$_/",
                                                [System.StringComparison]::Ordinal) }).Count -gt 0) {
                                    continue
                                }
                                if ($admittedPlaces.Where({ -not [object]::ReferenceEquals($_,
                                                $place) -and $_.NameOf($full) }).Count -gt 0) {
                                    continue
                                }
                            }
                            $files.Add($relative)
                        }
                    }

                    $languageNames = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
                    $unplaced = [System.Collections.Generic.List[string]]::new()
                    foreach ($file in $files) {
                        $row = $laidOut -and $entry.Shape -ceq 'folder' ? $languages.PlaceOf($file) : $null
                        if ($laidOut -and $entry.Shape -ceq 'folder' -and $null -eq $row) {
                            $unplaced.Add($file)
                        }
                        $language = $null -eq $row -or $row.live ? $languages.ForPath($file) : $null
                        if ($language) {
                            [void] $languageNames.Add($language.name)
                        }
                    }

                    $found.Add([Catzc.Base.Modules.Module]::new(
                            $fullName, $trackEntry.name, $moduleType.id, $place.root, $entry.Root, $entry.Shape,
                            $files.ToArray(), [string[]]$languageNames, [string[]]$trackEntry.EnginesOf($fullName),
                            $unplaced.ToArray()))
                }
            }
        }

        $found.Sort($byName)
        $found
    }
}
