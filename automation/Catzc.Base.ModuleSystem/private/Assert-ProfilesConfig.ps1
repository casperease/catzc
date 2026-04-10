<#
.SYNOPSIS
    Validates configs/profiles.yml: a 'profiles' map of snake_case names to module-name lists.
.DESCRIPTION
    Convention validator for `Get-Config -Config profiles` (named Assert-<Name>Config, run in the owning
    module's scope). Asserts:

      - snake_case profile names (Assert-YmlNaming — it checks keys only, so the module-name list VALUES, which
        carry dots and PascalCase, are not naming-checked)
      - a required, non-empty top-level 'profiles' map
      - each profile is a list of module names (possibly empty — an empty seed means "the full repo"), never a
        single string

    Module-name existence is not checked here (it is Get-ModuleProfile's concern), matching how files.yml
    validates shape but not module existence.
.PARAMETER Config
    The parsed profiles.yml (ordered dictionary from ConvertFrom-Yaml -Ordered).
.EXAMPLE
    Assert-ProfilesConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-ProfilesConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-YmlNaming $Config

    if (-not $Config.Contains('profiles')) {
        throw "profiles configuration validation failed:`nMissing required top-level key: 'profiles'"
    }
    $profiles = $Config['profiles']
    if (-not ($profiles -is [System.Collections.IDictionary]) -or $profiles.Count -eq 0) {
        throw "profiles configuration validation failed:`n'profiles' must be a non-empty map of <name>: [ <module>, ... ]"
    }

    $errors = [System.Collections.Generic.List[string]]::new()
    foreach ($name in @($profiles.Keys)) {
        $seed = $profiles[$name]
        # A list (including empty) is valid; a single string or a map is not.
        if ($seed -is [string] -or ($null -ne $seed -and -not ($seed -is [System.Collections.IList]))) {
            $errors.Add("profile '$name' must be a list of module names (possibly empty), not a single value")
        }
    }

    if ($errors.Count -gt 0) {
        throw "profiles configuration validation failed:`n$($errors -join "`n")"
    }
}
