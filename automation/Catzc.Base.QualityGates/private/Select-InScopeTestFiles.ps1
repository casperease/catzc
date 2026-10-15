<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Select-InScopeTestFiles.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Keeps the test files with a test inside the run's tier and category scope, and returns the dropped files' tests.
.DESCRIPTION
    A file is dropped only when every discovered test is out of scope; one with none found stays to report its failure.
.PARAMETER Discovery
    The run's discovery-only Pester result (Get-TestDiscovery).
.PARAMETER ExcludeTag
    The run's tier/category exclude tags (Get-TestExcludeTag).
.PARAMETER TestFiles
    The run's candidate test files (absolute *.Tests.ps1 paths), in run order; tests outside them are ignored.
.OUTPUTS
    [pscustomobject] with Files (the kept files, input order preserved) and OutOfScopeTests (every discovered test of
    the dropped files, in run-file order).
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
