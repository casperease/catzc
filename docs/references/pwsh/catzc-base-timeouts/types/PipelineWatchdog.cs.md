# pwsh/Base.Timeouts/types/PipelineWatchdog.cs

A one-shot timer that stops a PowerShell pipeline once it outlives its limit: the mechanism behind `Invoke-WithTimeout`.

## Why a C# type

A PowerShell timer callback cannot run here: the timer fires on a thread-pool thread, which has no runspace. So the stop is issued from C#.
`PowerShell.Stop` is safe to call from another thread: it stops the running script and any native command it is waiting on.

Dispose the watchdog once the pipeline returns, so a pipeline that finished in time is never stopped late.

## One lock for stop and dispose

The stop and `Dispose` share one gate: `Timer.Dispose` does not wait for a callback already running, so without it a limit that passes just
as the pipeline returns could call `Stop` on a pipeline the caller has since disposed. That is an exception on a thread-pool thread, which
ends the whole process.
