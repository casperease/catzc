<#
.SYNOPSIS
    Loads, validates, and caches a module's config by its global lowercase name.
.DESCRIPTION
    The single reader for any module's internal config (configs/<name>.yml). Existence is discovered by
    scanning automation/*/configs/ (cached, via Resolve-ConfigEntry); -Module disambiguates the rare case of
    the same config name in two modules. The parsed config (ConvertFrom-Yaml -Ordered) is cached per resolved
    path for the session (re-run the importer to clear) and the same reference is returned on repeat calls.

    Validation/mapping is resolved against the OWNING module (from discovery), in this order:
      1. Registry override (configs/configs.yml): `<name>: { type: <C# FQN> }` constructs [type]::new($dict)
         (maps + validates); `<name>: { pwsh: <Fn> }` runs that function in the owner's scope.
      2. Convention: a private Assert-<TitleCase(name)>Config in the owner module, run in the owner's scope.
      3. Raw: neither → the ordered dictionary, unvalidated (the sensible default).
    Resolution always targets the owner module (`& (Get-Module $owner) { … }`), so validators stay private
    and the result is the same no matter which module called Get-Config. See ADR module-config-loading.
.PARAMETER Config
    The config's global lowercase name (kebab-case), without the .yml extension — e.g. 'ado', 'pipeline-env'.
.PARAMETER Module
    Disambiguates when the same config name exists in more than one module.
.EXAMPLE
    (Get-Config -Config ado).organization
.EXAMPLE
    Get-Config -Config tools
#>
function Get-Config {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Config,

        [string] $Module
    )

    $entry = Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path }

    if (-not $script:configCache) {
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($entry.Path)) {
        return $script:configCache[$entry.Path]
    }

    Assert-PathExist $entry.Path
    $raw = Get-Content $entry.Path -Raw | ConvertFrom-Yaml -Ordered

    $owner = Get-Module $entry.Module
    if (-not $owner) {
        throw "Config '$($entry.Name)': owning module '$($entry.Module)' is not loaded."
    }

    $ret = $raw
    $override = (Get-ConfigRegistry)[$entry.Name]
    if ($override) {
        # Registry override (advanced): a C# type (maps + validates) or a custom-named pwsh validator.
        if ($override.Contains('type') -and $override['type']) {
            $type = [type] $override['type']
            $ret = $type::new($raw)
        }
        elseif ($override.Contains('pwsh') -and $override['pwsh']) {
            & $owner { param($fn, $c) & $fn $c } $override['pwsh'] $raw
        }
    }
    else {
        # Convention: Assert-<TitleCase(name)>Config in the owner's scope (private), if it exists.
        $titleName = -join ($entry.Name -split '-' | ForEach-Object {
                [cultureinfo]::InvariantCulture.TextInfo.ToTitleCase($_)
            })
        $convName = "Assert-${titleName}Config"
        & $owner {
            param($fn, $c)
            if (Get-Command $fn -CommandType Function -ErrorAction Ignore) {
                & $fn $c
            }
        } $convName $raw
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $($entry.Path)"
    $script:configCache[$entry.Path] = $ret
    $script:configCache[$entry.Path]
}
