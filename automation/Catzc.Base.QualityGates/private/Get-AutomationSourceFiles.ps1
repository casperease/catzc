function Get-AutomationSourceFiles {
    <#
    .SYNOPSIS
        The canonical set of authored PowerShell files the formatting and analysis gates cover.
    .DESCRIPTION
        One source of truth for "what the gates format and analyze", so Format-Automation, Test-ScriptAnalyzer,
        and the L2 analyzer test cannot drift apart. Covers every authored PowerShell file the repository ships
        or runs: each module's root *.ps1 (non-test), private/*.ps1, tests/**/*.Tests.ps1; the .internal
        shared modules (the loader, the bootstrap, the shared libraries, the TestKit fixture library) and their
        tests/**/*.Tests.ps1; the custom analyzer rules (.scriptanalyzer/*.psm1) and their tests/**/*.Tests.ps1;
        the root importer.ps1; and
        authored .psd1 config (PSScriptAnalyzerSettings.psd1). The .vendor (third-party) and .compiled (build
        output) folders and generated module manifests are excluded — build output made canonical by its
        generator, not hand-authored.
    .OUTPUTS
        [string[]] Absolute paths, in discovery order.
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $root = Get-RepositoryRoot
    $automationRoot = Join-Path $root 'automation'
    $files = [System.Collections.Generic.List[string]]::new()

    $modules = Get-ChildItem -Path $automationRoot -Directory |
        Where-Object { $_.Name -notmatch '^\.' }
    foreach ($moduleDir in $modules) {
        Get-ChildItem -Path $moduleDir.FullName -Filter '*.ps1' -File |
            Where-Object { $_.Name -notlike '*.Tests.ps1' } |
            ForEach-Object { $files.Add($_.FullName) }

        $privatePath = Join-Path $moduleDir.FullName 'private'
        if (Test-Path $privatePath) {
            Get-ChildItem -Path $privatePath -Filter '*.ps1' -File |
                ForEach-Object { $files.Add($_.FullName) }
        }

        $testsPath = Join-Path $moduleDir.FullName 'tests'
        if (Test-Path $testsPath) {
            # -Recurse so nested test code (tests/types/*.Tests.ps1) is covered too. Only *.Tests.ps1 is
            # matched, and tests/assets/ holds no test files, so this picks up real test code only.
            Get-ChildItem -Path $testsPath -Filter '*.Tests.ps1' -File -Recurse |
                ForEach-Object { $files.Add($_.FullName) }
        }
    }

    # Dot-prefixed folders are skipped by the module loop above because they are not modules, but .internal and
    # .scriptanalyzer still hold authored PowerShell the repo runs — the loader, the bootstrap, the shared
    # library modules and their tests, and the custom analyzer rules with their tests. These meet the same bar,
    # so they are enumerated explicitly below. (.vendor is third-party and .compiled is build output — both
    # stay excluded.)
    $analyzerRoot = Join-Path $automationRoot '.scriptanalyzer'
    if (Test-Path $analyzerRoot) {
        Get-ChildItem -Path $analyzerRoot -Filter '*.psm1' -File |
            ForEach-Object { $files.Add($_.FullName) }
        $analyzerTests = Join-Path $analyzerRoot 'tests'
        if (Test-Path $analyzerTests) {
            Get-ChildItem -Path $analyzerTests -Filter '*.Tests.ps1' -File -Recurse |
                ForEach-Object { $files.Add($_.FullName) }
        }
    }

    # .internal holds the shared code the bootstrap and the Catzc modules both call (the loader, the bootstrap,
    # and the shared library modules) plus their tests. It is authored PowerShell the repo ships and runs, so it
    # meets the same bar as .scriptanalyzer above.
    $internalRoot = Join-Path $automationRoot '.internal'
    if (Test-Path $internalRoot) {
        Get-ChildItem -Path $internalRoot -Filter '*.psm1' -File |
            ForEach-Object { $files.Add($_.FullName) }
        $internalTests = Join-Path $internalRoot 'tests'
        if (Test-Path $internalTests) {
            Get-ChildItem -Path $internalTests -Filter '*.Tests.ps1' -File -Recurse |
                ForEach-Object { $files.Add($_.FullName) }
        }
    }

    # Authored files outside the module tree that still ship and run with it meet the same bar: the root
    # importer.ps1 and the analyzer config under .internal/assets. The analyzer config is the ONE authored
    # .psd1 (committed, not a generated manifest); generated module manifests (automation/**/*.psd1) are
    # gitignored build output and are deliberately absent.
    $importerPath = Join-Path $root 'importer.ps1'
    if (Test-Path $importerPath) {
        $files.Add($importerPath)
    }
    $settingsPath = Join-Path $root 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
    if (Test-Path $settingsPath) {
        $files.Add($settingsPath)
    }

    $files.ToArray()
}
