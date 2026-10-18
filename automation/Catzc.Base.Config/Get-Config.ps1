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
        $sealedConfigs = ([Catzc.Base.Config.ConfigsConfig]::new(@{ configs = Get-ConfigRegistry })).sealedConfigs
        if ($sealedConfigs -contains $entry.Name) {
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
