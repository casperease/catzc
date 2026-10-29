# pwsh/Base.QualityGates/private/Invoke-TestRunPrewarm.ps1

Runs the `*.Prewarm.ps1` scripts of the tests folders a run selects, once, before the worker pool starts.

## help

### synopsis

Runs the prewarm scripts of the selected tests folders and returns the seconds they took.

### description

Each tests folder that holds a selected test file may bring `*.Prewarm.ps1` scripts that build what its tests would otherwise each build.
They run once, in parallel, as worker scripts that load the engine through Get-TestRunEntryLine, before the pool starts. A run that blocks
every real process runs no test a prewarm could feed, so it prewarms nothing. A prewarm that exits non-zero only costs speed: its exit code
and error text are said and the run goes on.

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

`[double]`, the seconds the prewarm took; 0 when none ran.

### example 1

```powershell
$prewarmSeconds = Invoke-TestRunPrewarm -TestFile $files -RunDirectory $runDirectory -WorkerEnvironment $environment -TimeoutSeconds 600
```
