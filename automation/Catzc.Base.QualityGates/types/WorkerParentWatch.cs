/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/WorkerParentWatch.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
---
*/

// A reused PID is told apart from the parent by start time, so a recycled PID never keeps an orphaned worker alive.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md#comment1)

namespace Catzc.Base.QualityGates;

using System;
using System.Diagnostics;
using System.Globalization;
using System.Threading;

public static class WorkerParentWatch
{
    public const string PidVariable = "CATZC_TEST_PARENT_PID";
    public const string StartVariable = "CATZC_TEST_PARENT_START";

    // A reused PID starts far later than the few milliseconds that Linux start times can differ by between reads.
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md#comment2)
    private static readonly TimeSpan StartTolerance = TimeSpan.FromSeconds(1);

    private static readonly object Sync = new object();
    private static Thread watcher;

    /// <summary>The current process's start time in UTC ticks — the value a parent hands its workers.</summary>
    public static long CurrentStartTicks()
    {
        using var current = Process.GetCurrentProcess();
        return current.StartTime.ToUniversalTime().Ticks;
    }

    /// <summary> The start time guards against PID reuse: a different process on the same PID counts as gone.
    /// [comment:3](/docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md#comment3)
    public static bool IsAlive(int pid, long startTicksUtc)
    {
        try
        {
            using var process = Process.GetProcessById(pid);
            if (process.HasExited)
            {
                return false;
            }
            var started = process.StartTime.ToUniversalTime().Ticks;
            return Math.Abs(started - startTicksUtc) <= StartTolerance.Ticks;
        }
        catch (ArgumentException)
        {
            // No process with that PID.
            return false;
        }
        catch (InvalidOperationException)
        {
            // The process exited between lookup and inspection.
            return false;
        }
    }

    /// <summary> Idempotent: a second call while a watch runs returns true without starting another; false watches nothing.
    /// [comment:4](/docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md#comment4)
    public static bool Start(int intervalMilliseconds)
    {
        if (intervalMilliseconds < 1)
        {
            throw new ArgumentException("intervalMilliseconds must be at least 1.");
        }
        if (!int.TryParse(Environment.GetEnvironmentVariable(PidVariable), NumberStyles.Integer,
                CultureInfo.InvariantCulture, out var pid) ||
            !long.TryParse(Environment.GetEnvironmentVariable(StartVariable), NumberStyles.Integer,
                CultureInfo.InvariantCulture, out var startTicks))
        {
            return false;
        }

        lock (Sync)
        {
            if (watcher != null)
            {
                return true;
            }
            watcher = new Thread(() => Watch(pid, startTicks, intervalMilliseconds))
            {
                IsBackground = true,
                Name = "catzc-worker-parent-watch"
            };
            watcher.Start();
        }
        return true;
    }

    private static void Watch(int pid, long startTicks, int intervalMilliseconds)
    {
        while (IsAlive(pid, startTicks))
        {
            Thread.Sleep(intervalMilliseconds);
        }
        // An orphaned worker's main thread may be stuck writing to a pipe nobody reads, so exit handlers could block.
        // [comment:5](/docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md#comment5)
        using var self = Process.GetCurrentProcess();
        self.Kill();
    }
}
