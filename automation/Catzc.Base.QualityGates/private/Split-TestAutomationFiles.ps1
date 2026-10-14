<#
.SYNOPSIS
    Splits the run's test files into the three execution phases: parallel, greedy, and serial.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery — the same pass the tag check consumes) and
    classifies every file by the phase tags (both optional) its tests resolve through their block chains
    (Get-TestBlockTag, nearest contributing block wins — the same resolution as the tier/category axes):

      - 'serial' — the test mutates state shared across worker processes (the committed .compiled assembly,
        a fixed out/ path two files both write). Its file runs in the final one-worker phase,
        strictly alone, one file after another.
      - 'greedy' — the test consumes the machine beyond its own process (fans out a background-process
        pool, spawns importer-loading pwsh workers) but shares no mutable state with other files. Its file
        runs in the greedy phase: single-file shards through the worker pool, one file per worker, so
        greedy files overlap each other but never the parallel phase they would otherwise starve.
      - untagged — the parallel phase (the round-robin shards).

    A test that changes state outside the repository is not a phase concern: it is an L3 vertical system test,
    and only the run that owns the working folder runs L3 (Resolve-TestRunMaxLevel,
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).

    A file carrying both serial and greedy is serial: strict isolation wins. Granularity is deliberately the file — a
    file is the unit a shard schedules, so one tagged test moves its whole file. See the test-automation
    ADR ([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
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
