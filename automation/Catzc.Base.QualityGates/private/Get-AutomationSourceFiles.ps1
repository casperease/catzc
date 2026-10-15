function Get-AutomationSourceFiles {
    <#
    .SYNOPSIS
        The canonical set of authored PowerShell files the analysis quality gates cover.
    .DESCRIPTION
        Formatting covers a wider set (Format-Code); this set leaves out .vendor, .compiled and generated manifests.
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
            # Recursion reaches nested test code such as tests/types; tests/assets holds no test files to match.
            # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment2)
            Get-ChildItem -Path $testsPath -Filter '*.Tests.ps1' -File -Recurse |
                ForEach-Object { $files.Add($_.FullName) }
        }
    }

    # Dot folders are not modules, but .internal and .scriptanalyzer hold authored code that meets the same bar.
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

    # .internal is authored code the repo ships and runs, so it meets the same bar as .scriptanalyzer above.
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

    # The analyzer config is the one authored .psd1; generated manifests are gitignored build output and stay out.
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
