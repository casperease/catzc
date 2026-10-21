<#
---
catzc:
  immutable:
    with_body_sha: "3680f939db71"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
    docs: "[Get-ModuleGlobSet.ps1.md](docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md)"
    cites:
      - ADR-AUTO-BASH-ONEBASHROOT
      - ADR-AUTO-GO-ONEGOROOT
      - ADR-AUTO-PY-ONEPYTHONROOT
      - ADR-REPO-PROTGLOB
      - DDR-ASPECT
      - DDR-RUNMODE
      - FDR-CD-GLOBS-EVERYSETHASLAYER
      - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
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

    # The code track is the one whose place is the catzc modules folder; its first place is the root every module and infra folder sits under.
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
    foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $reservedName, "Derived infra scope - $($reserved[$reservedName])", 'loose-fileset',
            @($reserved[$reservedName]), @(), @(), @(), -1, $null)
        $derived[$reservedName] = $set
    }

    $aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
    foreach ($aspectDef in Get-Aspect -Track $codeTrack.name) {
        $aspectList.Add([Catzc.Base.Globs.Aspect]::new($aspectDef.Name, [string[]]$aspectDef.Patterns))
    }
    # bare module name/kebab -> its aspect sets, so a caller can ask for "the module" and get both aspects.
    $moduleAspects = @{}
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
            # Each language's test folder for the module, named in that language's folder case.
            if ($compiled.Name -eq 'tests') {
                $include += "$goRoot/tests/$($languages.TestFolderOf('go', $moduleName))/**"
                $include += "$pythonRoot/tests/$($languages.TestFolderOf('python', $moduleName))/**"
                $include += "$bashRoot/tests/$($languages.TestFolderOf('bash', $moduleName))/**"
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

    if ('module-leftovers' -in $declaredNames) {
        throw "Declared globset 'module-leftovers' in globs.yml shadows the derived module-space catch-all — derived and declared sets share one name space (ADR-REPO-PROTGLOB); rename the declared set."
    }
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
