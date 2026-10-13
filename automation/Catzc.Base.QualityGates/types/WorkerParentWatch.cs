// Ends a test worker process when the process that started it is gone. PesterRunner hands every worker its own
// PID and start time (CATZC_TEST_PARENT_PID / CATZC_TEST_PARENT_START); the generated shard script calls Start,
// and a background thread polls the parent. When the parent has exited — or its PID now belongs to a different
// process (PID reuse, told apart by start time) — the worker kills itself, so a run whose parent died (a closed
// terminal, a killed console) never leaves workers behind holding files and running unobserved.

namespace Catzc.Base.QualityGates;

using System;
using System.Diagnostics;
using System.Globalization;
using System.Threading;

public static class WorkerParentWatch
{
    public const string PidVariable = "CATZC_TEST_PARENT_PID";
    public const string StartVariable = "CATZC_TEST_PARENT_START";

    // Start times are compared with slack: on Linux, Process.StartTime is derived from the boot time and can
    // differ by a few milliseconds between reads of the same process. A reused PID starts far later than that.
    private static readonly TimeSpan StartTolerance = TimeSpan.FromSeconds(1);

    private static readonly object Sync = new object();
    private static Thread watcher;

    /// <summary>The current process's start time in UTC ticks — the value a parent hands its workers.</summary>
    public static long CurrentStartTicks()
    {
        using var current = Process.GetCurrentProcess();
        return current.StartTime.ToUniversalTime().Ticks;
    }

    /// <summary>
    /// True when the process with this PID exists and started at this time (UTC ticks, within tolerance).
    /// </summary>
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

    /// <summary>
    /// Starts watching the parent named by the environment variables. Returns false — and watches nothing — when
    /// they are absent (the script was not started by PesterRunner) or malformed. Idempotent: a second call while
    /// a watch runs returns true without starting another.
    /// </summary>
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
        // Kill, not Environment.Exit: exit handlers can block behind a main thread stuck writing to a pipe nobody
        // reads any more, which is exactly the state an orphaned worker is in.
        using var self = Process.GetCurrentProcess();
        self.Kill();
    }
}
