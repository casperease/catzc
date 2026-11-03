function Get-ConsumerModuleViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # The consumer's tracks exist in build mode only; in source mode the tree is catzc's own.
    if ((Get-CatzcRunMode) -cne 'build') {
        return
    }

    $catzcNamespace = 'Catzc'
    $workingRoot = Get-RepositoryRoot
    $sealed = @((Get-Config -Config configs).sealedConfigs)
    # The folders directly under a module-type folder place that are never modules, such as a track's test holder.
    $nonModules = [string[]] @((Get-Config -Config module-types).types | ForEach-Object places |
            Where-Object { $_.name -ceq 'folder' } | ForEach-Object except)

    foreach ($track in @(Get-Track | Where-Object { $_.name -cne 'pwsh' })) {
        $trackNamespace = [string] $track.namespace
        if ($trackNamespace -ceq $catzcNamespace -or $trackNamespace.StartsWith("$catzcNamespace.", [System.StringComparison]::Ordinal)) {
            "track '$($track.name)': the namespace '$trackNamespace' is the system's; a consumer track's namespace is its own (ADR-AUTO-CONSUMER-OWNTRACKS, PDR-CATS-CATZCISSOURCENAME)"
            continue
        }
        if ($track.type -cne 'modules') {
            continue
        }
        foreach ($place in $track.places) {
            $placeDir = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($workingRoot, $place))
            if (-not [System.IO.Directory]::Exists($placeDir)) {
                continue
            }
            $moduleDirs = [string[]] @([System.IO.Directory]::EnumerateDirectories($placeDir))
            [System.Array]::Sort($moduleDirs, [System.StringComparer]::Ordinal)
            foreach ($moduleDir in $moduleDirs) {
                $folderName = [System.IO.Path]::GetFileName($moduleDir)
                if ($folderName.StartsWith('.') -or $nonModules -ccontains $folderName) {
                    continue
                }
                $moduleName = $track.FullNameOf($folderName)

                # A public function that takes the name of a command the bundle exports would silently replace it; a replacement is an override.
                $publicFiles = [string[]] @([System.IO.Directory]::EnumerateFiles($moduleDir, '*.ps1'))
                [System.Array]::Sort($publicFiles, [System.StringComparer]::Ordinal)
                foreach ($file in $publicFiles) {
                    $public = [System.IO.Path]::GetFileNameWithoutExtension($file)
                    $existing = Get-Command -Name $public -ErrorAction Ignore | Where-Object { $_.ModuleName -cne $moduleName } |
                        Select-Object -First 1
                    if ($existing) {
                        "${moduleName}: public function $public takes the name of a command already loaded$(if ($existing.ModuleName) { " from $($existing.ModuleName)" }); to replace a bundled function, override it under .catzc/ (ADR-AUTO-OVERLAY-FUNCTIONOVERRIDE)"
                    }
                }

                # A consumer registers configs in its own namespace; an entry for a sealed catzc config, typed in the system's namespace, tries to override it.
                $registryPath = [System.IO.Path]::Combine($moduleDir, 'configs', 'configs.yml')
                if (-not [System.IO.File]::Exists($registryPath)) {
                    continue
                }
                $registry = Get-Content -LiteralPath $registryPath -Raw | ConvertFrom-Yaml -Ordered
                if (-not ($registry -and $registry.Contains('configs') -and $registry['configs'])) {
                    continue
                }
                foreach ($configName in @($registry['configs'].Keys)) {
                    $typeName = [string] $registry['configs'][$configName]['type']
                    if ($configName -in $sealed -and $typeName.StartsWith("$catzcNamespace.", [System.StringComparison]::Ordinal)) {
                        "${moduleName}: config '$configName' is sealed in the $catzcNamespace namespace and the registry types it as $typeName; register a config of the consumer's own namespace and type (ADR-AUTO-CONSUMER-OWNCONFIGS)"
                    }
                }
            }
        }
    }
}
