<#
.SYNOPSIS
    Derives the run.json entries that come from a worker run.
.DESCRIPTION
    The part of a run's terminal manifest (Write-TestRunManifest) that only the worker run knows: each shard's exit...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/ConvertTo-TestRunManifestEntry.ps1.md#comment1)
.PARAMETER WorkerRun
    Invoke-TestAutomationWorkers' result, or $null.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] the entries to merge into run.json.
#>
function ConvertTo-TestRunManifestEntry {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [AllowNull()]
        [object] $WorkerRun
    )

    $entries = [ordered]@{
        shardExitCodes  = @{}
        durationSeconds = 0
    }
    if (-not $WorkerRun) {
        return $entries
    }

    if ($WorkerRun.PSObject.Properties['ShardExitCodes']) {
        $entries['shardExitCodes'] = $WorkerRun.ShardExitCodes
    }
    $entries['durationSeconds'] = [math]::Round($WorkerRun.DurationSeconds, 2)
    $location = (Get-TestRunLocationSummary -Location $WorkerRun.Location).Manifest
    foreach ($key in $location.Keys) {
        $entries[$key] = $location[$key]
    }
    $entries
}
