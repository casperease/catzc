// Runs N Pester worker processes (pwsh -NoProfile -File <script>) concurrently with pooled live output.
// Each worker's stdout/stderr is captured on background reader threads (the CliRunner pattern); the first
// unfinished worker in submission order is "live" and streams to the console in real time, while later
// workers buffer and replay in order as they are promoted — so the console reads sequentially while the
// wall clock runs in parallel. The instance is its own result: Run populates Results, one per script.

namespace Catzc.Base.QualityGates;

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading;

public class PesterRunner
{
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

        // Wall-clock timing relative to this Run call: when the worker process started (offset from the
        // pool's start) and how long it ran. Completion is observed by the reap loop, so DurationMs
        // carries up to one poll interval (~50ms) of slop.
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

    /// <summary>
    /// Runs every script as `pwsh -NoProfile -File &lt;script&gt;`, at most maxParallel at a time, started
    /// in submission order. Blocks until every worker has exited; kills the whole pool and throws on
    /// timeout. The environment dictionary (may be null) is added to each worker's process environment —
    /// the caller's own environment is never touched. Pass silent=true to capture without echoing
    /// anything to the console.
    /// </summary>
    public static PesterRunner Run(string[] runnerScripts, string[] labels, int maxParallel,
        IDictionary environment, int timeoutSeconds, bool silent)
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

        var workers = new Worker[runnerScripts.Length];
        for (int i = 0; i < runnerScripts.Length; i++)
        {
            workers[i] = new Worker { Label = labels[i], ScriptPath = runnerScripts[i] };
        }

        if (silent)
        {
            Execute(workers, maxParallel, environment, timeoutSeconds, silent);
        }
        else
        {
            // Match CliRunner: UTF-8 console for the duration of the live streaming, restored after.
            var previousEncoding = Console.OutputEncoding;
            try
            {
                Console.OutputEncoding = Encoding.UTF8;
                Execute(workers, maxParallel, environment, timeoutSeconds, silent);
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

    private static void Execute(Worker[] workers, int maxParallel, IDictionary environment,
        int timeoutSeconds, bool silent)
    {
        long poolStart = Environment.TickCount64;
        long deadline = poolStart + (long)timeoutSeconds * 1000;
        int nextToStart = 0;
        int liveIndex = 0;

        try
        {
            while (true)
            {
                // Reap: a worker completes when its process has exited and both readers drained to EOF
                // (EOF follows exit promptly once the child's pipe handles close, so the joins are brief).
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

                // Start the next workers in submission order while there is a free slot.
                while (nextToStart < workers.Length && running < maxParallel)
                {
                    Start(workers[nextToStart], environment);
                    workers[nextToStart].StartedTick = Environment.TickCount64;
                    workers[nextToStart].StartOffsetMs = workers[nextToStart].StartedTick - poolStart;
                    nextToStart++;
                    running++;
                }

                // Advance the live token: flush every completed worker's remaining backlog in submission
                // order, then make the first unfinished worker write-through so its output streams live.
                // (The first unfinished worker is always already started, because starts go in order.)
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

    private static void Start(Worker worker, IDictionary environment)
    {
        var psi = new ProcessStartInfo
        {
            FileName = "pwsh",
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true
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

        var process = new Process { StartInfo = psi };
        process.Start();
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
