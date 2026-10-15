<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Resolve-ConfigEntry.ps1
    kind: function
    module: Catzc.Base.Config
    visibility: private
    adrs:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-CACHE#4
---
#>

<#
.SYNOPSIS
    Resolves a config name to its owning module and file path (the discovery seam).
.DESCRIPTION
    In build mode the scan also covers overlay-local modules, so their configs are found like any module's.
    [comment:1](/docs/references/automation/catzc-base-config/private/Resolve-ConfigEntry.ps1.md#comment1)
.PARAMETER Config
    The config name (without the .yml extension).
.PARAMETER Module
    Disambiguates a name present in multiple modules.
.PARAMETER All
    Returns every module's entry for the name instead of resolving a single one.
#>
function Resolve-ConfigEntry {
    [CmdletBinding(DefaultParameterSetName = 'One')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Config,

        [Parameter(ParameterSetName = 'One')]
        [string] $Module,

        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch] $All
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configIndex')) {
        # Probe through session state, not the bare variable, so strict mode does not throw before the first load.
        # [comment:2](/docs/references/automation/catzc-base-config/private/Resolve-ConfigEntry.ps1.md#comment2)
        $script:configIndex = @{}
        $automationRoot = Get-CatzcModulesRoot
        $moduleDirs = [System.Collections.Generic.List[string]]::new([string[]] @([System.IO.Directory]::EnumerateDirectories($automationRoot)))
        $overlayRoot = Get-ConfigOverlayRoot
        if ($overlayRoot) {
            foreach ($overlayDir in [System.IO.Directory]::EnumerateDirectories($overlayRoot)) {
                if (-not [System.IO.Directory]::Exists([System.IO.Path]::Combine($automationRoot, [System.IO.Path]::GetFileName($overlayDir)))) {
                    $moduleDirs.Add($overlayDir)   # a local module; a bundled module's folder holds fragments, not configs
                }
            }
        }
        foreach ($moduleDir in $moduleDirs) {
            $moduleName = [System.IO.Path]::GetFileName($moduleDir)
            if ($moduleName.StartsWith('.')) {
                continue
            }
            $configsDir = Join-Path $moduleDir 'configs'
            if (-not [System.IO.Directory]::Exists($configsDir)) {
                continue
            }
            foreach ($file in [System.IO.Directory]::EnumerateFiles($configsDir, '*.yml')) {
                $configName = [System.IO.Path]::GetFileNameWithoutExtension($file)
                if (-not $script:configIndex.ContainsKey($configName)) {
                    $script:configIndex[$configName] = [System.Collections.Generic.List[hashtable]]::new()
                }
                $script:configIndex[$configName].Add(@{ Name = $configName; Module = $moduleName; Path = $file })
            }
        }
    }

    if ($All) {
        if ($script:configIndex.ContainsKey($Config)) {
            $entries = $script:configIndex[$Config].ToArray()
            $owners = [string[]] @($entries | ForEach-Object { $_.Module })
            [System.Array]::Sort($owners, $entries, [System.StringComparer]::Ordinal)
            $entries
        }
        return
    }

    if (-not $script:configIndex.ContainsKey($Config)) {
        throw "No config '$Config' found in any module's configs/ folder."
    }

    $hits = @($script:configIndex[$Config])
    if ($Module) {
        $hits = @($hits | Where-Object { $_.Module -eq $Module })
        if ($hits.Count -eq 0) {
            throw "No config '$Config' in module '$Module'."
        }
    }
    if ($hits.Count -gt 1) {
        $modules = (($hits | ForEach-Object { $_.Module }) | Sort-Object) -join ', '
        throw "Config '$Config' exists in multiple modules ($modules) — pass -Module to disambiguate."
    }

    $hits[0]
}
