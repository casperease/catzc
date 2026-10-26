/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-execution/types/CliRunner.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.ExceptionServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Catzc.Base.Execution;

// Runs the executable with no shell, streaming and capturing both outputs, and kills the whole tree past its limit.
[Catzc.Base.Objects.ConsoleDisplay(nameof(ExitCode))]
public class CliRunner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The full captured stdout of the run (also streamed live unless silent).
    public string Stdout { get; private set; }

    // The full captured stderr of the run (also streamed live unless silent).
    public string Stderr { get; private set; }

    // The process exit code.
    public int ExitCode { get; private set; }

    // Set by RunBytes only, for a stream such as git cat-file --batch whose sizes count bytes.
    public byte[] StdoutBytes { get; private set; }

    // One command, no shell operators; past timeoutSeconds the process tree is killed and the run throws.
    public static CliRunner Run(string commandLine, bool silent, string workingDirectory, int timeoutSeconds, int drainSeconds,
        string input = null)
    {
        AssertLimits(timeoutSeconds, drainSeconds);

        var parsed = ParseCommand(commandLine);

        if (parsed.HasShellOperator)
        {
            throw new InvalidOperationException(
                $"Invoke-Executable runs a single command — shell operators ({parsed.ShellOperator}) are not supported. " +
                "Break the command into separate Invoke-Executable calls, or use -Direct for shell expressions.");
        }

        return RunDirect(commandLine, parsed.Executable, parsed.Arguments, silent, workingDirectory, timeoutSeconds, drainSeconds, input);
    }

    // Silent, undecoded stdout bytes, with stdin empty and closed.
    public static CliRunner RunBytes(string commandLine, string workingDirectory, int timeoutSeconds, int drainSeconds)
    {
        AssertLimits(timeoutSeconds, drainSeconds);

        var parsed = ParseCommand(commandLine);
        if (parsed.HasShellOperator)
        {
            throw new InvalidOperationException(
                $"Invoke-Executable runs a single command — shell operators ({parsed.ShellOperator}) are not supported.");
        }

        var psi = NewStartInfo(parsed.Executable, parsed.Arguments, workingDirectory, redirectInput: true);
        var runner = new CliRunner();
        var stdout = new MemoryStream();
        var stderrSb = new StringBuilder();

        using (var process = new Process { StartInfo = psi })
        {
            process.Start();
            process.StandardInput.Close();

            var stdoutThread = Reader(() => process.StandardOutput.BaseStream.CopyTo(stdout));
            var stderrThread = Reader(() => stderrSb.Append(process.StandardError.ReadToEnd()));
            stdoutThread.Start();
            stderrThread.Start();

            Supervise(commandLine, process, timeoutSeconds, TimeSpan.FromSeconds(drainSeconds), stdoutThread, stderrThread);
            runner.ExitCode = process.ExitCode;
        }

        runner.StdoutBytes = stdout.ToArray();
        runner.Stdout = string.Empty;
        runner.Stderr = stderrSb.ToString();
        return runner;
    }

    // Each command runs as Run does, silently, at most throttle at a time, each bounded by its own limit; results keep the commands' order.
    public static CliRunner[] RunMany(string[] commandLines, string workingDirectory, int[] timeoutSeconds, int drainSeconds,
        int throttle)
    {
        if (commandLines == null)
        {
            throw new ArgumentNullException(nameof(commandLines));
        }
        if (timeoutSeconds == null || timeoutSeconds.Length != commandLines.Length)
        {
            throw new ArgumentException("every command needs its own time limit", nameof(timeoutSeconds));
        }
        if (throttle <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(throttle), "at least one process must run at a time");
        }

        var results = new CliRunner[commandLines.Length];
        var failures = new Exception[commandLines.Length];
        Parallel.For(0, commandLines.Length, new ParallelOptions { MaxDegreeOfParallelism = throttle }, index =>
        {
            try
            {
                results[index] = Run(commandLines[index], true, workingDirectory, timeoutSeconds[index], drainSeconds);
            }
            catch (Exception failure)
            {
                failures[index] = failure;
            }
        });

        // Every command has finished, each within its limit, before any failure is raised: none is left running behind the throw.
        var thrown = new List<Exception>();
        foreach (var failure in failures)
        {
            if (failure != null)
            {
                thrown.Add(failure);
            }
        }
        if (thrown.Count == 1)
        {
            ExceptionDispatchInfo.Capture(thrown[0]).Throw();
        }
        if (thrown.Count > 1)
        {
            throw new AggregateException($"{thrown.Count} of {commandLines.Length} commands failed", thrown);
        }
        return results;
    }

    // The first token, unquoted: the name the command's time limit is looked up by.
    public static string ExecutableName(string commandLine)
    {
        return ParseCommand(commandLine ?? "").Executable ?? "";
    }

    // A reader still blocked after drainSeconds waits on a pipe a started process still holds open.
    private static void AssertLimits(int timeoutSeconds, int drainSeconds)
    {
        if (timeoutSeconds <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(timeoutSeconds), "every run needs a positive time limit");
        }
        if (drainSeconds <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(drainSeconds), "every run needs a positive limit on its output's end after exit");
        }
    }

    private static CliRunner RunDirect(string commandLine, string executable, List<string> arguments, bool silent,
        string workingDirectory, int timeoutSeconds, int drainSeconds, string input)
    {
        var runner = new CliRunner();
        var stdoutSb = new StringBuilder();
        var stderrSb = new StringBuilder();

        // No one can answer a prompt here, so the child gets an empty, closed stdin rather than hang on an inherited pipe.
        var psi = NewStartInfo(executable, arguments, workingDirectory, redirectInput: input != null || silent || Console.IsInputRedirected);
        if (input != null)
        {
            psi.StandardInputEncoding = new UTF8Encoding(false);
        }

        return Execute(commandLine, psi, stdoutSb, stderrSb, silent, timeoutSeconds, TimeSpan.FromSeconds(drainSeconds), runner, input);
    }

    private static ProcessStartInfo NewStartInfo(string executable, List<string> arguments, string workingDirectory,
        bool redirectInput)
    {
        // Resolved on PATH first: Process.Start finds no .cmd or .bat, and az, npm and poetry are .cmd on Windows.
        var psi = new ProcessStartInfo
        {
            FileName = ResolveExecutable(executable),
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            RedirectStandardInput = redirectInput
        };

        if (!string.IsNullOrEmpty(workingDirectory))
        {
            psi.WorkingDirectory = workingDirectory;
        }

        // ArgumentList handles all platform-specific escaping automatically.
        foreach (var arg in arguments)
        {
            psi.ArgumentList.Add(arg);
        }

        return psi;
    }

    // A background thread, so a reader stuck on a leftover pipe never keeps the host alive.
    private static Thread Reader(Action read)
    {
        return new Thread(() =>
        {
            try
            {
                read();
            }
            catch (Exception ex) when (ex is IOException or ObjectDisposedException or InvalidOperationException)
            {
                // The run is over: Supervise already reported why the output did not end.
            }
        })
        { IsBackground = true };
    }

    // Bounded twice: the process by its limit, then its readers, so a held pipe fails the run instead of hanging it.
    private static void Supervise(string commandLine, Process process, int timeoutSeconds, TimeSpan drainLimit, Thread stdoutThread,
        Thread stderrThread)
    {
        if (!process.WaitForExit(TimeSpan.FromSeconds(timeoutSeconds)))
        {
            process.Kill(entireProcessTree: true);
            process.WaitForExit();
            stdoutThread.Join(drainLimit);
            stderrThread.Join(drainLimit);
            throw new TimeoutException(
                $"Killed '{commandLine}' after {timeoutSeconds}s: it did not finish within its time limit. " +
                "Make it faster, or raise the limit: pass -TimeoutSeconds, or tune the executable's entry in " +
                "the timeouts.yml config of the Catzc.Base.Timeouts module.");
        }

        process.WaitForExit();
        var drainClock = System.Diagnostics.Stopwatch.StartNew();
        var drained = stdoutThread.Join(drainLimit);
        var remaining = drainLimit - drainClock.Elapsed;
        drained &= stderrThread.Join(remaining > TimeSpan.Zero ? remaining : TimeSpan.Zero);
        if (!drained)
        {
            throw new IOException(
                $"'{commandLine}' exited (code {process.ExitCode}), but a process it started still holds its output open, " +
                $"so the output never ended (waited {drainLimit.TotalSeconds:0}s after exit). Stop that process from " +
                "inheriting the output: for a dotnet build, pass --disable-build-servers.");
        }
    }

    private static CliRunner Execute(string commandLine, ProcessStartInfo psi, StringBuilder stdoutSb,
        StringBuilder stderrSb, bool silent, int timeoutSeconds, TimeSpan drainLimit, CliRunner runner, string input)
    {
        var previousEncoding = Console.OutputEncoding;

        try
        {
            Console.OutputEncoding = Encoding.UTF8;

            using (var process = new Process { StartInfo = psi })
            {
                process.Start();
                if (psi.RedirectStandardInput && input == null)
                {
                    process.StandardInput.Close();
                }

                var stdoutThread = Reader(() =>
                {
                    int ch;
                    while ((ch = process.StandardOutput.Read()) != -1)
                    {
                        char c = (char)ch;
                        if (!silent) Console.Write(c);
                        stdoutSb.Append(c);
                    }
                });

                var stderrThread = Reader(() =>
                {
                    int ch;
                    while ((ch = process.StandardError.Read()) != -1)
                    {
                        char c = (char)ch;
                        if (!silent) Console.Error.Write(c);
                        stderrSb.Append(c);
                    }
                });

                stdoutThread.Start();
                stderrThread.Start();

                // Written on its own thread after the readers run: a child that fills its output before it reads all its input cannot deadlock.
                if (input != null)
                {
                    Reader(() =>
                    {
                        process.StandardInput.Write(input);
                        process.StandardInput.Close();
                    }).Start();
                }

                Supervise(commandLine, process, timeoutSeconds, drainLimit, stdoutThread, stderrThread);

                runner.ExitCode = process.ExitCode;
            }
        }
        finally
        {
            Console.OutputEncoding = previousEncoding;
        }

        runner.Stdout = stdoutSb.ToString();
        runner.Stderr = stderrSb.ToString();

        return runner;
    }

    // --- Executable resolution ---

    // PATHEXT order on Windows (.exe, .cmd, .bat, .com), the bare name on Unix.
    private static string ResolveExecutable(string name)
    {
        // Already a full/relative path with directory separator — use as-is
        if (name.Contains(Path.DirectorySeparatorChar) ||
            name.Contains(Path.AltDirectorySeparatorChar))
        {
            return name;
        }

        var pathDirs = (Environment.GetEnvironmentVariable("PATH") ?? "")
            .Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries);

        // Extensions to try. On Windows, match PATHEXT order. On Unix, bare name only.
        var extensions = System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(
            System.Runtime.InteropServices.OSPlatform.Windows)
            ? new[] { ".exe", ".cmd", ".bat", ".com", "" }
            : new[] { "" };

        foreach (var dir in pathDirs)
        {
            foreach (var ext in extensions)
            {
                var candidate = Path.Combine(dir, name + ext);
                if (File.Exists(candidate))
                {
                    return candidate;
                }
            }
        }

        // Not found — return original, let Process.Start throw a clear error
        return name;
    }

    // --- Command string parser ---

    private class ParsedCommand
    {
        public string Executable;
        public List<string> Arguments = new List<string>();
        public bool HasShellOperator;
        public string ShellOperator;
    }

    // Quotes are honoured; an unquoted | && || needs a shell, so it is refused.
    private static ParsedCommand ParseCommand(string commandLine)
    {
        var result = new ParsedCommand();
        var tokens = new List<string>();
        var current = new StringBuilder();
        int i = 0;
        int len = commandLine.Length;

        while (i < len)
        {
            char c = commandLine[i];

            if (c == '"')
            {
                // Double-quoted region — read until closing quote
                i++;
                while (i < len && commandLine[i] != '"')
                {
                    if (commandLine[i] == '\\' && i + 1 < len && commandLine[i + 1] == '"')
                    {
                        current.Append('"');
                        i += 2;
                    }
                    else
                    {
                        current.Append(commandLine[i]);
                        i++;
                    }
                }
                i++; // skip closing quote
            }
            else if (c == '\'')
            {
                // Single-quoted region — read until closing quote (no escapes)
                i++;
                while (i < len && commandLine[i] != '\'')
                {
                    current.Append(commandLine[i]);
                    i++;
                }
                i++; // skip closing quote
            }
            else if (c == '|')
            {
                var op = (i + 1 < len && commandLine[i + 1] == '|') ? "||" : "|";
                result.HasShellOperator = true;
                result.ShellOperator = op;
                return result;
            }
            else if (c == '&')
            {
                var op = (i + 1 < len && commandLine[i + 1] == '&') ? "&&" : "&";
                result.HasShellOperator = true;
                result.ShellOperator = op;
                return result;
            }
            else if (c == ';')
            {
                result.HasShellOperator = true;
                result.ShellOperator = ";";
                return result;
            }
            else if (char.IsWhiteSpace(c))
            {
                // Token boundary
                if (current.Length > 0)
                {
                    tokens.Add(current.ToString());
                    current.Clear();
                }
                i++;
            }
            else
            {
                current.Append(c);
                i++;
            }
        }

        // Flush last token
        if (current.Length > 0)
        {
            tokens.Add(current.ToString());
        }

        if (tokens.Count > 0)
        {
            result.Executable = tokens[0];
            for (int t = 1; t < tokens.Count; t++)
            {
                result.Arguments.Add(tokens[t]);
            }
        }

        return result;
    }
}
