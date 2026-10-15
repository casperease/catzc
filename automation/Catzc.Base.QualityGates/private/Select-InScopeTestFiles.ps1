<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Select-InScopeTestFiles.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Select-InScopeTestFiles.Tests.ps1
  config:
    synopsis: Keeps the test files with a test inside the run's tier and category scope, and returns the dropped files' tests.
    description: |-
      A worker filters by tier and category itself (the exclude tags), but only after loading a file and discovering
      its tests, so a file whose every test is out of scope costs that load for nothing. Given the run's one discovery
      pass (all tests, any tier), this keeps each file holding at least one test in scope (Test-TestInRunScope), so an
      L3-only run sends only the L3 files to workers.

      A file is dropped only when discovery found tests in it and every one is out of scope. A file with no discovered
      test — empty, or one that failed to load — stays, so its worker still reports the failure instead of the run
      passing without it. The dropped files' tests are returned for the caller to report as NotRun, as a worker would
      have: the skip report, tests.csv, and the rule coverage then read the same rows whether a file was loaded or not.
    parameters:
      Discovery: The run's discovery-only Pester result (Get-TestDiscovery).
      ExcludeTag: The run's tier/category exclude tags (Get-TestExcludeTag).
      TestFiles: The run's candidate test files (absolute *.Tests.ps1 paths), in run order; tests outside them are ignored.
    outputs: |-
      [pscustomobject] with Files (the kept files, input order preserved) and OutOfScopeTests (every discovered test of
      the dropped files, in run-file order).
---
#>

function Select-InScopeTestFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $fileLookup = [System.Collections.Generic.HashSet[string]]::new([string[]] $TestFiles, [System.StringComparer]::OrdinalIgnoreCase)
    $inScopeFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $testsByFile = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[object]]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file -or -not $fileLookup.Contains($file)) {
            continue
        }
        if (-not $testsByFile.ContainsKey($file)) {
            $testsByFile[$file] = [System.Collections.Generic.List[object]]::new()
        }
        $testsByFile[$file].Add($test)
        if (Test-TestInRunScope -Test $test -ExcludeTag $ExcludeTag) {
            [void]$inScopeFiles.Add($file)
        }
    }

    $kept = [System.Collections.Generic.List[string]]::new()
    $outOfScope = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $TestFiles) {
        if ($inScopeFiles.Contains($file) -or -not $testsByFile.ContainsKey($file)) {
            $kept.Add($file)
        }
        else {
            $outOfScope.AddRange($testsByFile[$file])
        }
    }

    [pscustomobject]@{
        Files           = $kept.ToArray()
        OutOfScopeTests = $outOfScope.ToArray()
    }
}
