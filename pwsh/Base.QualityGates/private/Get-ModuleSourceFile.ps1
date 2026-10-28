function Get-ModuleSourceFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    Assert-SourceTree

    $root = Get-RepositoryRoot
    $modulesRoot = Join-Path $root (Get-CatzcModulesFolder)
    $files = [System.Collections.Generic.List[string]]::new()
    $testFolderName = (Get-Config -Config languages).FolderOf('test')

    $modules = Get-ChildPath $modulesRoot -Directory -Depth 1 |
        Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') }
    foreach ($moduleDir in $modules) {
        foreach ($script in Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 1) {
            if (-not [System.IO.Path]::GetFileName($script).EndsWith('.Tests.ps1',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                $files.Add($script)
            }
        }

        $privatePath = Join-Path $moduleDir (Get-Config -Config languages).FolderOf('private-function')
        if (Test-Path $privatePath) {
            foreach ($script in Get-ChildPath $privatePath -File -Filter '*.ps1' -Depth 1) {
                $files.Add($script)
            }
        }

        $testsPath = Join-Path $moduleDir $testFolderName
        if (Test-Path $testsPath) {
            # Nested test code counts too; tests/assets/ holds no test files.
            foreach ($script in Get-ChildPath $testsPath -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
        }
    }

    # Dot folders are no modules, but their authored PowerShell meets the same bar.
    $analyzerRoot = Join-Path $modulesRoot '.scriptanalyzer'
    if (Test-Path $analyzerRoot) {
        foreach ($script in [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::RuleFiles($modulesRoot)) {
            $files.Add($script)
        }
        $analyzerTests = Join-Path $analyzerRoot $testFolderName
        if (Test-Path $analyzerTests) {
            foreach ($script in Get-ChildPath $analyzerTests -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
        }
    }

    # .internal: the loader, the bootstrap and the shared library modules, with their tests.
    $internalRoot = Join-Path $modulesRoot '.internal'
    if (Test-Path $internalRoot) {
        foreach ($script in Get-ChildPath $internalRoot -File -Filter '*.psm1' -Depth 1) {
            $files.Add($script)
        }
        $internalTests = Join-Path $internalRoot $testFolderName
        if (Test-Path $internalTests) {
            foreach ($script in Get-ChildPath $internalTests -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
        }
    }

    # Shipped files outside the module tree: importer.ps1 and the one authored analyzer .psd1.
    $importerPath = Join-Path $root ([Catzc.Base.Engines.ExecutionEngines]::Pwsh.ImporterEntry)
    if (Test-Path $importerPath) {
        $files.Add($importerPath)
    }
    $settingsPath = [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::SettingsPath($modulesRoot)
    if (Test-Path $settingsPath) {
        $files.Add($settingsPath)
    }

    $files.ToArray()
}
