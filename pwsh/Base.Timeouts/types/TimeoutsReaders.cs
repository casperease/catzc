// The readers of the timeouts file's small sections (wait, run_lock, janitors) and the checks they share.

using System;
using System.Collections;
using System.Collections.Generic;
using static Catzc.Base.Timeouts.TimeoutsConfig;

namespace Catzc.Base.Timeouts;

public static class TimeoutsReaders
{
    private static readonly string[] JanitorKeys = { "generated_files_seconds" };

    internal static void CheckKeys(IDictionary d, string[] allowed, string prefix, List<string> errors)
    {
        if (d == null)
        {
            return;
        }
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}{1}' (allowed: {2})", prefix, key, string.Join(", ", allowed)));
            }
        }
    }

    internal static string Axis(string value, string[] allowed, string axis)
    {
        string normalized = value == null ? "" : value.Trim().ToLowerInvariant();
        if (Array.IndexOf(allowed, normalized) < 0)
        {
            throw new ArgumentException(string.Format("unknown {0} '{1}' (allowed: {2})", axis, value, string.Join(", ", allowed)));
        }
        return normalized;
    }

    internal static int? PositiveSeconds(object value)
    {
        if (value is int || value is long || value is short || value is byte)
        {
            long seconds = Convert.ToInt64(value);
            return seconds > 0 && seconds <= int.MaxValue ? (int)seconds : (int?)null;
        }

        return null;
    }

    internal static void ReadJanitors(object value, List<string> errors, ref int janitorGeneratedFilesSeconds)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid janitors (must be a map of generated_files_seconds)");
            return;
        }
        CheckKeys(map, JanitorKeys, "janitors.", errors);
        if (!map.Contains("generated_files_seconds") || map["generated_files_seconds"] == null) { return; }
        int? number = PositiveSeconds(map["generated_files_seconds"]);
        if (number == null)
        {
            errors.Add(string.Format("invalid janitors.generated_files_seconds '{0}' (must be a positive whole number)", map["generated_files_seconds"]));
            return;
        }
        janitorGeneratedFilesSeconds = number.Value;
    }

    private static readonly string[] ParallelKeys = { "processes" };

    internal static void ReadParallel(object value, List<string> errors, ref int parallelProcesses)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid parallel (must be a map of processes)");
            return;
        }
        CheckKeys(map, ParallelKeys, "parallel.", errors);
        if (!map.Contains("processes") || map["processes"] == null) { return; }
        int? number = PositiveSeconds(map["processes"]);
        if (number == null)
        {
            errors.Add(string.Format("invalid parallel.processes '{0}' (must be a positive whole number)", map["processes"]));
            return;
        }
        parallelProcesses = number.Value;
    }

    internal static void ReadRunLock(object value, List<string> errors, Dictionary<string, int> runLock)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid run_lock (must be a map of wait_seconds, stale_seconds, budget_seconds)");
            return;
        }
        CheckKeys(map, RunLockKeys, "run_lock.", errors);
        foreach (string key in RunLockKeys)
        {
            if (!map.Contains(key) || map[key] == null) { continue; }
            int? number = PositiveSeconds(map[key]);
            if (number == null)
            {
                errors.Add(string.Format("invalid run_lock.{0} '{1}' (must be a positive whole number)", key, map[key]));
                continue;
            }
            runLock[key] = number.Value;
        }
    }

    internal static void ReadWait(object value, List<string> errors, ref int waitSeconds, ref int waitMilliseconds, ref int waitDrainSeconds)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid wait (must be a map of seconds, milliseconds, drain_seconds)");
            return;
        }
        CheckKeys(map, WaitKeys, "wait.", errors);
        foreach (string key in WaitKeys)
        {
            if (!map.Contains(key) || map[key] == null) { continue; }
            int? number = PositiveSeconds(map[key]);
            if (number == null)
            {
                errors.Add(string.Format("invalid wait.{0} '{1}' (must be a positive whole number)", key, map[key]));
                continue;
            }
            if (key == "seconds") { waitSeconds = number.Value; }
            else if (key == "milliseconds") { waitMilliseconds = number.Value; }
            else { waitDrainSeconds = number.Value; }
        }
    }
}
