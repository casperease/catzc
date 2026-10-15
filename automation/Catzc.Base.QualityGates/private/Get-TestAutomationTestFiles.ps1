<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestFiles.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestFiles.Tests.ps1
  config:
    synopsis: Lists a run's test files, path by path in the given order, each tests folder's files in ordinal order.
    description: |-
      The work-list behind Test-Automation's phases: every *.Tests.ps1 under each tests/ folder (recursing, so
      tests/types/ is included), in the paths' foundation-first order (Get-TestAutomationTestPaths) and, within a
      folder, ordinal-sorted so the list is the same on every machine. A Go or Python test folder
      (Get-LanguageTestFolders) is one run file itself: the language bridge runs it as one unit
      (ConvertTo-PesterRunTarget). Throws when the paths hold no test file — a run with nothing to run is a scoping
      mistake, never a green.
    parameters:
      TestPath: The run's tests/ folders and language test folders, in run order.
    outputs: '[string[]] absolute test-file paths, and language test folder paths.'
    examples:
      - '$testFiles = Get-TestAutomationTestFiles -TestPath $testPaths'
---
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
        # Test files sit at most two levels below a tests folder (tests/types/); the third level is headroom.
        $files = @(Get-ChildPath $testsPath -File -Filter '*.Tests.ps1' -Depth 3)
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
