---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/types/PipelineWatchdog.cs.md
    kind: comment-page
    body_sha: "254b38dd639b"
---

# automation/Catzc.Base.Timeouts/types/PipelineWatchdog.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A one-shot timer that stops a PowerShell pipeline once it outlives its limit — the mechanism behind
Invoke-WithTimeout. A PowerShell timer callback cannot run here (the timer fires on a thread-pool thread, which
has no runspace), so the stop is issued from C#. PowerShell.Stop is safe to call from another thread: it stops
the running script and any native command it is waiting on.

Dispose the watchdog once the pipeline returns, so a pipeline that finished in time is never stopped late.
```

## comment:2

Above `timer = new Timer(_ =>`, written with `//`.

```text
The stop and Dispose share one gate: Timer.Dispose does not wait for a callback already running, so without
it a limit that passes just as the pipeline returns could call Stop on a pipeline the caller has since
disposed — an exception on a thread-pool thread, which ends the whole process.
```
