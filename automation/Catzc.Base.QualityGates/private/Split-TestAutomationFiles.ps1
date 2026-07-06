<#
.SYNOPSIS
    Splits the run's test files into the three execution phases: parallel, greedy, and serial.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery — the same pass the tag gate consumes) and
    classifies every file by the optional phase tags its tests resolve through their block chains
    (Get-TestBlockTag, nearest contributing block wins — the same resolution as the tier/category axes):

      - 'serial' — the test mutates state shared across worker processes (the committed .compiled assembly,
        a fixed out/ path two files both write, .triggers/). Its file runs in the final one-worker phase,
        strictly alone, one file after another.
      - 'greedy' — the test consumes the machine beyond its own process (fans out a background-process
        pool, spawns importer-loading pwsh workers) but shares no mutable state with other files. Its file
        runs in the greedy phase: single-file shards through the worker pool, one file per worker slot, so
        greedy files overlap each other but never the parallel phase they would otherwise starve.
      - untagged — the parallel phase (the round-robin shards).

    A file carrying both tags is serial: strict isolation wins. Granularity is deliberately the file — a
    file is the unit a shard schedules, so one tagged test moves its whole file. See the test-automation
    ADR (ADR-TEST:26).
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
        if (-not $test.ScriptBlock.File) {
            continue
        }
        if ((Get-TestBlockTag -Test $test -Valid 'serial').Count -gt 0) {
            [void]$serialLookup.Add($test.ScriptBlock.File)
        }
        if ((Get-TestBlockTag -Test $test -Valid 'greedy').Count -gt 0) {
            [void]$greedyLookup.Add($test.ScriptBlock.File)
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
