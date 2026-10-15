<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AutomationSourceFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

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

    $modules = Get-ChildPath $automationRoot -Directory -Depth 1 |
        Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') }
    foreach ($moduleDir in $modules) {
        foreach ($script in Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 1) {
            if (-not [System.IO.Path]::GetFileName($script).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $files.Add($script)
            }
        }

        $privatePath = Join-Path $moduleDir 'private'
        if (Test-Path $privatePath) {
            foreach ($script in Get-ChildPath $privatePath -File -Filter '*.ps1' -Depth 1) {
                $files.Add($script)
            }
        }

        $testsPath = Join-Path $moduleDir 'tests'
        if (Test-Path $testsPath) {
            # Test files sit at most two levels below tests/ (tests/types); the third level is headroom, and tests/assets holds none.
            # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment2)
            foreach ($script in Get-ChildPath $testsPath -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
        }
    }

    # Dot folders are not modules, but .internal and .scriptanalyzer hold authored code that meets the same bar.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment3)
    $analyzerRoot = Join-Path $automationRoot '.scriptanalyzer'
    if (Test-Path $analyzerRoot) {
        foreach ($script in Get-ChildPath $analyzerRoot -File -Filter '*.psm1' -Depth 1) {
            $files.Add($script)
        }
        $analyzerTests = Join-Path $analyzerRoot 'tests'
        if (Test-Path $analyzerTests) {
            foreach ($script in Get-ChildPath $analyzerTests -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
        }
    }

    # .internal is authored code the repo ships and runs, so it meets the same bar as .scriptanalyzer above.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md#comment4)
    $internalRoot = Join-Path $automationRoot '.internal'
    if (Test-Path $internalRoot) {
        foreach ($script in Get-ChildPath $internalRoot -File -Filter '*.psm1' -Depth 1) {
            $files.Add($script)
        }
        $internalTests = Join-Path $internalRoot 'tests'
        if (Test-Path $internalTests) {
            foreach ($script in Get-ChildPath $internalTests -File -Filter '*.Tests.ps1' -Depth 3) {
                $files.Add($script)
            }
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
