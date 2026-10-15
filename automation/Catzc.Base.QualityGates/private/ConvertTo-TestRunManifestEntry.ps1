<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/ConvertTo-TestRunManifestEntry.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Derives the run.json entries that come from a worker run.
.DESCRIPTION
    A run that crashed before its workers returned has no worker run, so it gets empty exit codes and a zero duration.
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
