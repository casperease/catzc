<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md"
  header: "generated"
---
#>

function Get-ModuleGlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({
                $code = Get-Track -Path (Get-CatzcModulesFolder)
                @((Get-CatzcModule -Track $code.name -IncludeInternal).Where({ $_.shape -ceq 'file' -or $_.place -ceq $code.places[0] }).name) +
                [Catzc.Base.Globs.GlobsConfig]::ReservedNames
            })]
        [string[]] $Name
    )

    Assert-SourceTree

    # The code track's place is the modules folder; its first place is the root every module sits under.
    $codeTrack = Get-Track -Path (Get-CatzcModulesFolder)
    $codeRoot = $codeTrack.places[0]
    $config = Get-Config -Config globs
    $declaredNames = $config.Names

    # name -> GlobSet, both the kebab name and (for modules) the folder name as lookup keys
    $derived = [ordered]@{}
    $reserved = @{
        'internal'       = "$codeRoot/.internal/**"
        'vendor'         = "$codeRoot/.vendor/**"
        'compiled'       = "$codeRoot/.compiled/**"
        'scriptanalyzer' = "$codeRoot/.scriptanalyzer/**"
    }
    # The reserved umbrellas are overlap-exempt loose filesets, not module-layer sets.
    foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $reservedName, "Derived infra scope - $($reserved[$reservedName])", 'loose-fileset',
            @($reserved[$reservedName]), @(), @(), @(), -1, $null)
        $derived[$reservedName] = $set
    }

    # Each module folder partitions into disjoint, exhaustive aspect sets, so a test-only change never re-keys live.
    $aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
    foreach ($aspectDef in Get-Aspect -Track $codeTrack.name) {
        $aspectList.Add([Catzc.Base.Globs.Aspect]::new($aspectDef.Name, [string[]]$aspectDef.Patterns))
    }
    # bare module name/kebab -> its aspect sets, so a caller can ask for "the module" and get both aspects.
    $moduleAspects = @{}
    # A module's Go, Python and Bash test folders belong to its tests aspect, never its live one.
    $goRoot = (Get-Config -Config go).ResolveRoot((Get-RepositoryRoot))
    $pythonRoot = (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
    $bashRoot = (Get-Config -Config bash).ResolveRoot((Get-RepositoryRoot))
    $languages = Get-Config -Config languages

    # The per-folder module globs, collected so 'module-leftovers' below can exclude every one of them.
    $moduleFolderGlobs = [System.Collections.Generic.List[string]]::new()
    $repositoryRoot = Get-RepositoryRoot
    $codeModules = @(Get-CatzcModule -Track $codeTrack.name -IncludeInternal -RepositoryRoot $repositoryRoot)
    foreach ($module in $codeModules.Where({ $_.shape -ceq 'folder' -and $_.place -ceq $codeRoot })) {
        $moduleName = $module.name
        $kebab = [Catzc.Base.Objects.NameCase]::Render($moduleName, 'kebab')
        if ($kebab -in $declaredNames) {
            throw "Declared globset '$kebab' in globs.yml shadows the derived module '$moduleName' — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
        }
        $moduleFolderGlobs.Add("$($module.root)/**")
        $aspectSets = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
        foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($aspectList, $module.root)) {
            $aspectKebab = "$kebab-$($compiled.Name)"
            if ($aspectKebab -in $declaredNames) {
                throw "Declared globset '$aspectKebab' in globs.yml shadows the derived aspect of module '$moduleName' — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
            }
            $include = [string[]]$compiled.Include
            # Each language's test folder is named from the module's folder, in that language's folder case.
            if ($compiled.Name -eq 'tests') {
                $folder = [System.IO.Path]::GetFileName($module.root)
                # The module's folder carries no namespace to drop, so no tracks are passed.
                $include += "$goRoot/tests/$($languages.TestFolderOf('go', $null, $folder))/**"
                $include += "$pythonRoot/tests/$($languages.TestFolderOf('python', $null, $folder))/**"
                $include += "$bashRoot/tests/$($languages.TestFolderOf('bash', $null, $folder))/**"
            }
            $set = [Catzc.Base.Globs.GlobSet]::new(
                $aspectKebab, "Derived module aspect - $($module.root) [$($compiled.Name)]", 'module',
                $include, $compiled.Exclude, @(), @(), -1, $null)
            $derived[$aspectKebab] = $set
            $derived["$moduleName-$($compiled.Name)"] = $set
            $aspectSets.Add($set)
        }
        $moduleAspects[$kebab] = $aspectSets
        $moduleAspects[$moduleName] = $aspectSets
    }

    # An internal shared module's .psm1 is its registration, so it gets a single-file set of its own.
    foreach ($module in $codeModules.Where({ $_.shape -ceq 'file' })) {
        $internalName = $module.name
        $kebab = [Catzc.Base.Objects.NameCase]::Render($internalName, 'kebab')
        if ($kebab -in $declaredNames) {
            throw "Declared globset '$kebab' in globs.yml shadows the derived set of internal module '$internalName' — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
        }
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $kebab, "Derived internal-module scope - $($module.root)", 'module',
            @($module.root), @(), @(), @(), -1, $null)
        $derived[$kebab] = $set
        $derived[$internalName] = $set
    }

    # A reserved umbrella is a unit too: its root .psm1 files are live, the rest tests.
    $scopeAspects = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
    foreach ($aspect in $aspectList) {
        $patterns = [string[]]@($aspect.Patterns)
        if ($aspect.Name -ceq 'live') {
            $patterns += '*.psm1'
        }
        $scopeAspects.Add([Catzc.Base.Globs.Aspect]::new($aspect.Name, $patterns))
    }
    foreach ($scope in '.internal', '.scriptanalyzer') {
        $scopeRoot = "$codeRoot/$scope"
        $fileRoots = [string[]]@($codeModules.Where({ $_.shape -ceq 'file' -and $_.root.StartsWith("$scopeRoot/",
                        [System.StringComparison]::Ordinal) }).ForEach({ $_.root }))
        foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($scopeAspects, $scopeRoot)) {
            $scopeName = "$($scope.TrimStart('.'))-$($compiled.Name)"
            if ($scopeName -in $declaredNames) {
                throw "Declared globset '$scopeName' in globs.yml shadows the derived aspect of '$scopeRoot', a name the derived sets reserve — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
            }
            $derived[$scopeName] = [Catzc.Base.Globs.GlobSet]::new(
                $scopeName, "Derived scope aspect - $scopeRoot [$($compiled.Name)]", 'module',
                [string[]]$compiled.Include, [string[]](@($compiled.Exclude) + $fileRoots), @(), @(), -1, $null)
        }
    }

    # Other laid-out tracks partition by their own convention; their root holder is no unit.
    foreach ($track in @(Get-Track).Where({ $_.name -cne $codeTrack.name -and $languages.IsLaidOut($_.languages) })) {
        $trackAspects = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
        foreach ($aspectDef in Get-Aspect -Track $track.name) {
            $trackAspects.Add([Catzc.Base.Globs.Aspect]::new($aspectDef.Name, [string[]]$aspectDef.Patterns))
        }
        foreach ($module in @(Get-CatzcModule -Track $track.name -RepositoryRoot $repositoryRoot).Where({ $_.shape -ceq 'folder' })) {
            $kebab = [Catzc.Base.Objects.NameCase]::Render($module.name, 'kebab')
            $aspectSets = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
            foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($trackAspects, $module.root)) {
                $aspectKebab = "$kebab-$($compiled.Name)"
                if ($aspectKebab -in $declaredNames) {
                    throw "Declared globset '$aspectKebab' in globs.yml shadows the derived aspect of module '$($module.name)' — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
                }
                $set = [Catzc.Base.Globs.GlobSet]::new(
                    $aspectKebab, "Derived module aspect - $($module.root) [$($compiled.Name)]", 'module',
                    [string[]]$compiled.Include, [string[]]$compiled.Exclude, @(), @(), -1, $null)
                $derived[$aspectKebab] = $set
                $aspectSets.Add($set)
            }
            $moduleAspects[$kebab] = $aspectSets
            $moduleAspects[$module.name] = $aspectSets
        }
    }

    # The module layer's catch-all for a stray file under the modules folder; empty in a clean tree.
    if ('module-leftovers' -in $declaredNames) {
        throw "Declared globset 'module-leftovers' in globs.yml shadows the derived module-space catch-all — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
    }
    # Sorted ordinally, so the marker body is byte-identical on every machine.
    $leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)
    [System.Array]::Sort($leftoverExcludes, [System.StringComparer]::Ordinal)
    $derived['module-leftovers'] = [Catzc.Base.Globs.GlobSet]::new(
        'module-leftovers', "Derived module-space catch-all - $codeRoot/ files no module owns", 'module',
        @("$codeRoot/**"), $leftoverExcludes, @(), @(), -1, $null)

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        # every set once — module sets are keyed twice (kebab + folder), so de-duplicate by reference
        $seen = [System.Collections.Generic.HashSet[object]]::new()
        foreach ($set in $derived.Values) {
            if ($seen.Add($set)) {
                $set
            }
        }
        return
    }

    foreach ($lookupName in $Name) {
        if ($derived.Contains($lookupName)) {
            $derived[$lookupName]
        }
        elseif ($moduleAspects.ContainsKey($lookupName)) {
            # a bare module name/kebab -> both aspect sets ('<module>-live', '<module>-tests')
            $moduleAspects[$lookupName]
        }
        else {
            throw "No derived globset for '$lookupName' — expected a module folder under the modules folder (bare name -> its aspects, or '<module>-live'/'<module>-tests'), an internal module (.internal/<Name>.psm1 there), the kebab name of either, or one of: $([Catzc.Base.Globs.GlobsConfig]::ReservedNames -join ', ')."
        }
    }
}
