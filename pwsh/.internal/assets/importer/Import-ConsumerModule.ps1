function Import-ConsumerModule {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        # The working root: its variants config declares the tracks, and out/modules/ holds the generated manifests.
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        # The catzc code root, which holds the shared loader the manifests name.
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [switch] $ExportPrivates
    )

    if (-not [System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, '.catzc', 'configs', 'variants.yml'))) {
        return @()
    }
    if (-not (Get-Command Get-Track -ErrorAction Ignore)) {
        throw "The working root '$RepositoryRoot' declares its own tracks (.catzc/configs/variants.yml), but this bundle does not carry Catzc.Base.Variants, which reads them. Use a bundle whose profile includes Catzc.Base.Variants, or remove the declaration."
    }
    $bootstrap = Get-Module Catzc.Internal.Bootstrap
    if (-not $bootstrap) {
        throw 'Import-ConsumerModule runs while Catzc.Internal.Bootstrap is loaded, which writes the manifests; it is not.'
    }

    # Get-Track refuses a consumer track named for the engine's own or in the system's namespace, so that message reaches the caller.
    $systemNamespace = 'Catzc'
    $tracks = @(Get-Track | Where-Object { $_.type -ceq 'modules' -and $_.namespace -and $_.namespace -cne $systemNamespace })

    $privateFolder = & $bootstrap { param($root) Get-PrivateFunctionFolder -ModulesRoot $root } $ModulesRoot
    $loader = [System.IO.Path]::Combine($ModulesRoot, '.internal', 'assets', 'Import-ModuleFiles.ps1')
    if ($tracks.Count -gt 0 -and -not [System.IO.File]::Exists($loader)) {
        throw "The working root '$RepositoryRoot' declares tracks with modules, but this bundle does not carry the shared source loader '$loader', which loads them."
    }

    # The modules of each namespace in folder order, found by layout: a folder holding function files at its root or under private/.
    $byNamespace = [ordered]@{}
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($track in $tracks) {
        foreach ($place in $track.places) {
            $placeDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($RepositoryRoot, $place))
            if (-not [System.IO.Directory]::Exists($placeDirectory)) {
                continue
            }
            $folders = [string[]] @([System.IO.Directory]::EnumerateDirectories($placeDirectory))
            [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
            foreach ($moduleDirectory in $folders) {
                $folder = [System.IO.Path]::GetFileName($moduleDirectory)
                if ($folder.StartsWith('.')) {
                    continue
                }
                $publicFiles = @(foreach ($file in [System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1')) {
                        if (-not $file.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                            $file
                        }
                    })
                $privateDirectory = [System.IO.Path]::Combine($moduleDirectory, $privateFolder)
                $privateFiles = @(if ([System.IO.Directory]::Exists($privateDirectory)) {
                        [System.IO.Directory]::GetFiles($privateDirectory, '*.ps1')
                    })
                if ($publicFiles.Count -eq 0 -and $privateFiles.Count -eq 0) {
                    continue
                }
                $name = $track.FullNameOf($folder)
                if (-not $seen.Add($name)) {
                    throw "The module '$name' is declared by two folders of the working root's tracks; a module name is unique."
                }
                # Private files first, then public, each ordinal, the order catzc's own manifests list them in.
                $privateSorted = [string[]] @($privateFiles | ForEach-Object { $_.Replace('\', '/') })
                $publicSorted = [string[]] @($publicFiles | ForEach-Object { $_.Replace('\', '/') })
                [System.Array]::Sort($privateSorted, [System.StringComparer]::Ordinal)
                [System.Array]::Sort($publicSorted, [System.StringComparer]::Ordinal)
                $exports = [string[]] @($publicFiles | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) })
                [System.Array]::Sort($exports, [System.StringComparer]::Ordinal)
                if (-not $byNamespace.Contains($track.namespace)) {
                    $byNamespace[$track.namespace] = [System.Collections.Generic.List[object]]::new()
                }
                $byNamespace[$track.namespace].Add([pscustomobject]@{
                        Name    = $name
                        Files   = [string[]] @($privateSorted + $publicSorted)
                        Exports = $exports
                    })
            }
        }
    }

    $manifestRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($RepositoryRoot, 'out', 'modules'))
    $loaded = [System.Collections.Generic.List[string]]::new()
    foreach ($consumerNamespace in $byNamespace.Keys) {
        $modules = $byNamespace[$consumerNamespace]
        # The consumer's own dependencies config, if it has one; a module needing a catzc module names it, and catzc's are loaded already.
        $needs = $null
        if (@(Get-Config -Config dependencies -Namespace $consumerNamespace -ListOwners).Count -gt 0) {
            $declared = Get-Config -Config dependencies -Namespace $consumerNamespace
            if ($declared -is [System.Collections.IDictionary] -and $declared.Contains('modules') -and $declared['modules'] -is [System.Collections.IDictionary]) {
                $needs = $declared['modules']
            }
        }
        $remaining = [System.Collections.Generic.List[string]]::new()
        foreach ($module in $modules) {
            $remaining.Add($module.Name)
        }
        $ordered = [System.Collections.Generic.List[string]]::new()
        while ($remaining.Count -gt 0) {
            $next = $null
            foreach ($candidate in $remaining) {
                $blocked = $false
                if ($needs -and $needs.Contains($candidate)) {
                    foreach ($need in @($needs[$candidate])) {
                        if ($need -cne $candidate -and $remaining.Contains([string] $need)) {
                            $blocked = $true
                            break
                        }
                    }
                }
                if (-not $blocked) {
                    $next = $candidate
                    break
                }
            }
            if ($null -eq $next) {
                throw "Cycle in the module dependencies of the namespace '$consumerNamespace' (its dependencies config) among: $($remaining -join ', ')"
            }
            $ordered.Add($next)
            [void] $remaining.Remove($next)
        }

        foreach ($name in $ordered) {
            $module = $modules | Where-Object { $_.Name -ceq $name } | Select-Object -First 1
            # The manifest is output under the working root's out/, so nothing is written into the consumer's tracks to load them.
            $manifestDirectory = [System.IO.Path]::Combine($manifestRoot, $name)
            [void] [System.IO.Directory]::CreateDirectory($manifestDirectory)
            $manifestPath = [System.IO.Path]::Combine($manifestDirectory, "$name.psd1")
            $manifest = & $bootstrap {
                param($loader, $files, $exports, $exportAll, $path)
                $content = Get-DynamicManifestContent -NestedModule $loader -ModuleFile $files -FunctionToExport $exports -ExportAll:$exportAll
                Write-DynamicManifest -Path $path -Content $content
            } $loader.Replace('\', '/') $module.Files $module.Exports ([bool] $ExportPrivates) $manifestPath
            $imported = Import-Module $manifest -Scope Global -Force -PassThru | Select-Object -First 1
            # A session-level Set-StrictMode does not reach module code, so each module sets its own.
            . $imported { Set-StrictMode -Version Latest }
            $loaded.Add($imported.Name)
            Write-ImporterMessage "Consumer: loaded $($imported.Name) from its track, manifest $manifest" -StateChange
        }
    }

    # A module whose folder left the tracks since the last import leaves the session with it.
    foreach ($stale in @(Get-Module | Where-Object { $_.ModuleBase -and $_.ModuleBase.StartsWith($manifestRoot, [System.StringComparison]::OrdinalIgnoreCase) })) {
        if ($stale.Name -cnotin $loaded) {
            Remove-Module -ModuleInfo $stale -Force -ErrorAction SilentlyContinue
            Write-ImporterMessage "Consumer: removed $($stale.Name), its folder is no longer in the tracks" -StateChange
        }
    }
    return $loaded.ToArray()
}
