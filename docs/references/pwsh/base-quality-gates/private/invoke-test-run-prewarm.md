# pwsh/Base.QualityGates/private/Invoke-TestRunPrewarm.ps1

Waits for the prewarm that Start-TestRunPrewarm started beside the worker pool's first files, and reports it.

## help

### synopsis

Waits for the started prewarm, reports each prewarm that failed, and returns the seconds it took.

### description

The prewarm scripts run beside the pool's first files, not before them: a test that arrives before its cache entry is published builds the
template itself. This is the waiting half. It waits for the runner of the handle Start-TestRunPrewarm returned, so the prewarm's seconds
count in the run's time. A prewarm that exits non-zero only costs speed: its exit code and error text are said and the run goes on. A
`$null` handle, from a run with no prewarm script or one that blocks every real process, waits for nothing.

### parameter `Prewarm`

The handle Start-TestRunPrewarm returned: the runner, the prewarm script paths and the started stopwatch; `$null` when nothing was started.

### outputs

`[double]`, the seconds the prewarm took; 0 when none ran.

### example 1

```powershell
$prewarm = Start-TestRunPrewarm -TestFile $files -RunDirectory $runDirectory -WorkerEnvironment $environment -TimeoutSeconds 600
$prewarmSeconds = Invoke-TestRunPrewarm -Prewarm $prewarm
```
