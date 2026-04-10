<#
.SYNOPSIS
    Validates configs/files.yml: a 'modules' map binding modules to named packages of file artifacts.
.DESCRIPTION
    Convention validator for `Get-Config -Config files` (named Assert-<Name>Config, run in the owning module's
    scope). files.yml declares, per module, the packages Copy-Automation can copy. Asserts:

      - a required, non-empty top-level 'modules' map
      - each module entry is a map with a non-empty 'packages' map
      - each package name is snake_case and globally unique across all modules (the -ExcludePackages unit)
      - each package is a non-empty list of non-empty path strings (not a single string)

    Module keys are NOT snake_case (they are module folder names — 'Catzc.Base.Repository', '.internal'), so
    Assert-YmlNaming is not used; only package names are naming-checked. A malformed file throws at read time.
.PARAMETER Config
    The parsed files.yml (ordered dictionary from ConvertFrom-Yaml -Ordered).
.EXAMPLE
    Assert-FilesConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-FilesConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('modules')) {
        throw "files configuration validation failed:`nMissing required top-level key: 'modules'"
    }
    $modules = $Config['modules']
    if (-not ($modules -is [System.Collections.IDictionary]) -or $modules.Count -eq 0) {
        throw "files configuration validation failed:`n'modules' must be a non-empty map of <module>: { packages: ... }"
    }

    $errors = [System.Collections.Generic.List[string]]::new()
    $seenPackages = @{}
    foreach ($moduleName in @($modules.Keys)) {
        $entry = $modules[$moduleName]
        if (-not ($entry -is [System.Collections.IDictionary]) -or -not $entry.Contains('packages')) {
            $errors.Add("module '$moduleName' must be a map with a 'packages' key")
            continue
        }
        $packages = $entry['packages']
        if (-not ($packages -is [System.Collections.IDictionary]) -or $packages.Count -eq 0) {
            $errors.Add("module '$moduleName' 'packages' must be a non-empty map")
            continue
        }
        foreach ($packageName in @($packages.Keys)) {
            if ("$packageName" -cnotmatch '^[a-z][a-z0-9_]*$') {
                $errors.Add("package '$packageName' (module '$moduleName') must be snake_case")
            }
            if ($seenPackages.ContainsKey("$packageName")) {
                $errors.Add("duplicate package name '$packageName' (in '$moduleName' and '$($seenPackages["$packageName"])')")
            }
            else {
                $seenPackages["$packageName"] = "$moduleName"
            }
            $paths = $packages[$packageName]
            if ($paths -is [string] -or -not ($paths -is [System.Collections.IList]) -or @($paths).Count -eq 0) {
                $errors.Add("package '$packageName' must be a non-empty list of paths")
                continue
            }
            foreach ($path in $paths) {
                if ([string]::IsNullOrWhiteSpace([string] $path)) {
                    $errors.Add("package '$packageName' has an empty path entry")
                }
            }
        }
    }

    if ($errors.Count -gt 0) {
        throw "files configuration validation failed:`n$($errors -join "`n")"
    }
}
