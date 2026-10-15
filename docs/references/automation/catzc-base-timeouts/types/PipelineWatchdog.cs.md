# docs/references/automation/catzc-base-timeouts/types/PipelineWatchdog.cs.md

`automation/Catzc.Base.Timeouts/types/PipelineWatchdog.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A one-shot timer that stops a PowerShell pipeline once it outlives its limit — the mechanism behind
Invoke-WithTimeout. A PowerShell timer callback cannot run here (the timer fires on a thread-pool thread, which
has no runspace), so the stop is issued from C#. PowerShell.Stop is safe to call from another thread: it stops
the running script and any native command it is waiting on.

Dispose the watchdog once the pipeline returns, so a pipeline that finished in time is never stopped late.
```

## comment:2

Above `timer = new Timer(_ =>`.

```text
The stop and Dispose share one gate: Timer.Dispose does not wait for a callback already running, so without
it a limit that passes just as the pipeline returns could call Stop on a pipeline the caller has since
disposed — an exception on a thread-pool thread, which ends the whole process.
```
