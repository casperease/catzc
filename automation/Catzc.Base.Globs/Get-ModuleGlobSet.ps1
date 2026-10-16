<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
    name: get-module-glob-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
    test: automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
    cites:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-DSGN-ASPECT
      - ADR-DSGN-RUNMODE
      - ADR-FLOW-CD-GLOBS#{7,10}
      - ADR-REPO-PROTGLOB
  config:
    synopsis: |-
      Returns the DERIVED globsets — the live/tests aspect sets per module folder, one set per internal .psm1
      module, the reserved infra umbrellas, and the 'module-leftovers' catch-all.
    description: |-
      Derived sets are never written in globs.yml: the folder (or file) is the registration. Every non-dot
      module folder under automation/ partitions into live/tests aspect sets
      ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)), named by the
      readme-kebab convention plus the aspect (Catzc.Base.Globs -> 'catzc-base-globs-live' and
      'catzc-base-globs-tests') — 'live' the module's shippable surface (functions, private helpers, types,
      configs), 'tests' its verification harness, plus its Go, Python and Bash test folders <root>/tests/<kebab>/ of
      each language root when they exist ([ADR-AUTO-GO#2](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2),
      [ADR-AUTO-PY#2](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py2),
      [ADR-AUTO-BASH#2](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)); the two are disjoint and
      cover the folder. The whole-module
      set is their union (a test-only change never re-keys live). Every internal
      shared module automation/.internal/<Name>.psm1 derives a single-file set (no tests aspect) by the same
      kebab convention (Catzc.Internal.Bootstrap -> 'catzc-internal-bootstrap').
      The reserved names cover the dot-prefixed infrastructure every module's test results also depend on:
      'internal', 'vendor', 'compiled', 'scriptanalyzer'. Derived sets bound the scope of protection and blast radius
      ([ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7)). A declared globset may not
      shadow a derived name; the collision throws here, naming
      both sides.

      The derived sets are repository-relative globs over the source tree's module folders (git-tracked
      paths), so it stops with a named error in build mode (Assert-SourceTree,
      [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      Name: |-
        A module folder name ('Catzc.Base.Globs'), an internal module name ('Catzc.Internal.Bootstrap'), the
        kebab form of either ('catzc-base-globs', 'catzc-internal-bootstrap'), or a reserved infra name
        ('internal', 'vendor', 'compiled', 'scriptanalyzer'). Omit for every derived set.
    examples:
      - Get-ModuleGlobSet -Name Catzc.Base.Globs
      - (Get-ModuleGlobSet -Name compiled).Matches('automation/.compiled/Catzc.Types.abc12345.dll')
---
#>

function Get-ModuleGlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({
                @((Get-CatzcModule -Track (@(Get-Track).Where({ $_.type -ceq 'modules' })[0].name) -IncludeInternal).Where({ $_.shape -ceq 'file' -or $_.place -ceq (@(Get-Track).Where({ $_.type -ceq 'modules' })[0].places[0]) }).name) +
                [Catzc.Base.Globs.GlobsConfig]::ReservedNames
            })]
        [string[]] $Name
    )

    Assert-SourceTree

    # The code track is the track of the modules track type; its first place is the root every module and infra folder sits under.
    $codeTrack = @(Get-Track).Where({ $_.type -ceq 'modules' })[0]
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

    # The per-folder module globs, collected so 'module-leftovers' below can exclude every one of them.
    $moduleFolderGlobs = [System.Collections.Generic.List[string]]::new()
    $repositoryRoot = Get-RepositoryRoot
    $codeModules = @(Get-CatzcModule -Track $codeTrack.name -IncludeInternal -RepositoryRoot $repositoryRoot)
    foreach ($module in $codeModules.Where({ $_.shape -ceq 'folder' -and $_.place -ceq $codeRoot })) {
        $moduleName = $module.name
        $kebab = $moduleName.ToLowerInvariant().Replace('.', '-')
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
            if ($compiled.Name -eq 'tests') {
                $include += "$goRoot/tests/$kebab/**"
                $include += "$pythonRoot/tests/$kebab/**"
                $include += "$bashRoot/tests/$kebab/**"
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
        $kebab = $internalName.ToLowerInvariant().Replace('.', '-')
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
            throw "No derived globset for '$lookupName' — expected a module folder under automation/ (bare name -> its aspects, or '<module>-live'/'<module>-tests'), an internal module (automation/.internal/<Name>.psm1), the kebab name of either, or one of: $([Catzc.Base.Globs.GlobsConfig]::ReservedNames -join ', ')."
        }
    }
}
