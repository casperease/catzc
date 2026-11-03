function Resolve-ConfigEntry {
    [CmdletBinding(DefaultParameterSetName = 'One')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('Name')]
        [string] $Config,

        [Parameter(ParameterSetName = 'One')]
        [string] $Module,

        [string] $Namespace = 'Catzc',

        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch] $All
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configIndex')) {
        # Probed through the variable table, so a first call under strict mode finds no index instead of throwing.
        $script:configIndex = @{}
        $addEntry = {
            param([hashtable] $Entry)
            if (-not $script:configIndex.ContainsKey($Entry.Namespace)) {
                $script:configIndex[$Entry.Namespace] = @{}
            }
            $byName = $script:configIndex[$Entry.Namespace]
            if (-not $byName.ContainsKey($Entry.Name)) {
                $byName[$Entry.Name] = [System.Collections.Generic.List[hashtable]]::new()
            }
            $byName[$Entry.Name].Add($Entry)
        }
        $catzcNamespace = 'Catzc'
        $modulesRoot = Get-CatzcModulesRoot
        $moduleDirs = [System.Collections.Generic.List[string]]::new([string[]] @([System.IO.Directory]::EnumerateDirectories($modulesRoot)))
        foreach ($moduleDir in $moduleDirs) {
            $folderName = [System.IO.Path]::GetFileName($moduleDir)
            if ($folderName.StartsWith('.')) {
                continue
            }
            $configsDir = Join-Path $moduleDir 'configs'
            if (-not [System.IO.Directory]::Exists($configsDir)) {
                continue
            }
            $moduleName = Get-ModuleFullName $moduleDir
            # A config is one file, or a folder of disjoint parts when one file would pass the length cap.
            $sources = @([System.IO.Directory]::EnumerateFiles($configsDir,
                    '*.yml')) + @([System.IO.Directory]::EnumerateDirectories($configsDir))
            foreach ($file in $sources) {
                $configName = if ([System.IO.Directory]::Exists($file)) {
                    [System.IO.Path]::GetFileName($file)
                }
                else {
                    [System.IO.Path]::GetFileNameWithoutExtension($file)
                }
                & $addEntry @{ Namespace = $catzcNamespace; Name = $configName; Module = $moduleName; Folder = $folderName; Path = $file }
            }
        }
        # A registered type with no shipped file is still a config, built from an empty map, so every key takes its declared default.
        $registry = Get-ConfigRegistry
        foreach ($configName in @($registry.Keys)) {
            if ($script:configIndex.ContainsKey($catzcNamespace) -and $script:configIndex[$catzcNamespace].ContainsKey($configName)) {
                continue
            }
            $typeName = [string] $registry[$configName]['type']
            $owner = $typeName.Substring(0, [Math]::Max(0, $typeName.LastIndexOf('.')))
            & $addEntry @{ Namespace = $catzcNamespace; Name = $configName; Module = $owner; Path = $null }
        }

        # The consumer modules the importer registered (Register-ConsumerConfigModule), each walked for its configs and its registry.
        $consumerModules = $ExecutionContext.SessionState.PSVariable.GetValue('script:consumerConfigModules')
        if ($null -eq $consumerModules) {
            $consumerModules = @()
        }
        $registered = @{}
        try {
            foreach ($consumerModule in $consumerModules) {
                $trackNamespace = [string] $consumerModule.Namespace
                $moduleName = [string] $consumerModule.Module
                $folderName = [string] $consumerModule.Folder
                $configsDir = Join-Path $consumerModule.Directory 'configs'
                if (-not [System.IO.Directory]::Exists($configsDir)) {
                    continue
                }
                # configs.yml is the consumer module's registry, read below, never a config of its own.
                $sources = @([System.IO.Directory]::EnumerateFiles($configsDir, '*.yml') | Where-Object {
                        [System.IO.Path]::GetFileName($_) -cne 'configs.yml' }) + @([System.IO.Directory]::EnumerateDirectories($configsDir))
                foreach ($file in $sources) {
                    $configName = if ([System.IO.Directory]::Exists($file)) {
                        [System.IO.Path]::GetFileName($file)
                    }
                    else {
                        [System.IO.Path]::GetFileNameWithoutExtension($file)
                    }
                    & $addEntry @{ Namespace = $trackNamespace; Name = $configName; Module = $moduleName; Folder = $folderName; Path = $file }
                }
                $registryPath = Join-Path $configsDir 'configs.yml'
                if (-not [System.IO.File]::Exists($registryPath)) {
                    continue
                }
                $consumerRegistry = Get-Content -LiteralPath $registryPath -Raw | ConvertFrom-Yaml -Ordered
                [void][Catzc.Base.Config.ConfigsConfig]::new($consumerRegistry)   # ctor validates; throws on a malformed registry
                if (-not ($consumerRegistry -and $consumerRegistry.Contains('configs') -and $consumerRegistry['configs'])) {
                    continue
                }
                if (-not $registered.ContainsKey($trackNamespace)) {
                    $registered[$trackNamespace] = [ordered]@{}
                }
                foreach ($configName in @($consumerRegistry['configs'].Keys)) {
                    $registryEntry = $consumerRegistry['configs'][$configName]
                    $typeName = [string] $registryEntry['type']
                    # A type catzc ships may be used; a type in the system's namespace that catzc does not ship would be the consumer's own there.
                    if ($typeName.StartsWith("$catzcNamespace.", [System.StringComparison]::Ordinal) -and -not ($typeName -as [type])) {
                        throw "Config '$configName' in '$registryPath' names the type '$typeName', which is in the system's namespace and not one it ships; a consumer registers types of its own namespace (ADR-AUTO-CONSUMER-OWNCONFIGS)."
                    }
                    if ($registered[$trackNamespace].Contains($configName)) {
                        throw "Config '$configName' is registered twice in the namespace '$trackNamespace' ('$($registered[$trackNamespace][$configName].Module)' and '$moduleName')."
                    }
                    $registered[$trackNamespace][$configName] = @{ Module = $moduleName; Registry = $registryEntry }
                }
            }
            foreach ($trackNamespace in $registered.Keys) {
                foreach ($configName in $registered[$trackNamespace].Keys) {
                    $record = $registered[$trackNamespace][$configName]
                    if ($script:configIndex.ContainsKey($trackNamespace) -and $script:configIndex[$trackNamespace].ContainsKey($configName)) {
                        foreach ($entry in $script:configIndex[$trackNamespace][$configName]) {
                            $entry['Registry'] = $record.Registry
                        }
                    }
                    else {
                        & $addEntry @{ Namespace = $trackNamespace; Name = $configName; Module = $record.Module; Path = $null; Registry = $record.Registry }
                    }
                }
            }
        }
        catch {
            # A failure leaves no half-built index behind.
            $script:configIndex = $null
            throw
        }
    }

    $byName = if ($script:configIndex.ContainsKey($Namespace)) {
        $script:configIndex[$Namespace]
    }
    else {
        @{}
    }

    if ($All) {
        if ($byName.ContainsKey($Config)) {
            $entries = $byName[$Config].ToArray()
            $owners = [string[]] @($entries | ForEach-Object { $_.Module })
            [System.Array]::Sort($owners, $entries, [System.StringComparer]::Ordinal)
            $entries
        }
        return
    }

    if (-not $byName.ContainsKey($Config)) {
        throw "No config '$Config' found in any module's configs/ folder of the namespace '$Namespace'."
    }

    $hits = @($byName[$Config])
    if ($Module) {
        $hits = @($hits | Where-Object { $_.Module -eq $Module })
        if ($hits.Count -eq 0) {
            throw "No config '$Config' in module '$Module' of the namespace '$Namespace'."
        }
    }
    if ($hits.Count -gt 1) {
        $modules = (($hits | ForEach-Object { $_.Module }) | Sort-Object) -join ', '
        throw "Config '$Config' exists in multiple modules of the namespace '$Namespace' ($modules) — pass -Module to disambiguate."
    }

    $hits[0]
}
