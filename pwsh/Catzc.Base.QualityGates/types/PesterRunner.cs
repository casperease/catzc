namespace Catzc.Base.QualityGates;

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Text;
using System.Threading;

public class PesterRunner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // One entry per runner script, in submission order — populated by Run.
    public WorkerResult[] Results { get; private set; }

    /// <summary>The captured outcome of one worker process.</summary>
    public sealed class WorkerResult
    {
        public string Label { get; internal set; }
        public string ScriptPath { get; internal set; }
        public string Stdout { get; internal set; }
        public string Stderr { get; internal set; }
        public int ExitCode { get; internal set; }

        public long StartOffsetMs { get; internal set; }
        public long DurationMs { get; internal set; }
    }

    // Per-worker live state while the pool runs. Mutable output state is guarded by Sync.
    private sealed class Worker
    {
        public string Label;
        public string ScriptPath;
        public readonly object Sync = new object();
        public readonly StringBuilder Stdout = new StringBuilder();
        public readonly StringBuilder Stderr = new StringBuilder();
        public int StdoutEchoed;      // chars of Stdout already written to the console
        public int StderrEchoed;
        public bool Live;             // readers write through to the console when set
        public string[] Caps = Array.Empty<string>();  // the named limits this worker counts against
        public Process Process;
        public Thread StdoutReader;
        public Thread StderrReader;
        public bool Started;
        public bool Completed;        // process exited AND both readers drained to EOF
        public int ExitCode;
        public long StartedTick;      // Environment.TickCount64 when the process started
        public long StartOffsetMs;    // StartedTick relative to the pool's start
        public long DurationMs;       // start → reap-observed completion
    }

    public static PesterRunner Run(string[] runnerScripts, string[] labels, int maxParallel,
        IDictionary environment, int timeoutSeconds, bool silent)
    {
        return Run(runnerScripts, labels, null, null, maxParallel, environment, timeoutSeconds, silent);
    }

    public static PesterRunner Run(string[] runnerScripts, string[] labels, string[][] workerCaps, IDictionary capLimits,
        int maxParallel, IDictionary environment, int timeoutSeconds, bool silent)
    {
        if (runnerScripts == null || runnerScripts.Length == 0)
        {
            throw new ArgumentException("runnerScripts must contain at least one script path.");
        }
        if (labels == null || labels.Length != runnerScripts.Length)
        {
            throw new ArgumentException(
                $"labels must have one entry per runner script (expected {runnerScripts.Length}, got {labels?.Length ?? 0}).");
        }
        if (maxParallel < 1)
        {
            throw new ArgumentException("maxParallel must be at least 1.");
        }
        if (timeoutSeconds < 1)
        {
            throw new ArgumentException("timeoutSeconds must be at least 1.");
        }

        if (workerCaps != null && workerCaps.Length != runnerScripts.Length)
        {
            throw new ArgumentException(
                $"workerCaps must have one entry per runner script (expected {runnerScripts.Length}, got {workerCaps.Length}).");
        }
        var limits = new Dictionary<string, int>(StringComparer.Ordinal);
        if (capLimits != null)
        {
            foreach (DictionaryEntry entry in capLimits)
            {
                int limit = Convert.ToInt32(entry.Value, CultureInfo.InvariantCulture);
                if (limit < 1)
                {
                    throw new ArgumentException($"cap '{entry.Key}' must allow at least 1 worker (got {limit}).");
                }
                limits[entry.Key.ToString()] = limit;
            }
        }

        var workers = new Worker[runnerScripts.Length];
        for (int i = 0; i < runnerScripts.Length; i++)
        {
            workers[i] = new Worker { Label = labels[i], ScriptPath = runnerScripts[i] };
            if (workerCaps != null && workerCaps[i] != null)
            {
                foreach (string cap in workerCaps[i])
                {
                    if (!limits.ContainsKey(cap))
                    {
                        throw new ArgumentException($"worker '{labels[i]}' names the cap '{cap}', which capLimits does not declare.");
                    }
                }
                workers[i].Caps = workerCaps[i];
            }
        }

        if (silent)
        {
            Execute(workers, limits, maxParallel, environment, timeoutSeconds, silent);
        }
        else
        {
            // Match CliRunner: UTF-8 console for the duration of the live streaming, restored after.
            var previousEncoding = Console.OutputEncoding;
            try
            {
                Console.OutputEncoding = Encoding.UTF8;
                Execute(workers, limits, maxParallel, environment, timeoutSeconds, silent);
            }
            finally
            {
                Console.OutputEncoding = previousEncoding;
            }
        }

        var results = new WorkerResult[workers.Length];
        for (int i = 0; i < workers.Length; i++)
        {
            results[i] = new WorkerResult
            {
                Label = workers[i].Label,
                ScriptPath = workers[i].ScriptPath,
                Stdout = workers[i].Stdout.ToString(),
                Stderr = workers[i].Stderr.ToString(),
                ExitCode = workers[i].ExitCode,
                StartOffsetMs = workers[i].StartOffsetMs,
                DurationMs = workers[i].DurationMs
            };
        }
        return new PesterRunner { Results = results };
    }

    private static void Execute(Worker[] workers, Dictionary<string, int> limits, int maxParallel, IDictionary environment,
        int timeoutSeconds, bool silent)
    {
        long poolStart = Environment.TickCount64;
        long deadline = poolStart + (long)timeoutSeconds * 1000;
        int liveIndex = 0;

        try
        {
            while (true)
            {
                int running = 0;
                foreach (var worker in workers)
                {
                    if (worker.Started && !worker.Completed && worker.Process.HasExited)
                    {
                        worker.StdoutReader.Join();
                        worker.StderrReader.Join();
                        worker.ExitCode = worker.Process.ExitCode;
                        worker.DurationMs = Environment.TickCount64 - worker.StartedTick;
                        worker.Process.Dispose();
                        worker.Completed = true;
                    }
                    if (worker.Started && !worker.Completed)
                    {
                        running++;
                    }
                }

                // Start the next workers in submission order while a slot is free, skipping any whose cap is full.
                while (running < maxParallel)
                {
                    int next = NextStartable(workers, limits);
                    if (next < 0)
                    {
                        break;
                    }
                    Start(workers[next], environment);
                    workers[next].StartedTick = Environment.TickCount64;
                    workers[next].StartOffsetMs = workers[next].StartedTick - poolStart;
                    running++;
                }

                if (!silent)
                {
                    while (liveIndex < workers.Length && workers[liveIndex].Completed)
                    {
                        Flush(workers[liveIndex]);
                        liveIndex++;
                    }
                    if (liveIndex < workers.Length && workers[liveIndex].Started)
                    {
                        Promote(workers[liveIndex]);
                    }
                }

                bool allCompleted = true;
                foreach (var worker in workers)
                {
                    if (!worker.Completed)
                    {
                        allCompleted = false;
                        break;
                    }
                }
                if (allCompleted)
                {
                    break;
                }

                if (Environment.TickCount64 > deadline)
                {
                    var unfinished = new List<string>();
                    foreach (var worker in workers)
                    {
                        if (!worker.Completed)
                        {
                            unfinished.Add(worker.Label);
                        }
                    }
                    throw new TimeoutException(
                        $"PesterRunner timed out after {timeoutSeconds}s with {unfinished.Count} worker(s) unfinished: " +
                        $"{string.Join(", ", unfinished)}. All workers were killed.");
                }

                Thread.Sleep(50);
            }
        }
        catch
        {
            KillAll(workers);
            throw;
        }
    }

    // The first worker not yet started whose every cap has room, or -1.
    private static int NextStartable(Worker[] workers, Dictionary<string, int> limits)
    {
        for (int i = 0; i < workers.Length; i++)
        {
            if (workers[i].Started)
            {
                continue;
            }
            bool fits = true;
            foreach (string cap in workers[i].Caps)
            {
                int inUse = 0;
                foreach (var other in workers)
                {
                    if (other.Started && !other.Completed && Array.IndexOf(other.Caps, cap) >= 0)
                    {
                        inUse++;
                    }
                }
                if (inUse >= limits[cap])
                {
                    fits = false;
                    break;
                }
            }
            if (fits)
            {
                return i;
            }
        }
        return -1;
    }

    private static void Start(Worker worker, IDictionary environment)
    {
        var psi = new ProcessStartInfo
        {
            FileName = "pwsh",
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            RedirectStandardInput = true
        };
        psi.ArgumentList.Add("-NoProfile");
        psi.ArgumentList.Add("-File");
        psi.ArgumentList.Add(worker.ScriptPath);

        // Extra variables land on the child's ProcessStartInfo only — never the parent's environment.
        if (environment != null)
        {
            foreach (DictionaryEntry entry in environment)
            {
                psi.Environment[entry.Key.ToString()] = entry.Value == null ? null : entry.Value.ToString();
            }
        }

        psi.Environment[WorkerParentWatch.PidVariable] = Environment.ProcessId.ToString(CultureInfo.InvariantCulture);
        psi.Environment[WorkerParentWatch.StartVariable] =
            WorkerParentWatch.CurrentStartTicks().ToString(CultureInfo.InvariantCulture);

        var process = new Process { StartInfo = psi };
        process.Start();
        process.StandardInput.Close();
        worker.Process = process;

        worker.StdoutReader = new Thread(() => ReadStream(worker, isError: false)) { IsBackground = true };
        worker.StderrReader = new Thread(() => ReadStream(worker, isError: true)) { IsBackground = true };
        worker.StdoutReader.Start();
        worker.StderrReader.Start();
        worker.Started = true;
    }

    private static void ReadStream(Worker worker, bool isError)
    {
        var reader = isError ? worker.Process.StandardError : worker.Process.StandardOutput;
        var captured = isError ? worker.Stderr : worker.Stdout;

        int ch;
        while ((ch = reader.Read()) != -1)
        {
            char c = (char)ch;
            lock (worker.Sync)
            {
                captured.Append(c);
                if (worker.Live)
                {
                    // Echo-through keeps the echoed counter equal to the captured length while live.
                    if (isError)
                    {
                        Console.Error.Write(c);
                        worker.StderrEchoed++;
                    }
                    else
                    {
                        Console.Write(c);
                        worker.StdoutEchoed++;
                    }
                }
            }
        }
    }

    private static void Flush(Worker worker)
    {
        lock (worker.Sync)
        {
            FlushLocked(worker);
        }
    }

    private static void Promote(Worker worker)
    {
        lock (worker.Sync)
        {
            if (!worker.Live)
            {
                FlushLocked(worker);
                worker.Live = true;
            }
        }
    }

    // Writes a worker's not-yet-echoed output to the console (stdout, then stderr). Caller holds Sync.
    private static void FlushLocked(Worker worker)
    {
        if (worker.StdoutEchoed < worker.Stdout.Length)
        {
            Console.Write(worker.Stdout.ToString(worker.StdoutEchoed, worker.Stdout.Length - worker.StdoutEchoed));
            worker.StdoutEchoed = worker.Stdout.Length;
        }
        if (worker.StderrEchoed < worker.Stderr.Length)
        {
            Console.Error.Write(worker.Stderr.ToString(worker.StderrEchoed, worker.Stderr.Length - worker.StderrEchoed));
            worker.StderrEchoed = worker.Stderr.Length;
        }
    }

    private static void KillAll(Worker[] workers)
    {
        foreach (var worker in workers)
        {
            if (worker.Started && !worker.Completed)
            {
                try
                {
                    // Whole tree — a pwsh worker may have spawned children of its own.
                    worker.Process.Kill(entireProcessTree: true);
                }
                catch (Exception)
                {
                    // The process exited between the completion check and the kill — nothing to do.
                }
            }
        }
    }
}
