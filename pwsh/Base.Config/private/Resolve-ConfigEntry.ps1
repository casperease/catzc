<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/private/Resolve-ConfigEntry.ps1.md"
  header: "generated"
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
        # Probed through the variable table, so a first call under strict mode finds no index instead of throwing.
        $script:configIndex = @{}
        $modulesRoot = Get-CatzcModulesRoot
        $moduleDirs = [System.Collections.Generic.List[string]]::new([string[]] @([System.IO.Directory]::EnumerateDirectories($modulesRoot)))
        $overlayRoot = Get-ConfigOverlayRoot
        if ($overlayRoot) {
            foreach ($overlayDir in [System.IO.Directory]::EnumerateDirectories($overlayRoot)) {
                if (-not [System.IO.Directory]::Exists([System.IO.Path]::Combine($modulesRoot,
                            [System.IO.Path]::GetFileName($overlayDir)))) {
                    $moduleDirs.Add($overlayDir)   # a local module; a bundled module's folder holds fragments, not configs
                }
            }
        }
        foreach ($moduleDir in $moduleDirs) {
            $folderName = [System.IO.Path]::GetFileName($moduleDir)
            if ($folderName.StartsWith('.')) {
                continue
            }
            $manifests = @([System.IO.Directory]::EnumerateFiles($moduleDir, '*.psd1'))
            $moduleName = if ($manifests.Count -eq 1) {
                [System.IO.Path]::GetFileNameWithoutExtension($manifests[0])
            }
            else {
                $folderName
            }
            $configsDir = Join-Path $moduleDir 'configs'
            if (-not [System.IO.Directory]::Exists($configsDir)) {
                continue
            }
            $sources = @([System.IO.Directory]::EnumerateFiles($configsDir,
                    '*.yml')) + @([System.IO.Directory]::EnumerateDirectories($configsDir))
            foreach ($file in $sources) {
                $configName = if ([System.IO.Directory]::Exists($file)) {
                    [System.IO.Path]::GetFileName($file)
                }
                else {
                    [System.IO.Path]::GetFileNameWithoutExtension($file)
                }
                if (-not $script:configIndex.ContainsKey($configName)) {
                    $script:configIndex[$configName] = [System.Collections.Generic.List[hashtable]]::new()
                }
                $script:configIndex[$configName].Add(@{ Name = $configName; Module = $moduleName; Folder = $folderName; Path = $file })
            }
        }
        $registry = Get-ConfigRegistry
        foreach ($configName in @($registry.Keys)) {
            if ($script:configIndex.ContainsKey($configName)) {
                continue
            }
            $typeName = [string] $registry[$configName]['type']
            $owner = $typeName.Substring(0, [Math]::Max(0, $typeName.LastIndexOf('.')))
            $script:configIndex[$configName] = [System.Collections.Generic.List[hashtable]]::new()
            $script:configIndex[$configName].Add(@{ Name = $configName; Module = $owner; Path = $null })
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
