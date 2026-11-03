function Get-FileAspect {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        # Repository-relative, '/'-separated paths.
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $aspects = [ordered]@{}
    # A consumer has no module glob sets, so its aspect comes from the aspect definitions of the path's track.
    if ((Get-CatzcRunMode) -eq 'build') {
        $definitions = @{}
        foreach ($file in $Path) {
            $aspects[$file] = ''
            $relative = $file.Replace('\', '/')
            $track = Get-Track -Path $relative
            if ($null -eq $track) {
                continue
            }
            $segments = $relative.Split('/')
            foreach ($place in $track.places) {
                $depth = $place.Split('/').Count
                if ($segments.Count -le $depth + 1 -or -not $relative.StartsWith("$place/", [System.StringComparison]::Ordinal)) {
                    continue
                }
                if (-not $definitions.ContainsKey($track.name)) {
                    $list = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
                    foreach ($definition in Get-Aspect -Track $track.name) {
                        $list.Add([Catzc.Base.Globs.Aspect]::new($definition.Name, [string[]]$definition.Patterns))
                    }
                    $definitions[$track.name] = $list
                }
                $moduleRoot = $segments[0..$depth] -join '/'
                foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($definitions[$track.name], $moduleRoot)) {
                    $set = [Catzc.Base.Globs.GlobSet]::new($compiled.Name, 'Transient module aspect', 'module',
                        [string[]]$compiled.Include, [string[]]$compiled.Exclude, @(), @(), -1, $null)
                    if ($set.Matches($relative)) {
                        $aspects[$file] = $compiled.Name
                        break
                    }
                }
                break
            }
        }
        return $aspects
    }

    # The sets are built once per call, by the one place that builds them.
    $sets = Get-AspectGlobSet
    foreach ($file in $Path) {
        $relative = $file.Replace('\', '/')
        $aspect = [Catzc.Base.Globs.AspectPartition]::AspectOf($sets, $relative)
        $aspects[$file] = if ($null -eq $aspect) {
            ''
        }
        else {
            $aspect
        }
    }
    $aspects
}
