<#
.SYNOPSIS
    Returns the DERIVED globsets — one per module folder plus the reserved infra scopes (ADR-PROTGLOB).
.DESCRIPTION
    Derived sets are never written in globs.yml: the folder is the registration. Every non-dot module folder
    under automation/ derives a set named by the readme-kebab convention (Catzc.Base.Globs ->
    'catzc-base-globs') including 'automation/<Module>/**' — the module's functions, private helpers, types,
    configs, and its own tests. The reserved names cover the dot-prefixed infrastructure every module's test
    results also depend on: 'internal', 'vendor', 'compiled', 'scriptanalyzer'. Derived sets exist for
    protection scoping only — Update-ShaMarker/Test-ShaMarker iterate the declared registry, so a derived set
    never gains a marker file. A declared globset may not shadow a derived name; the collision throws here,
    naming both sides.
.PARAMETER Name
    A module folder name ('Catzc.Base.Globs'), its kebab form ('catzc-base-globs'), or a reserved infra name
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
                @([System.IO.Directory]::EnumerateDirectories($root) |
                        ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                        Where-Object { -not $_.StartsWith('.') }) + [Catzc.Base.Globs.GlobsConfig]::ReservedNames
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
    foreach ($reservedName in [Catzc.Base.Globs.GlobsConfig]::ReservedNames) {
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $reservedName, "Derived infra scope - $($reserved[$reservedName])", @($reserved[$reservedName]), @())
        $derived[$reservedName] = $set
    }

    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($automationRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.')) {
            continue
        }
        $kebab = $moduleName.ToLowerInvariant().Replace('.', '-')
        if ($kebab -in $declaredNames) {
            throw "Declared globset '$kebab' in globs.yml shadows the derived set of module '$moduleName' — derived and declared sets share one name space (ADR-PROTGLOB); rename the declared set."
        }
        $set = [Catzc.Base.Globs.GlobSet]::new(
            $kebab, "Derived module scope - automation/$moduleName/**", @("automation/$moduleName/**"), @())
        $derived[$kebab] = $set
        $derived[$moduleName] = $set
    }

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
        if (-not $derived.Contains($lookupName)) {
            throw "No derived globset for '$lookupName' — expected a module folder under automation/, its kebab name, or one of: $([Catzc.Base.Globs.GlobsConfig]::ReservedNames -join ', ')."
        }
        $derived[$lookupName]
    }
}
