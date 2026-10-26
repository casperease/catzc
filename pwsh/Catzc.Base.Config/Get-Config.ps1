<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-config/Get-Config.ps1.md"
  header: "generated"
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

    # The one reader of every config, so a name it cannot discover throws here and never falls back to a guess.
    $entry = Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path }

    # The cache key carries the overlay fragment's stamp, so an edited fragment is never served from a stale merge.
    $fragmentPath = $null
    $cacheKey = if ($entry.Path) {
        $entry.Path
    }
    else {
        "type:$($entry.Module)/$($entry.Name)"
    }
    $overlayRoot = Get-ConfigOverlayRoot
    if ($overlayRoot) {
        $candidate = [System.IO.Path]::Combine($overlayRoot, $entry.Module, 'configs', "$($entry.Name).yml")
        if ([System.IO.File]::Exists($candidate)) {
            $fragmentPath = $candidate
            $stamp = [System.IO.FileInfo]::new($candidate)
            $cacheKey = "$cacheKey|$candidate|$($stamp.LastWriteTimeUtc.Ticks)|$($stamp.Length)"
        }
    }

    # Keyed by the resolved file, so two names for one file share one parsed object and one file never yields two.
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        # Probed through the variable table, so a first call under strict mode finds no cache instead of throwing.
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($cacheKey)) {
        return $script:configCache[$cacheKey]
    }

    $raw = if ($entry.Path -and [System.IO.Directory]::Exists($entry.Path)) {
        # A split config: its parts merge in ordinal name order, and a key two parts both set fails the load.
        $parts = [string[]] @([System.IO.Directory]::GetFiles($entry.Path, '*.yml'))
        [System.Array]::Sort($parts, [System.StringComparer]::Ordinal)
        Assert-True ($parts.Count -gt 0) -ErrorText "Config folder '$($entry.Path)' holds no *.yml part."
        $merged = [ordered]@{}
        foreach ($part in $parts) {
            $partRaw = [System.IO.File]::ReadAllText($part) | ConvertFrom-Yaml -Ordered
            Assert-True ($partRaw -is [System.Collections.IDictionary]) -ErrorText "Config part '$part' must be a map."
            $merged = Merge-ConfigFragment -Base $merged -Fragment $partRaw -Disjoint
        }
        $merged
    }
    elseif ($entry.Path) {
        Assert-PathExist $entry.Path
        $text = [System.IO.File]::ReadAllText($entry.Path)
        Assert-True ($text.Length -gt 0) -ErrorText "Config file '$($entry.Path)' is empty (0 bytes): the read raced a writer, or the file was truncated on disk."
        $text | ConvertFrom-Yaml -Ordered
    }
    else {
        [ordered]@{}
    }

    $registered = (Get-ConfigRegistry)[$entry.Name]
    if ($fragmentPath) {
        $sealedConfigs = ([Catzc.Base.Config.ConfigsConfig]::new(@{ configs = Get-ConfigRegistry })).sealedConfigs
        if ($sealedConfigs -contains $entry.Name) {
            throw "Config '$($entry.Name)' is sealed (configs.yml overridable: false), so the overlay may not change it: remove $fragmentPath."
        }
        $fragment = Get-Content $fragmentPath -Raw | ConvertFrom-Yaml -Ordered
        Assert-True ($raw -is [System.Collections.IDictionary] -and ($null -eq $fragment -or
            $fragment -is [System.Collections.IDictionary])) -ErrorText "Overlay fragment $fragmentPath cannot merge onto config '$($entry.Name)': a fragment and its config must both be maps."
        if ($null -ne $fragment) {
            $raw = Merge-ConfigFragment -Base $raw -Fragment $fragment
        }
        Write-Verbose "Merged overlay fragment '$fragmentPath' onto config '$($entry.Name)'"
    }

    $ret = $raw
    if ($registered) {
        # The registered type maps and validates at construction, so a malformed file can never become a config object.
        $type = [type] $registered['type']
        $ret = $type::new($raw)
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $(if ($entry.Path) { $entry.Path } else { "its type's defaults ($($entry.Module))" })"
    $script:configCache[$cacheKey] = $ret
    $script:configCache[$cacheKey]
}
