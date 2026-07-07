<#
.SYNOPSIS
    Returns the DERIVED globsets — the live/tests aspect sets per module folder, one set per internal .psm1
    module, the reserved infra umbrellas, and the 'module-leftovers' catch-all (ADR-PROTGLOB, ADR-ASPECT).
.DESCRIPTION
    Derived sets are never written in globs.yml: the folder (or file) is the registration. Every non-dot
    module folder under automation/ partitions into live/tests aspect sets (ADR-ASPECT), named by the
    readme-kebab convention plus the aspect (Catzc.Base.Globs -> 'catzc-base-globs-live' and
    'catzc-base-globs-tests') — 'live' the module's shippable surface (functions, private helpers, types,
    configs), 'tests' its verification harness; the two are disjoint and cover the folder. The whole-module
    set is their union and is NOT persisted — the aspect markers ARE the module's identity. Every internal
    shared module automation/.internal/<Name>.psm1 derives a single-file set (no tests aspect) by the same
    kebab convention (Catzc.Internal.Bootstrap -> 'catzc-internal-bootstrap').
    The reserved names cover the dot-prefixed infrastructure every module's test results also depend on:
    'internal', 'vendor', 'compiled', 'scriptanalyzer'. Derived sets scope protection AND persist their own
    sha-markers — Update-ShaMarker/Test-ShaMarker iterate the declared registry and the derived sets alike
    (ADR-PROTGLOB:7). A declared globset may not shadow a derived name; the collision throws here, naming
    both sides.
.PARAMETER Name
    A module folder name ('Catzc.Base.Globs'), an internal module name ('Catzc.Internal.Bootstrap'), the
    kebab form of either ('catzc-base-globs', 'catzc-internal-bootstrap'), or a reserved infra name
    ('internal', 'vendor', 'compiled', 'scriptanalyzer'). Omit for every derived set.
.EXAMPLE
    Get-ModuleGlobSet -Name Catzc.Base.Globs
.EXAMPLE
    (Get-ModuleGlobSet -Name compiled).Matches('automation/.compiled/Catzc.Types.abc12345.dll')
