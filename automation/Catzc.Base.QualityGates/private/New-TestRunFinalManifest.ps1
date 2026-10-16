<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/New-TestRunFinalManifest.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
  config:
    synopsis: Builds a test run's terminal run.json record.
    description: |-
      The record Invoke-TestRun stamps in its finally, on every exit path (Write-TestRunManifest): the terminal status
      and timestamps, the tiers, category, and modules it ran, the failure counts, the run's context
      (Get-TestRunContext, when the run got far enough to have one), what only the worker run knows
      (ConvertTo-TestRunManifestEntry), and — for a run with an opt-out tag — the tag and how many tests it excluded.
    parameters:
      Status: 'The terminal status: passed, failed, or crashed.'
      StartedAt: The run's start, as an ISO 8601 string.
      MinLevel: The run's lowest tier.
      MaxLevel: The highest tier the run executed.
      Category: The category filter.
      Modules: The modules in scope.
      FailedCount: The number of failed tests.
      FailedShardLabels: The shards that reported failure.
      Context: The run's context record, or $null when the run failed before it had one.
      WorkerRun: Invoke-TestAutomationWorkers' result, or $null.
      OptOutTag: The run's opt-out tags; empty for none.
      OptOutExcludedCount: How many tests the opt-out tags excluded.
    outputs: '[System.Collections.Specialized.OrderedDictionary] the run.json record.'
---
#>

function New-TestRunFinalManifest {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Status,

        [string] $StartedAt,

        [int] $MinLevel,

        [int] $MaxLevel,

        [string] $Category,

        [AllowEmptyCollection()]
        [string[]] $Modules = @(),

        [int] $FailedCount,

        [AllowEmptyCollection()]
        [string[]] $FailedShardLabels = @(),

        [AllowNull()]
        [System.Collections.IDictionary] $Context,

        [AllowNull()]
        [object] $WorkerRun,

        [AllowEmptyCollection()]
        [string[]] $OptOutTag = @(),

        [int] $OptOutExcludedCount
    )

    $manifest = [ordered]@{
        status            = $Status
        startedAt         = $StartedAt
        finishedAt        = [DateTimeOffset]::UtcNow.ToString('o')
        minLevel          = $MinLevel
        maxLevel          = $MaxLevel
        category          = $Category
        modules           = @($Modules)
        failedCount       = $FailedCount
        failedShardLabels = @($FailedShardLabels)
    }
    if ($Context) {
        $manifest['context'] = $Context
    }
    # What only the worker run knows: shard exit codes, duration, and where it executed (with a snapshot's provenance).
    $workerEntries = ConvertTo-TestRunManifestEntry -WorkerRun $WorkerRun
    foreach ($key in $workerEntries.Keys) {
        $manifest[$key] = $workerEntries[$key]
    }
    if ($OptOutTag.Count -gt 0) {
        $manifest['optOutTag'] = @($OptOutTag)
        $manifest['optOutExcludedCount'] = $OptOutExcludedCount
    }
    $manifest
}
