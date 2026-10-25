function Get-RepositoryFilter {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        # The filters to resolve, by name; every declared filter, in declaration order, by default.
        [ArgumentCompleter({ (Get-Config -Config filters).filters.ForEach({ $_.name }) })]
        [string[]] $Name
    )

    $filters = @((Get-Config -Config filters).filters)
    foreach ($wanted in @($Name).Where({ $_ -and $_ -cnotin $filters.ForEach({ $_.name }) })) {
        throw "Get-RepositoryFilter: no filter '$wanted' (declared in filters.yml: $($filters.ForEach({ $_.name }) -join ', '))."
    }
    $tracks = @(Get-Track)
    $aspectSets = $null
    $generated = $null
    $kinds = $null

    # A set claims a path that one of its includes matches and none of its excludes does. A literal path claims itself and what lies
    # under it, so a new file is classified by the same patterns the model holds, never by a stale list of files.
    $literal = { param([string[]] $Paths) foreach ($path in $Paths) { [ordered]@{ include = @($path, "$path/**"); exclude = @() } } }
    $pattern = { param([string[]] $Globs) foreach ($glob in $Globs) { [ordered]@{ include = @($glob); exclude = @() } } }
    $entry = { param([string[]] $Items) foreach ($item in $Items) { if ($item -match '[*?]') { & $pattern @($item) } else { & $literal @($item) } } }
    # A track's files: each of its places and what lies under it, less the places of the tracks nested inside it (`.github` without
    # `.github/workflows`), because every file is in exactly one track.
    $owned = {
        param([object[]] $Selected)
        foreach ($track in $Selected) {
            foreach ($place in $track.places) {
                $nested = @($tracks.Where({ $_.name -cne $track.name }).ForEach({ $_.places }).Where({ $_.StartsWith("$place/", [System.StringComparison]::Ordinal) }))
                [ordered]@{ include = @($place, "$place/**"); exclude = @(foreach ($inner in $nested) { $inner; "$inner/**" }) }
            }
        }
    }

    foreach ($filter in $filters.Where({ -not $Name -or $_.name -cin $Name })) {
        $sets = [System.Collections.Generic.List[object]]::new()
        foreach ($selector in $filter.select) {
            $argument = [Catzc.Base.Globs.RepositoryFilter]::ArgumentOf($selector)
            $resolved = switch ([Catzc.Base.Globs.RepositoryFilter]::KindOf($selector)) {
                'aspect' {
                    $aspectSets ??= Get-AspectGlobSet
                    if (-not $aspectSets.Contains($argument)) {
                        throw "Get-RepositoryFilter: filter '$($filter.name)' selects aspect '$argument', which no unit has (aspects: $(@($aspectSets.Keys) -join ', '))."
                    }
                    foreach ($set in $aspectSets[$argument]) {
                        [ordered]@{ include = @(foreach ($glob in $set.Include) { "$glob" }); exclude = @(foreach ($glob in $set.Exclude) { "$glob" }) }
                    }
                }
                'track' {
                    $match = $tracks.Where({ $_.name -ceq $argument })
                    if ($match.Count -eq 0) {
                        throw "Get-RepositoryFilter: filter '$($filter.name)' selects track '$argument', which variants.yml does not declare."
                    }
                    & $owned @($match[0])
                }
                'track_type' {
                    # A selector is in the snake normal form; a track type's id is kebab.
                    $type = $argument.Replace('_', '-')
                    $match = $tracks.Where({ $_.type -ceq $type })
                    if ($match.Count -eq 0) {
                        throw "Get-RepositoryFilter: filter '$($filter.name)' selects track type '$type', which no track has."
                    }
                    & $owned $match
                }
                'kind' {
                    # A file kind's globs as file-kinds.yml declares them, its subkinds' included (ADR-REPO-FILEMETA-METAKIND).
                    $kinds ??= (Get-Config -Config file-kinds).kinds
                    $match = @($kinds.Where({ $_.role -ceq $argument -and -not $_.subkind }))
                    if ($match.Count -eq 0) {
                        throw "Get-RepositoryFilter: filter '$($filter.name)' selects kind '$argument', which file-kinds.yml does not declare (kinds: $(@($kinds.Where({ -not $_.subkind }).ForEach({ $_.role })) -join ', '))."
                    }
                    & $pattern ([string[]]@($match[0].files) + [string[]]@($match[0].subkinds.ForEach({ $_.files })))
                }
                'glob' {
                    & $entry @($argument)
                }
                'generated' {
                    $generated ??= @(Get-GeneratedTarget)
                    & $entry ([string[]]@($generated.ForEach({ $_.path })))
                }
                'root_config' {
                    & $literal ([string[]]@((Get-Config -Config rootconfig).files.Where({ $_.optIn -and -not $_.target.Contains('/') }).ForEach({ $_.target })))
                }
            }
            foreach ($set in @($resolved)) {
                $sets.Add($set)
            }
        }
        [pscustomobject]@{ name = $filter.name; sets = $sets.ToArray() }
    }
}
