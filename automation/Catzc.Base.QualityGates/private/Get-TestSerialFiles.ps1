<#
.SYNOPSIS
    Lists the test files that must run in the serial phase — those containing any 'serial'-tagged test.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery — the same pass the tag gate consumes) and
    returns every file in which at least one test resolves the optional 'serial' tag through its block chain
    (Get-TestBlockTag, nearest contributing block wins — the same resolution as the tier/category axes). A
    serial test mutates state shared across worker processes (the committed .compiled assembly, fixed paths
    under out/, .triggers/), so its whole file is kept out of the parallel shards and run in a final
    one-worker phase, alone. Granularity is deliberately the file: a file is the unit a shard schedules, so
    one serial test serializes its file. See the test-automation ADR.
.PARAMETER Discovery
    The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.
.OUTPUTS
    [string[]] the serial files' absolute paths, sorted, distinct (empty when nothing is tagged serial).
#>
function Get-TestSerialFiles {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        $Discovery
    )

    $files = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($test in $Discovery.Tests) {
        $serialTags = Get-TestBlockTag -Test $test -Valid 'serial'
        if ($serialTags.Count -gt 0 -and $test.ScriptBlock.File) {
            [void]$files.Add($test.ScriptBlock.File)
        }
    }

    , @($files | Sort-Object)
}
