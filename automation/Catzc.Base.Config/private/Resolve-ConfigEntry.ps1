<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Resolve-ConfigEntry.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Config
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-config/private/Resolve-ConfigEntry.ps1.md
    adrs:
      - ADR-AUTO-OVERLAY
      - ADR-PWSH-CACHE#4
  config:
    synopsis: Resolves a config name to its owning module and file path (the discovery seam).
    description: |-
      Scans <module>/configs/*.yml under the loaded code root (Get-CatzcModulesRoot — the source tree's
      automation/ or a built package) once (cached) into a name -> entries index, and resolves a
      requested name to a single @{ Name; Module; Path }. -Module disambiguates a name present in more than one
      module. In build mode the scan also covers a consumer overlay's local modules — the folders under
      .catzc/automation/ that name no bundled module ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md))
      — so a local module's configs are found like any module's. Throws when the name is unknown or ambiguous. -All
      instead returns every entry of the name, one per owning module sorted by module name (ordinal), and nothing when
      no module has it — the listing for a config several modules opt into by shipping it. Mock this to redirect a config to a fixture in logic tests
      (see ADR test-automation).
    parameters:
      Config: The config name (without the .yml extension).
      Module: Disambiguates a name present in multiple modules.
      All: Returns every module's entry for the name instead of resolving a single one.
---
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
