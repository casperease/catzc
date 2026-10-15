/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/types/PipelineWatchdog.cs
    kind: type
    module: Catzc.Base.Timeouts
---
*/

// The stop is issued in C# because the timer fires on a thread with no runspace; Dispose it once the pipeline returns.
// [comment:1](/docs/references/automation/catzc-base-timeouts/types/PipelineWatchdog.cs.md#comment1)

using System;
using System.Management.Automation;
using System.Threading;

namespace Catzc.Base.Timeouts;

public sealed class PipelineWatchdog : IDisposable
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private readonly Timer timer;
    private readonly object gate = new object();
    private bool disposed;
    private int fired;

    // True once the limit passed and the pipeline was told to stop.
    public bool Fired { get { return Volatile.Read(ref fired) == 1; } }

    public PipelineWatchdog(PowerShell pipeline, TimeSpan limit)
    {
        if (pipeline == null) { throw new ArgumentNullException("pipeline"); }
        if (limit <= TimeSpan.Zero) { throw new ArgumentOutOfRangeException("limit", "the limit must be positive"); }

        // Without the gate a limit passing as the pipeline returns could Stop a disposed one; that thread-pool exception ends the process.
        // [comment:2](/docs/references/automation/catzc-base-timeouts/types/PipelineWatchdog.cs.md#comment2)
        timer = new Timer(_ =>
        {
            lock (gate)
            {
                if (disposed) { return; }
                Interlocked.Exchange(ref fired, 1);
                pipeline.Stop();
            }
        }, null, limit, Timeout.InfiniteTimeSpan);
    }

    // Once this returns, no stop is running or can start, so the caller may dispose the pipeline.
    public void Dispose()
    {
        lock (gate)
        {
            disposed = true;
            timer.Dispose();
        }
    }
}
