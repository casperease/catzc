<#
.SYNOPSIS
    Resolves a config name to its owning module and file path (the discovery seam).
.DESCRIPTION
    Scans automation/<module>/configs/*.yml once (cached) into a name -> entries index, and resolves a
    requested name to a single @{ Name; Module; Path }. -Module disambiguates a name present in more than one
    module. Throws when the name is unknown or ambiguous. Mock this to redirect a config to a fixture in
    logic tests (see ADR test-automation).
.PARAMETER Config
    The config name (without the .yml extension).
.PARAMETER Module
    Disambiguates a name present in multiple modules.
#>
function Resolve-ConfigEntry {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Config,

        [string] $Module
    )

    if (-not $script:configIndex) {
        $script:configIndex = @{}
        $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
        foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($automationRoot)) {
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
