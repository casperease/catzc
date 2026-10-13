<#
.SYNOPSIS
    Lists a run's test files, folder by folder in the given order, each folder's files in ordinal order.
.DESCRIPTION
    The work-list behind Test-Automation's phases: every *.Tests.ps1 under each tests/ folder (recursing, so
    tests/types/ is included), in the folders' foundation-first order (Get-TestAutomationTestPaths) and, within a
    folder, ordinal-sorted so the list is the same on every machine. Throws when the folders hold no test file —
    a run with nothing to run is a scoping mistake, never a green.
.PARAMETER TestPath
    The run's tests/ folders, in run order.
.OUTPUTS
    [string[]] absolute test-file paths.
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

    $testFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($testsPath in $TestPath) {
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