#>
function Get-ModuleGlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({
                $root = Join-Path (Get-RepositoryRoot) 'automation'
                $internal = Join-Path $root '.internal'
                @([System.IO.Directory]::EnumerateDirectories($root) |
                        ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                        Where-Object { -not $_.StartsWith('.') }) +
                @([System.IO.Directory]::EnumerateFiles($internal, '*.psm1') |
                        ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) }) +
                [Catzc.Base.Globs.GlobsConfig]::ReservedNames
            })]
        [string[]] $Name
    )

    $automationRoot = [System.IO.Path]::Combine((Get-RepositoryRoot), 'automation')
    $declaredNames = (Get-Config -Config globs).Names

    # name -> GlobSet, both the kebab name and (for modules) the folder name as lookup keys
    $derived = [ordered]@{}
    $reserved = @{
        'internal'       = 'automation/.internal/**'
        'vendor'         = 'automation/.vendor/**'
        'compiled'       = 'automation/.compiled/**'
        'scriptanalyzer' = 'automation/.scriptanalyzer/**'
    }
    # The reserved umbrellas are cross-cutting check surfaces, not independent modules: 'internal' overlaps
    # every catzc-internal-* single-file set, 'vendor'/'compiled'/'scriptanalyzer' cover whole dot-folders.
    # They are loose-filesets (ADR-GLOBS:7, overlap-exempt), not the 'module' layer whose sets are the
    # pairwise-disjoint per-folder modules (ADR-GLOBS:10).
    foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $reservedName, "Derived infra scope - $($reserved[$reservedName])", 'loose-fileset',
            @($reserved[$reservedName]), @(), @(), @(), -1, $null)
        $derived[$reservedName] = $set
    }

    # The aspect convention (ADR-ASPECT): each module folder partitions into disjoint, exhaustive aspect sets
    # (live/tests by default) from the 'aspects' variant. The whole-module set is the union of its aspects and
    # is NOT persisted — the aspect markers ARE the module's identity (a shipped module = 1 live + 1 tests,
    # isolated: a test-only change never re-keys live). Compiled per unit root by AspectPartition.
    $aspectList = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
    foreach ($aspectDef in Get-Aspect -Track automation) {
        $aspectList.Add([Catzc.Base.Globs.Aspect]::new($aspectDef.Name, [string[]]$aspectDef.Patterns))
    }
    # bare module name/kebab -> its aspect sets, so a caller can ask for "the module" and get both aspects.
    $moduleAspects = @{}

    # The per-folder module globs, collected so 'module-leftovers' below can exclude every one of them.
    $moduleFolderGlobs = [System.Collections.Generic.List[string]]::new()
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($automationRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.')) {
            continue
        }
        $kebab = $moduleName.ToLowerInvariant().Replace('.', '-')
        if ($kebab -in $declaredNames) {
            throw "Declared globset '$kebab' in globs.yml shadows the derived module '$moduleName' — derived and declared sets share one name space (ADR-PROTGLOB); rename the declared set."
        }
        $moduleFolderGlobs.Add("automation/$moduleName/**")
        $aspectSets = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
        foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($aspectList, "automation/$moduleName")) {
            $aspectKebab = "$kebab-$($compiled.Name)"
            if ($aspectKebab -in $declaredNames) {
                throw "Declared globset '$aspectKebab' in globs.yml shadows the derived aspect of module '$moduleName' — derived and declared sets share one name space (ADR-PROTGLOB); rename the declared set."
            }
            $set = [Catzc.Base.Globs.GlobSet]::new(
                $aspectKebab, "Derived module aspect - automation/$moduleName [$($compiled.Name)]", 'module',
                $compiled.Include, $compiled.Exclude, @(), @(), -1, $null)
            $derived[$aspectKebab] = $set
            $derived["$moduleName-$($compiled.Name)"] = $set
            $aspectSets.Add($set)
        }
        $moduleAspects[$kebab] = $aspectSets
        $moduleAspects[$moduleName] = $aspectSets
    }

    # The internal shared modules: one single-file set per automation/.internal/<Name>.psm1 — the file is
    # the registration, exactly as the folder is for a module. The whole-folder 'internal' scope above
    # remains the protection dependency; these carry the per-module identity.
    $internalRoot = [System.IO.Path]::Combine($automationRoot, '.internal')
    if ([System.IO.Directory]::Exists($internalRoot)) {
        foreach ($internalFile in [System.IO.Directory]::EnumerateFiles($internalRoot, '*.psm1')) {
            $internalName = [System.IO.Path]::GetFileNameWithoutExtension($internalFile)
            $kebab = $internalName.ToLowerInvariant().Replace('.', '-')
            if ($kebab -in $declaredNames) {
                throw "Declared globset '$kebab' in globs.yml shadows the derived set of internal module '$internalName' — derived and declared sets share one name space (ADR-PROTGLOB); rename the declared set."
            }
            $set = [Catzc.Base.Globs.GlobSet]::new(
                $kebab, "Derived internal-module scope - automation/.internal/$internalName.psm1", 'module',
                @("automation/.internal/$internalName.psm1"), @(), @(), @(), -1, $null)
            $derived[$kebab] = $set
            $derived[$internalName] = $set
        }
    }

    # The module layer's catch-all: every tracked file under automation/ that no per-folder module owns and
    # that is not dot-folder infrastructure (the reserved umbrellas' loose-fileset territory). It exists so
    # the module layer covers module-space and a stray file cannot go unmapped — it should be empty in a
    # clean tree, but stuff can pop up (a file dropped at automation/'s root, a folder not yet a module). Its
    # OWN excludes are every module folder plus the four dot-folders, so it stays disjoint from every module
    # set (ADR-GLOBS:10). Derived, module-layer, never declared; a declared set may not shadow it.
    if ('module-leftovers' -in $declaredNames) {
        throw "Declared globset 'module-leftovers' in globs.yml shadows the derived module-space catch-all — derived and declared sets share one name space (ADR-PROTGLOB); rename the declared set."
    }
    # Ordinal-sorted so the scan program (the marker body) is byte-identical on every machine, independent of
    # directory-enumeration and hashtable order.
    $leftoverExcludes = @($moduleFolderGlobs) + @($reserved.Values)
    [System.Array]::Sort($leftoverExcludes, [System.StringComparer]::Ordinal)
    $derived['module-leftovers'] = [Catzc.Base.Globs.GlobSet]::new(
        'module-leftovers', 'Derived module-space catch-all - automation/ files no module owns', 'module',
        @('automation/**'), $leftoverExcludes, @(), @(), -1, $null)

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
