<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#33
---
#>

<#
.SYNOPSIS
    Splits the run's test files into the three execution phases: parallel, greedy, and serial.
.DESCRIPTION
    The unit is the file, so one serial or greedy test moves its whole file; a file with both tags is serial.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Split-TestAutomationFiles.ps1.md#comment1)
.PARAMETER Discovery
    The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.
.PARAMETER TestFiles
    The run's test files (absolute paths), already filtered to the run's scope.
.OUTPUTS
    [pscustomobject] with Parallel, Greedy, and Serial — each a sorted string[] of absolute file paths
    (empty when nothing falls in that phase); every input file lands in exactly one.
#>
function Split-TestAutomationFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $serialLookup = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $greedyLookup = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in $Discovery.Tests) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file) {
            continue
        }
        if ((Get-TestBlockTag -Test $test -Valid 'serial').Count -gt 0) {
            [void]$serialLookup.Add($file)
        }
        if ((Get-TestBlockTag -Test $test -Valid 'greedy').Count -gt 0) {
            [void]$greedyLookup.Add($file)
        }
    }

    $parallelFiles = [System.Collections.Generic.List[string]]::new()
    $greedyFiles = [System.Collections.Generic.List[string]]::new()
    $serialFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in ($TestFiles | Sort-Object)) {
        if ($serialLookup.Contains($file)) {
            $serialFiles.Add($file)
        }
        elseif ($greedyLookup.Contains($file)) {
            $greedyFiles.Add($file)
        }
        else {
            $parallelFiles.Add($file)
        }
    }

    [pscustomobject]@{
        Parallel = @($parallelFiles)
        Greedy   = @($greedyFiles)
        Serial   = @($serialFiles)
    }
}
