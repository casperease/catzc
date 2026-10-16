<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/Get-Config.ps1
    name: get-config
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-config/Get-Config.ps1.md
    test: automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
    cites:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-CACHE#4
  config:
    synopsis: Loads, validates, and caches a module's config by its global lowercase name.
    description: |-
      The single reader for any module's internal config (configs/<name>.yml). Existence is discovered by
      scanning <module>/configs/ under the loaded code root, Get-CatzcModulesRoot (cached, via
      Resolve-ConfigEntry); -Module disambiguates the rare case of the same config name in two modules. The parsed
      config (ConvertFrom-Yaml -Ordered) is cached per resolved path for the session (re-run the importer to clear)
      and the same reference is returned on repeat calls.

      A config registered in configs/configs.yml (`<name>: { type: <C# FQN> }`) is constructed as
      [type]::new($dict), which maps and validates it; every shipped config is registered (Test-ShippedConfigs).
      An unregistered config — a fixture, or one a PowerShell validator checks through Invoke-ConfigValidator
      (Catzc.Base.ConfigExtensions) — is returned raw, as the ordered dictionary. See ADR module-config-loading.

      In build mode, a consumer overlay may hold a fragment of the config at
      <RepositoryRoot>/.catzc/automation/<Module>/configs/<name>.yml. The fragment is merged onto the bundled config
      before the type validates it (Merge-ConfigFragment: maps merge, scalars and lists replace, null resets a key to
      its declared default), so a setting resolves caller → overlay fragment → bundled config → type default. A
      sealed config (configs.yml overridable: false) refuses a fragment.

      -ListOwners loads nothing: it lists every module that ships the config, as @{ Name; Module; Path } sorted
      by module name (ordinal), and nothing when none does. A config several modules opt into by shipping it
      (glossary) is read by listing its owners and then reading each with -Module.
    parameters:
      Config: The config's global lowercase name (kebab-case), without the .yml extension — e.g. 'ado', 'pipeline-env'.
      Module: Disambiguates when the same config name exists in more than one module.
      ListOwners: Lists the owning modules' entries instead of loading the config.
    examples:
      - (Get-Config -Config ado).organization
      - Get-Config -Config tools
      - Get-Config -Config glossary -ListOwners | ForEach-Object { Get-Config -Config glossary -Module $_.Module }
---
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
