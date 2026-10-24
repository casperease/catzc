function Get-AspectCover {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        # The tracked files the cover is computed over; the git index by default.
        [string[]] $File,

        # Aspect name to the globsets of that aspect, one per unit; every module's aspect sets and every track's declared aspects by default.
        [System.Collections.IDictionary] $AspectSet
    )

    if (-not $PSBoundParameters.ContainsKey('File')) {
        $File = @(Get-TrackedFile)
    }
    if (-not $PSBoundParameters.ContainsKey('AspectSet')) {
        $AspectSet = [ordered]@{}
        $codeTrack = Get-Track -Path (Get-CatzcModulesFolder)
        $moduleSets = @(Get-ModuleGlobSet).Where({ $_.Layer -ceq 'module' })
        foreach ($aspect in Get-Aspect -Track $codeTrack.name) {
            $AspectSet[$aspect.Name] = @($moduleSets.Where({ $_.Name.EndsWith("-$($aspect.Name)", [System.StringComparison]::Ordinal) }))
        }
        # A track that declares its own aspects (a deployment track) is one unit per place.
        $declared = Get-AspectDeclaration
        foreach ($track in @(Get-Track).Where({ $_.name -cne $codeTrack.name -and $declared.ContainsKey($_.name) })) {
            $aspects = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
            foreach ($aspect in $declared[$track.name]) {
                $aspects.Add([Catzc.Base.Globs.Aspect]::new($aspect.Name, [string[]]$aspect.Patterns))
            }
            foreach ($place in $track.places) {
                foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($aspects, $place)) {
                    $set = [Catzc.Base.Globs.GlobSet]::new("$($track.name)-$($compiled.Name)", "Track aspect - $place [$($compiled.Name)]", 'module',
                        [string[]]$compiled.Include, [string[]]$compiled.Exclude, @(), @(), -1, $null)
                    $AspectSet[$compiled.Name] = @($AspectSet[$compiled.Name]) + $set | Where-Object { $null -ne $_ }
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
