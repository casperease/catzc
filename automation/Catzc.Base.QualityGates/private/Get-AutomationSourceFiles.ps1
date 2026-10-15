function Get-AutomationSourceFiles {
    <#
    .SYNOPSIS
        The canonical set of authored PowerShell files the analysis quality gates cover.
    .DESCRIPTION
        One source of truth for "what the quality gates analyze", so Test-ScriptAnalyzer and the L2 analyzer test...
        [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment1)
    .OUTPUTS
        [string[]] Absolute paths, in discovery order.
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    Assert-SourceTree

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
            # -Recurse so nested test code (tests/types/*.Tests.ps1) is covered too.
            # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment2)
            Get-ChildItem -Path $testsPath -Filter '*.Tests.ps1' -File -Recurse |
                ForEach-Object { $files.Add($_.FullName) }
        }
    }

    # Dot-prefixed folders are skipped by the module loop above because they are not modules, but.internal...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment3)
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

    # .internal holds the shared code the bootstrap and the Catzc modules both call (the loader, the bootstrap, and...
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment4)
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

    # Authored files outside the module tree that still ship and run with it meet the same bar: the root importer.ps1...
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment5)
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
