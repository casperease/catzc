<#
.SYNOPSIS
    Lists a run's test files, path by path in the given order, each tests folder's files in ordinal order.
.DESCRIPTION
    The work-list behind Test-Automation's phases: every *.Tests.ps1 under each tests/ folder (recursing, so
    tests/types/ is included), in the paths' foundation-first order (Get-TestAutomationTestPaths) and, within a
    folder, ordinal-sorted so the list is the same on every machine. A Go test folder (Get-GoTestFolders) is one
    run file itself: the Go bridge runs it as one unit (ConvertTo-PesterRunTarget). Throws when the paths hold no
    test file — a run with nothing to run is a scoping mistake, never a green.
.PARAMETER TestPath
    The run's tests/ folders and Go test folders, in run order.
.OUTPUTS
    [string[]] absolute test-file paths, and Go test folder paths.
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

    $goFolders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($goFolder in @(Get-GoTestFolders)) {
        [void]$goFolders.Add($goFolder.Folder)
    }

    $testFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($testsPath in $TestPath) {
        if ($goFolders.Contains($testsPath)) {
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
