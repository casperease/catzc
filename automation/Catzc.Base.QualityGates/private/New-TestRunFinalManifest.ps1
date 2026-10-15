<#
.SYNOPSIS
    Builds a test run's terminal run.json record.
.DESCRIPTION
    Stamped on every exit path, so even a crashed run leaves a terminal record; Context and WorkerRun may be null.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/New-TestRunFinalManifest.ps1.md#comment1)
.PARAMETER Status
    The terminal status: passed, failed, or crashed.
.PARAMETER StartedAt
    The run's start, as an ISO 8601 string.
.PARAMETER MinLevel
    The run's lowest tier.
.PARAMETER MaxLevel
    The highest tier the run executed.
.PARAMETER Category
    The category filter.
.PARAMETER Modules
    The modules in scope.
.PARAMETER FailedCount
    The number of failed tests.
.PARAMETER FailedShardLabels
    The shards that reported failure.
.PARAMETER Context
    The run's context record, or $null when the run failed before it had one.
.PARAMETER WorkerRun
    Invoke-TestAutomationWorkers' result, or $null.
.PARAMETER OptOutTag
    The run's opt-out tags; empty for none.
.PARAMETER OptOutExcludedCount
    How many tests the opt-out tags excluded.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] the run.json record.
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
