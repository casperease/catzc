function Get-AspectCover {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        # The tracked files the cover is computed over; the git index by default.
        [string[]] $File,

        # Aspect name to the globsets of that aspect, one per unit; every unit of every laid-out or aspect-declaring track by default.
        [System.Collections.IDictionary] $AspectSet
    )

    if (-not $PSBoundParameters.ContainsKey('File')) {
        $File = @(Get-TrackedFile)
    }
    if (-not $PSBoundParameters.ContainsKey('AspectSet')) {
        $AspectSet = [ordered]@{}
        $add = {
            param([string] $Name, [Catzc.Base.Globs.GlobSet] $Set)
            $AspectSet[$Name] = @(@($AspectSet[$Name]).Where({ $null -ne $_ })) + $Set
        }
        # A globset name is kebab-case: a unit's path or a module's name, lower-cased, every other character a hyphen.
        $setName = { param([string] $Text) ($Text.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-') }
        $languages = Get-Config -Config languages
        $declared = Get-AspectDeclaration
        foreach ($track in Get-Track) {
            $laidOut = $languages.IsLaidOut($track.languages)
            if (-not $laidOut -and -not $declared.ContainsKey($track.name)) {
                continue
            }
            $aspects = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
            foreach ($aspect in Get-Aspect -Track $track.name) {
                $aspects.Add([Catzc.Base.Globs.Aspect]::new($aspect.Name, [string[]]$aspect.Patterns))
            }
            # A laid-out track's units are its modules; a single-file module is a live unit of its own (the degenerate partition), and the
            # folder that holds single-file modules follows the track's convention like a module. A declaring track is one unit per place.
            $units = $track.places
            if ($laidOut) {
                $modules = @(Get-CatzcModule -Track $track.name -IncludeInternal)
                $files = $modules.Where({ $_.shape -ceq 'file' })
                foreach ($module in $files) {
                    & $add 'live' ([Catzc.Base.Globs.GlobSet]::new((& $setName $module.name), "Single-file module - $($module.root) [live]", 'module',
                            [string[]]@($module.root), [string[]]@(), @(), @(), -1, $null))
                }
                # Live never reaches a tests folder (DDR-ASPECT-ASPECTSAREDERIVED), so a module rooted inside one is no unit of its own: its
                # files fall to the enclosing unit's catch-all.
                $units = @($modules.Where({ $_.shape -cne 'file' -and 'tests' -cnotin $_.root.Split('/') }).ForEach({ $_.root })) +
                @($files.ForEach({ [System.IO.Path]::GetDirectoryName($_.root).Replace('\', '/') }) | Sort-Object -Unique)
            }
            foreach ($unit in $units) {
                foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($aspects, $unit)) {
                    & $add $compiled.Name ([Catzc.Base.Globs.GlobSet]::new((& $setName "$unit-$($compiled.Name)"), "Unit aspect - $unit [$($compiled.Name)]", 'module',
                            [string[]]$compiled.Include, [string[]]$compiled.Exclude, @(), @(), -1, $null))
                }
            }
        }
    }

    $sets = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.IReadOnlyList[Catzc.Base.Globs.GlobSet]]]::new([System.StringComparer]::Ordinal)
    foreach ($name in $AspectSet.Keys) {
        $sets[$name] = [Catzc.Base.Globs.GlobSet[]]@($AspectSet[$name])
    }
    $computed = [Catzc.Base.Globs.AspectPartition]::Cover($sets, [string[]]@($File))
    $cover = [ordered]@{}
    foreach ($name in $AspectSet.Keys) {
        $cover[$name] = $computed[$name]
    }
    $cover
}
