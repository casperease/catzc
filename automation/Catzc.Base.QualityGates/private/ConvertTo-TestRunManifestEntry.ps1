<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/ConvertTo-TestRunManifestEntry.ps1
    folder: private
    name: convert-to-test-run-manifest-entry
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/ConvertTo-TestRunManifestEntry.Tests.ps1
  config:
    synopsis: Derives the run.json entries that come from a worker run.
    description: |-
      The part of a run's terminal manifest (Write-TestRunManifest) that only the worker run knows: each shard's
      exit code, the wall-clock duration, and where the run executed — `location` plus, for a snapshot, its
      provenance (Get-TestRunLocationSummary). A run that crashed before its workers returned has no worker run;
      it records no exit codes, a zero duration, and no location.
    parameters:
      WorkerRun: Invoke-TestAutomationWorkers' result, or $null.
    outputs: '[System.Collections.Specialized.OrderedDictionary] the entries to merge into run.json.'
---
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
