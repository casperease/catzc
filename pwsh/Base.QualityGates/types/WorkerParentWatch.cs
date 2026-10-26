/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/WorkerParentWatch.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.QualityGates;

using System;
using System.Diagnostics;
using System.Globalization;
using System.Threading;

// Ends a test worker when the process that started it is gone.
public static class WorkerParentWatch
{
    public const string PidVariable = "CATZC_TEST_PARENT_PID";
    public const string StartVariable = "CATZC_TEST_PARENT_START";

    // Slack for Linux start times; a reused PID starts far later.
    private static readonly TimeSpan StartTolerance = TimeSpan.FromSeconds(1);

    private static readonly object Sync = new object();
    private static Thread watcher;

    /// <summary>The current process's start time in UTC ticks — the value a parent hands its workers.</summary>
    public static long CurrentStartTicks()
    {
        using var current = Process.GetCurrentProcess();
        return current.StartTime.ToUniversalTime().Ticks;
    }

    // Alive means this PID exists and started at this time.
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

    // Watches nothing when the variables are absent or malformed; idempotent.
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
                Name = "catzc-run-parent-watch"
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
        // Kill, not Exit: exit handlers can block behind a pipe nobody reads.
        using var self = Process.GetCurrentProcess();
        self.Kill();
    }
}
