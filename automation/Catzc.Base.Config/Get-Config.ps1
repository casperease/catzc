<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/Get-Config.ps1
    kind: function
    module: Catzc.Base.Config
    visibility: public
    adrs:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-CACHE#4
---
#>

<#
.SYNOPSIS
    Loads, validates, and caches a module's config by its global lowercase name.
.DESCRIPTION
    The parsed config is cached per path for the session, so every repeat call returns the same reference.
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

    # The cache key carries the fragment's stamp, so an edited fragment is never served from a stale merge.
    # [comment:2](/docs/references/automation/catzc-base-config/Get-Config.ps1.md#comment2)
    $fragmentPath = $null
    $cacheKey = $entry.Path
    $overlayRoot = Get-ConfigOverlayRoot
    if ($overlayRoot) {
        $candidate = [System.IO.Path]::Combine($overlayRoot, $entry.Module, 'configs', "$($entry.Name).yml")
        if ([System.IO.File]::Exists($candidate)) {
            $fragmentPath = $candidate
            $stamp = [System.IO.FileInfo]::new($candidate)
            $cacheKey = "$($entry.Path)|$candidate|$($stamp.LastWriteTimeUtc.Ticks)|$($stamp.Length)"
        }
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        # Probe through session state, not the bare variable, so strict mode does not throw before the first load.
        # [comment:3](/docs/references/automation/catzc-base-config/Get-Config.ps1.md#comment3)
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($cacheKey)) {
        return $script:configCache[$cacheKey]
    }

    Assert-PathExist $entry.Path
    $raw = Get-Content $entry.Path -Raw | ConvertFrom-Yaml -Ordered

    $registered = (Get-ConfigRegistry)[$entry.Name]
    if ($fragmentPath) {
        if ($registered -and $registered.Contains('overridable') -and $registered['overridable'] -eq $false) {
            throw "Config '$($entry.Name)' is sealed (configs.yml overridable: false), so the overlay may not change it: remove $fragmentPath."
        }
        $fragment = Get-Content $fragmentPath -Raw | ConvertFrom-Yaml -Ordered
        Assert-True ($raw -is [System.Collections.IDictionary] -and ($null -eq $fragment -or $fragment -is [System.Collections.IDictionary])) -ErrorText "Overlay fragment $fragmentPath cannot merge onto config '$($entry.Name)': a fragment and its config must both be maps."
        if ($null -ne $fragment) {
            $raw = Merge-ConfigFragment -Base $raw -Fragment $fragment
        }
        Write-Verbose "Merged overlay fragment '$fragmentPath' onto config '$($entry.Name)'"
    }

    $ret = $raw
    if ($registered) {
        # The registered C# type maps and validates the parsed dictionary at construction.
        $type = [type] $registered['type']
        $ret = $type::new($raw)
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $($entry.Path)"
    $script:configCache[$cacheKey] = $ret
    $script:configCache[$cacheKey]
}
