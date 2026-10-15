<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Lists a run's test files, path by path in the given order, each tests folder's files in ordinal order.
.DESCRIPTION
    Throws when no test file is found, since a run with nothing to run is a scoping mistake, never a green.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestFiles.ps1.md#comment1)
.PARAMETER TestPath
    The run's tests/ folders and language test folders, in run order.
.OUTPUTS
    [string[]] absolute test-file paths, and language test folder paths.
.EXAMPLE
    $testFiles = Get-TestAutomationTestFiles -TestPath $testPaths
#>
function Get-TestAutomationTestFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $languageFolders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($testFolder in @(Get-LanguageTestFolders)) {
        [void]$languageFolders.Add($testFolder.Folder)
    }

    $testFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($testsPath in $TestPath) {
        if ($languageFolders.Contains($testsPath)) {
            $testFiles.Add($testsPath)
            continue
        }
        $files = @([System.IO.Directory]::GetFiles($testsPath, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories))
        [Array]::Sort($files, [System.StringComparer]::Ordinal)
        foreach ($file in $files) {
            $testFiles.Add($file)
        }
    }
    if ($testFiles.Count -eq 0) {
        throw 'No test files found in the discovered tests folders.'
    }
    , $testFiles.ToArray()
}
