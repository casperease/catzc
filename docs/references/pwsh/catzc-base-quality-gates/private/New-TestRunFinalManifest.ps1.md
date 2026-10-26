# pwsh/Base.QualityGates/private/New-TestRunFinalManifest.ps1

Builds a test run's terminal `run.json` record. Invoke-TestRun stamps it in its `finally`, so every exit path leaves a final status and
timestamps.

## help

### synopsis

Builds a test run's terminal run.json record.

### description

The record Invoke-TestRun stamps in its finally, on every exit path (Write-TestRunManifest): the terminal status and timestamps, the tiers,
category, and modules it ran, the failure counts, the run's context (Get-TestRunContext, when the run got far enough to have one), what only
the worker run knows (ConvertTo-TestRunManifestEntry), and — for a run with an opt-out tag — the tag and how many tests it excluded.

### parameter `Status`

The terminal status: passed, failed, or crashed.

### parameter `StartedAt`

The run's start, as an ISO 8601 string.

### parameter `MinLevel`

The run's lowest tier.

### parameter `MaxLevel`

The highest tier the run executed.

### parameter `Category`

The category filter.

### parameter `Modules`

The modules in scope.

### parameter `FailedCount`

The number of failed tests.

### parameter `FailedShardLabels`

The shards that reported failure.

### parameter `Context`

The run's context record, or $null when the run failed before it had one.

### parameter `WorkerRun`

Invoke-TestAutomationWorkers' result, or $null.

### parameter `OptOutTag`

The run's opt-out tags; empty for none.

### parameter `OptOutExcludedCount`

How many tests the opt-out tags excluded.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` the run.json record.
