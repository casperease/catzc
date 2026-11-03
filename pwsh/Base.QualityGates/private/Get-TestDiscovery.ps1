function Get-TestDiscovery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $target = ConvertTo-PesterRunTarget -Path $TestPath
    $repositoryRoot = [System.IO.Path]::GetFullPath((Get-RepositoryRoot)).TrimEnd('\', '/')
    $cachePath = Join-Path (Get-OutputRoot) 'cache/test-discovery.json'
    $cache = Get-TestDiscoveryCache -Path $cachePath
    $pathLookup = [System.Collections.Generic.HashSet[string]]::new([string[]] $target.Path, [System.StringComparer]::Ordinal)

    # A language test folder's container, by its folder, with the files its lister reads.
    $containerByFolder = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($container in $target.Container) {
        $data = $container.Data | Select-Object -First 1
        $containerByFolder[[string]$data['TestFolder']] = @{ Container = $container; Language = [string]$data['Language'] }
    }
    $listerFilter = @{ go = '*_test.go'; python = 'test_*.py'; javascript = '*.test.js'; bash = '*.bats' }
    $bridgeDigest = [Catzc.Base.Globs.DurableHash]::HashFile((Get-CatzcModuleRoot 'assets/Language.Bridge.ps1' -Module Catzc.Base.QualityGates))

    # One unit per test file, or per language test folder, in the order selected; a hit carries its cached record.
    $units = [System.Collections.Generic.List[object]]::new()
    $missFiles = [System.Collections.Generic.List[string]]::new()
    $missContainers = [System.Collections.Generic.List[object]]::new()
    foreach ($item in $TestPath) {
        if (-not $pathLookup.Contains($item)) {
            $key = [System.IO.Path]::GetFullPath($item).TrimEnd('\', '/')
            $entry = $containerByFolder.ContainsKey($key) ? $containerByFolder[$key] : $null
            $prefix = $null
            $cacheKey = $null
            $record = $null
            if ($entry -and $key.StartsWith("$repositoryRoot$([System.IO.Path]::DirectorySeparatorChar)", [System.StringComparison]::OrdinalIgnoreCase)) {
                # The digest folds the files the lister reads (the folder's test files by its filter, the go.mod of a Go folder) and the bridge.
                $listed = [System.Collections.Generic.List[string]]::new()
                if ([System.IO.Directory]::Exists($key)) {
                    $listed.AddRange([string[]]@(Get-ChildPath $key -File -Filter $listerFilter[$entry.Language] -Depth 3))
                }
                if ($entry.Language -eq 'go') {
                    foreach ($candidate in @($key, [System.IO.Path]::GetDirectoryName($key))) {
                        $modFile = $candidate ? (Join-Path $candidate 'go.mod') : ''
                        if ($modFile -and [System.IO.File]::Exists($modFile)) {
                            $listed.Add($modFile)
                        }
                    }
                }
                $lines = [System.Collections.Generic.List[string]]::new()
                foreach ($file in $listed) {
                    $lines.Add("$([System.IO.Path]::GetRelativePath($repositoryRoot, $file).Replace('\', '/'))|$([Catzc.Base.Globs.DurableHash]::HashFile($file))")
                }
                $lines.Sort([System.StringComparer]::Ordinal)
                $digest = [Catzc.Base.Globs.DurableHash]::HashFold("$($entry.Language)|$bridgeDigest|$($lines -join "`n")")
                $prefix = $key.Substring($repositoryRoot.Length + 1).Replace('\', '/') + '|'
                $cacheKey = "$prefix$digest"
                $record = $cache.ContainsKey($cacheKey) ? $cache[$cacheKey] : $null
            }
            if ($entry -and -not $record) {
                $missContainers.Add($entry.Container)
            }
            $units.Add([pscustomobject]@{ Key = $key; File = $key; CacheKey = $cacheKey; Prefix = $prefix; Record = $record })
            continue
        }
        foreach ($file in @(Get-TestDiscoveryFile -Path $item)) {
            $full = [System.IO.Path]::GetFullPath($file)
            $digest = [Catzc.Base.Globs.DurableHash]::HashFile($full)
            $prefix = $null
            $cacheKey = $null
            if ($digest -and $full.StartsWith("$repositoryRoot$([System.IO.Path]::DirectorySeparatorChar)", [System.StringComparison]::OrdinalIgnoreCase)) {
                $prefix = $full.Substring($repositoryRoot.Length + 1).Replace('\', '/') + '|'
                $cacheKey = "$prefix$digest"
            }
            $record = ($cacheKey -and $cache.ContainsKey($cacheKey)) ? $cache[$cacheKey] : $null
            if (-not $record) {
                $missFiles.Add($full)
            }
            $units.Add([pscustomobject]@{ Key = $full; File = $full; CacheKey = $cacheKey; Prefix = $prefix; Record = $record })
        }
    }

    # One Pester discovery over what the cache does not hold; none when it holds everything.
    $fresh = @{}
    if ($missFiles.Count -gt 0 -or $missContainers.Count -gt 0) {
        $config = New-PesterConfiguration
        if ($missFiles.Count -gt 0) {
            $config.Run.Path = [string[]]$missFiles.ToArray()
        }
        if ($missContainers.Count -gt 0) {
            $config.Run.Container = [object[]]$missContainers.ToArray()
        }
        $config.Run.SkipRun = $true
        $config.Run.PassThru = $true
        $config.Output.Verbosity = 'None'
        $groups = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[object]]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($test in @((Invoke-Pester -Configuration $config).Tests)) {
            $runFile = Get-TestRunFile -Test $test
            $groupKey = $runFile ? [System.IO.Path]::GetFullPath($runFile).TrimEnd('\', '/') : ''
            if (-not $groups.ContainsKey($groupKey)) {
                $groups[$groupKey] = [System.Collections.Generic.List[object]]::new()
            }
            $groups[$groupKey].Add($test)
        }
        $fresh = $groups
    }

    $gained = $false
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($unit in $units) {
        if (-not $unit.Record) {
            $tests = $fresh.ContainsKey($unit.Key) ? @($fresh[$unit.Key]) : @()
            $unit.Record = ConvertTo-TestDiscoveryRecord -Test $tests
            [void]$fresh.Remove($unit.Key)
            if ($unit.CacheKey) {
                # An older digest of the same path is dropped; the entries of other paths stay.
                foreach ($stale in @($cache.Keys).Where({ $_.StartsWith($unit.Prefix, [System.StringComparison]::Ordinal) })) {
                    $cache.Remove($stale)
                }
                $cache[$unit.CacheKey] = $unit.Record
                $gained = $true
            }
        }
        $rows.AddRange([object[]]@(ConvertTo-TestDiscoveryRow -Record $unit.Record -File $unit.File))
    }
    # Tests whose file no unit names (not expected) still reach the readers, uncached.
    foreach ($groupKey in @($fresh.Keys)) {
        $strays = ConvertTo-TestDiscoveryRecord -Test @($fresh[$groupKey])
        $rows.AddRange([object[]]@(ConvertTo-TestDiscoveryRow -Record $strays -File $groupKey))
    }

    if ($gained) {
        Save-TestDiscoveryCache -Path $cachePath -Cache $cache
    }

    [pscustomobject]@{ Tests = $rows.ToArray() }
}
