using System;
using System.Management.Automation;
using System.Threading;

namespace Catzc.Base.Timeouts;

// A one-shot timer that stops a PowerShell pipeline once it outlives its limit, behind Invoke-WithTimeout.
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

        // Stop and Dispose share one gate: Timer.Dispose does not wait for a running callback, which could stop a disposed pipeline.
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
