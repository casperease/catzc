<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-config/Get-Config.ps1.md"
  warning: "Generated Header"
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

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($cacheKey)) {
        return $script:configCache[$cacheKey]
    }

    $raw = if ($entry.Path) {
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
        Assert-True ($raw -is [System.Collections.IDictionary] -and ($null -eq $fragment -or $fragment -is [System.Collections.IDictionary])) -ErrorText "Overlay fragment $fragmentPath cannot merge onto config '$($entry.Name)': a fragment and its config must both be maps."
        if ($null -ne $fragment) {
            $raw = Merge-ConfigFragment -Base $raw -Fragment $fragment
        }
        Write-Verbose "Merged overlay fragment '$fragmentPath' onto config '$($entry.Name)'"
    }

    $ret = $raw
    if ($registered) {
        $type = [type] $registered['type']
        $ret = $type::new($raw)
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $(if ($entry.Path) { $entry.Path } else { "its type's defaults ($($entry.Module))" })"
    $script:configCache[$cacheKey] = $ret
    $script:configCache[$cacheKey]
}
