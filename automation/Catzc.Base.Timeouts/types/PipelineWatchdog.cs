// A one-shot timer that stops a PowerShell pipeline once it outlives its limit — the mechanism behind
// Invoke-WithTimeout. A PowerShell timer callback cannot run here (the timer fires on a thread-pool thread, which
// has no runspace), so the stop is issued from C#. PowerShell.Stop is safe to call from another thread: it stops
// the running script and any native command it is waiting on.
//
// Dispose the watchdog once the pipeline returns, so a pipeline that finished in time is never stopped late.

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

        // The stop and Dispose share one gate: Timer.Dispose does not wait for a callback already running, so without
        // it a limit that passes just as the pipeline returns could call Stop on a pipeline the caller has since
        // disposed — an exception on a thread-pool thread, which ends the whole process.
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
