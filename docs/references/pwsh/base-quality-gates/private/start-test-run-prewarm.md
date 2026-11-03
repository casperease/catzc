Starts the `*.Prewarm.ps1` scripts of the tests folders a run selects, beside the worker pool's first files, and returns at once.

## help

### synopsis

Writes and starts the prewarm scripts of the selected tests folders and returns the handle to wait on.

### description

Each tests folder that holds a selected test file may bring `*.Prewarm.ps1` scripts that build what its tests would otherwise each build.
They run once, in parallel, as worker scripts that load the engine through Get-TestRunEntryLine, beside the pool's first files. The pool
does not wait for them: a test that arrives before its cache entry is published builds the template itself. A run that blocks every real
process runs no test a prewarm could feed, so it starts nothing. Invoke-TestRunPrewarm is the waiting half.

### parameter `TestFile`

The test files the run selects; their folders are searched for prewarm scripts.

### parameter `RunDirectory`

The run's folder, where the generated prewarm scripts are written.

### parameter `WorkerEnvironment`

The environment the worker processes start with.

### parameter `TimeoutSeconds`

The roof for the prewarm processes.

### parameter `EntryScript`

The engine entry of a build run; empty for the source run.

### parameter `EntryParameter`

The parameters handed to the entry script.

### outputs

A handle holding the runner, the prewarm script paths and the started stopwatch; `$null` when there is nothing to prewarm or launches are
blocked.

### example 1

```powershell
$prewarm = Start-TestRunPrewarm -TestFile $files -RunDirectory $runDirectory -WorkerEnvironment $environment -TimeoutSeconds 600
```
