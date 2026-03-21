# These are static properties of the files on disk (ADR-TEST:16), so a single BeforeAll scans the tree ONCE with
# [System.IO] (ADR-TEST:18) and the It blocks assert facets of that one observation (ADR-TEST:20). The old shape ran a
# BeforeDiscovery that enumerated every module with Get-ChildItem and fanned out one -ForEach Describe per
# subdir / per misplaced file / per config entry — heavy discovery for what is a handful of whole-tree
# invariants. Each violation now lists every offender in one message.
Describe 'Folder & file conventions' -Tag 'L0', 'integrity' {
    BeforeAll {
        $automationRoot = Join-Path $env:RepositoryRoot 'automation'
        $allowedModuleSubdirs = @('private', 'tests', 'assets', 'types', 'configs')
        $kebabYml = '^[a-z0-9]+(-[a-z0-9]+)*\.yml$'

        $script:moduleCount = 0
        $script:badSubdirs = [System.Collections.Generic.List[string]]::new()
        $script:misplacedTests = [System.Collections.Generic.List[string]]::new()
        $script:configViolations = [System.Collections.Generic.List[string]]::new()
        $script:legacyConfig = [System.Collections.Generic.List[string]]::new()
        $script:legacyTestAssets = [System.Collections.Generic.List[string]]::new()
        $functionOwners = @{}

        foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($automationRoot) | Sort-Object)) {
            $module = [System.IO.Path]::GetFileName($moduleDirectory)
            if ($module -match '^\.') {
                continue
            }
            $script:moduleCount++

            # Every module subdirectory must be one of the conventional names.
            foreach ($subdirectory in ([System.IO.Directory]::EnumerateDirectories($moduleDirectory) | Sort-Object)) {
                $name = [System.IO.Path]::GetFileName($subdirectory)
                if ($name -notin $allowedModuleSubdirs) {
                    $script:badSubdirs.Add("$module/$name")
                }
            }

            # Module-root .ps1: tests are misplaced (belong in tests/); the rest are public functions whose
            # file basename = exported name (one-function-per-file), tracked for cross-module duplicate export.
            foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1') | Sort-Object)) {
                $name = [System.IO.Path]::GetFileName($path)
                if ($name -like '*.Tests.ps1') {
                    $script:misplacedTests.Add("$module/$name (module root)")
                    continue
                }
                $base = [System.IO.Path]::GetFileNameWithoutExtension($path)
                if (-not $functionOwners.ContainsKey($base)) {
                    $functionOwners[$base] = [System.Collections.Generic.List[string]]::new()
                }
                $functionOwners[$base].Add($module)
            }

            $privateDirectory = Join-Path $moduleDirectory 'private'
            if ([System.IO.Directory]::Exists($privateDirectory)) {
                foreach ($path in ([System.IO.Directory]::EnumerateFiles($privateDirectory, '*.ps1') | Sort-Object)) {
                    $name = [System.IO.Path]::GetFileName($path)
                    if ($name -like '*.Tests.ps1') {
                        $script:misplacedTests.Add("$module/private/$name (private/)")
                    }
                }
            }

            # configs/ — a module's internal config: ONLY flat, kebab-case .yml files (never .yaml, never subdirs).
            $configsDirectory = Join-Path $moduleDirectory 'configs'
            if ([System.IO.Directory]::Exists($configsDirectory)) {
                foreach ($entry in ([System.IO.Directory]::EnumerateFileSystemEntries($configsDirectory) | Sort-Object)) {
                    $name = [System.IO.Path]::GetFileName($entry)
                    # Dot-prefixed entries are infrastructure/tooling, not module config — ignore them all (a
                    # `.not-azure-schema.json` schema sidecar, an editor dotfile, …). Same dot-prefix convention
                    # the module scan applies above. See ADR: repository/conventional-folders (ADR-FOLDERS:4).
                    if ($name -match '^\.') {
                        continue
                    }
                    $isFile = [System.IO.File]::Exists($entry)
                    if (-not $isFile) {
                        $script:configViolations.Add("$module/configs/$name (not a file)"); continue
                    }
                    if ($name -cnotmatch $kebabYml) {
                        $script:configViolations.Add("$module/configs/$name (not kebab-case .yml)")
                    }
                }
            }

            # Anti-regression: internal configs moved out of assets/config/, test fixtures out of assets/test/.
            if ([System.IO.Directory]::Exists((Join-Path $moduleDirectory 'assets/config'))) {
                $script:legacyConfig.Add($module)
            }
            if ([System.IO.Directory]::Exists((Join-Path $moduleDirectory 'assets/test'))) {
                $script:legacyTestAssets.Add($module)
            }
        }

        $script:duplicateExports = @(
            foreach ($pair in $functionOwners.GetEnumerator()) {
                if ($pair.Value.Count -gt 1) {
                    "$($pair.Key): $($pair.Value -join ', ')"
                }
            }
        )
    }

    It 'the scan found modules (guards the checks below against a silent no-op)' {
        $moduleCount | Should -BeGreaterThan 3
    }

    It 'every module subdirectory is a conventional folder name' {
        $badSubdirs | Should -BeNullOrEmpty -Because "module subdirectories must be one of: private, tests, assets, types, configs. See ADR: repository/conventional-folders`n$($badSubdirs -join "`n")"
    }

    It 'no test file sits outside tests/' {
        $misplacedTests | Should -BeNullOrEmpty -Because "test files belong in tests/. See ADR: repository/conventional-folders`n$($misplacedTests -join "`n")"
    }

    It 'no public function name is exported by more than one module' {
        $duplicateExports | Should -BeNullOrEmpty -Because "last-loaded module wins silently — rename or move to a single module:`n$($duplicateExports -join "`n")"
    }

    It 'every configs/ entry is a flat, kebab-case .yml file' {
        $configViolations | Should -BeNullOrEmpty -Because "configs/ is flat and holds only kebab-case .yml files (not .yaml, no subdirs). See ADR: repository/conventional-folders`n$($configViolations -join "`n")"
    }

    It 'no module uses the legacy assets/config/ location' {
        $legacyConfig | Should -BeNullOrEmpty -Because "internal configs now live in configs/. See ADR: repository/conventional-folders`n$($legacyConfig -join "`n")"
    }

    It 'no module uses the legacy assets/test/ location' {
        $legacyTestAssets | Should -BeNullOrEmpty -Because "test fixtures now live in tests/assets/. See ADR: repository/conventional-folders`n$($legacyTestAssets -join "`n")"
    }
}
