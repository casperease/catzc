<#
.SYNOPSIS
    Loads, validates, and caches a module's config by its global lowercase name.
.DESCRIPTION
    The single reader for any module's internal config (configs/<name>.yml). Existence is discovered by
    scanning <module>/configs/ under the loaded code root, Get-CatzcModulesRoot (cached, via
    Resolve-ConfigEntry); -Module disambiguates the rare case of the same config name in two modules. The parsed config (ConvertFrom-Yaml -Ordered) is cached per resolved
    path for the session (re-run the importer to clear) and the same reference is returned on repeat calls.

    A config registered in configs/configs.yml (`<name>: { type: <C# FQN> }`) is constructed as
    [type]::new($dict), which maps and validates it; every shipped config is registered (Test-ShippedConfigs).
    An unregistered config — a fixture, or one a PowerShell validator checks through Invoke-ConfigValidator
    (Catzc.Base.ConfigExtensions) — is returned raw, as the ordered dictionary. See ADR module-config-loading.

    -ListOwners loads nothing: it lists every module that ships the config, as @{ Name; Module; Path } sorted
    by module name (ordinal), and nothing when none does. A config several modules opt into by shipping it
    (glossary) is read by listing its owners and then reading each with -Module.
.PARAMETER Config
    The config's global lowercase name (kebab-case), without the .yml extension — e.g. 'ado', 'pipeline-env'.
.PARAMETER Module
    Disambiguates when the same config name exists in more than one module.
.PARAMETER ListOwners
    Lists the owning modules' entries instead of loading the config.
.EXAMPLE
    (Get-Config -Config ado).organization
.EXAMPLE
    Get-Config -Config tools
.EXAMPLE
    Get-Config -Config glossary -ListOwners | ForEach-Object { Get-Config -Config glossary -Module $_.Module }
#>
function Get-Config {
    [CmdletBinding(DefaultParameterSetName = 'Load')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Config,

        [Parameter(ParameterSetName = 'Load')]
        [string] $Module,

        [Parameter(Mandatory, ParameterSetName = 'ListOwners')]
        [switch] $ListOwners
    )

    if ($ListOwners) {
        return Resolve-ConfigEntry -Config $Config -All
    }

    $entry = Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        # strict-clean probe of the lazy cache entry
        # ([ADR-AUTO-PSCACHE#4](/docs/adr/automation/powershell/script-scope-caching.md#rule-adr-auto-pscache4))
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($entry.Path)) {
        return $script:configCache[$entry.Path]
    }

    Assert-PathExist $entry.Path
    $raw = Get-Content $entry.Path -Raw | ConvertFrom-Yaml -Ordered

    $ret = $raw
    $registered = (Get-ConfigRegistry)[$entry.Name]
    if ($registered) {
        # The registered C# type maps and validates the parsed dictionary at construction.
        $type = [type] $registered['type']
        $ret = $type::new($raw)
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $($entry.Path)"
    $script:configCache[$entry.Path] = $ret
    $script:configCache[$entry.Path]
}
