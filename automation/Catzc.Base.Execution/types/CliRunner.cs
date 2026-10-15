// A streaming process runner: it parses a command string and runs the executable directly (no shell, via CreateProcess/fork+exec),...
// [comment:1](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading;

namespace Catzc.Base.Execution;

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

    // The captured stdout as the exact bytes the process wrote — set by RunBytes only (null for a text run), for a binary stream such as...
    // [comment:2](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment2)
    public byte[] StdoutBytes { get; private set; }

    /// <summary> Runs a command string.
    /// [comment:3](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment3)
    public static CliRunner Run(string commandLine, bool silent, string workingDirectory, int timeoutSeconds)
    {
        if (timeoutSeconds <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(timeoutSeconds), "every run needs a positive time limit");
        }

        var parsed = ParseCommand(commandLine);

        if (parsed.HasShellOperator)
        {
            throw new InvalidOperationException(
                $"Invoke-Executable runs a single command — shell operators ({parsed.ShellOperator}) are not supported. " +
                "Break the command into separate Invoke-Executable calls, or use -Direct for shell expressions.");
        }

        return RunDirect(commandLine, parsed.Executable, parsed.Arguments, silent, workingDirectory, timeoutSeconds);
    }

    /// <summary> Runs a command string silently and captures its stdout as raw bytes (StdoutBytes) — no decoding, no console echo — for...
    /// [comment:4](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment4)
    public static CliRunner RunBytes(string commandLine, string workingDirectory, int timeoutSeconds)
    {
        if (timeoutSeconds <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(timeoutSeconds), "every run needs a positive time limit");
        }

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

            Supervise(commandLine, process, timeoutSeconds, stdoutThread, stderrThread);
            runner.ExitCode = process.ExitCode;
        }

        runner.StdoutBytes = stdout.ToArray();
        runner.Stdout = string.Empty;
        runner.Stderr = stderrSb.ToString();
        return runner;
    }

    /// <summary> The executable a command string runs (its first token, quotes removed), or an empty string for a blank command — the...
    /// [comment:5](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment5)
    public static string ExecutableName(string commandLine)
    {
        return ParseCommand(commandLine ?? "").Executable ?? "";
    }

    private static CliRunner RunDirect(string commandLine, string executable, List<string> arguments, bool silent,
        string workingDirectory, int timeoutSeconds)
    {
        var runner = new CliRunner();
        var stdoutSb = new StringBuilder();
        var stderrSb = new StringBuilder();

        // A child inheriting a stdin pipe that another thread is blocked reading hangs at startup (Git for Windows probes its std handles).
        // [comment:6](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment6)
        var psi = NewStartInfo(executable, arguments, workingDirectory, redirectInput: silent || Console.IsInputRedirected);

        return Execute(commandLine, psi, stdoutSb, stderrSb, silent, timeoutSeconds, runner);
    }

    private static ProcessStartInfo NewStartInfo(string executable, List<string> arguments, string workingDirectory,
        bool redirectInput)
    {
        // Resolve the executable on PATH.
        // [comment:7](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment7)
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

    // An output reader: a background thread, so one still blocked on a pipe a leftover process holds can never keep the host alive, and...
    // [comment:8](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment8)
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

    // How long the output readers may take to reach end-of-stream once the process has exited.
    // [comment:9](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment9)
    private static readonly TimeSpan DrainLimit = TimeSpan.FromSeconds(5);

    // Waits for the process within its time limit, then — bounded too — for its output readers.
    // [comment:10](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment10)
    private static void Supervise(string commandLine, Process process, int timeoutSeconds, Thread stdoutThread,
        Thread stderrThread)
    {
        if (!process.WaitForExit(TimeSpan.FromSeconds(timeoutSeconds)))
        {
            process.Kill(entireProcessTree: true);
            process.WaitForExit();
            stdoutThread.Join(DrainLimit);
            stderrThread.Join(DrainLimit);
            throw new TimeoutException(
                $"Killed '{commandLine}' after {timeoutSeconds}s: it did not finish within its time limit. " +
                "Make it faster, or raise the limit: pass -TimeoutSeconds, or tune the executable's entry in " +
                "automation/Catzc.Base.Timeouts/configs/timeouts.yml.");
        }

        process.WaitForExit();
        var drained = stdoutThread.Join(DrainLimit) & stderrThread.Join(DrainLimit);
        if (!drained)
        {
            throw new IOException(
                $"'{commandLine}' exited (code {process.ExitCode}), but a process it started still holds its output open, " +
                $"so the output never ended (waited {DrainLimit.TotalSeconds:0}s after exit). Stop that process from " +
                "inheriting the output: for a dotnet build, pass --disable-build-servers.");
        }
    }

    private static CliRunner Execute(string commandLine, ProcessStartInfo psi, StringBuilder stdoutSb,
        StringBuilder stderrSb, bool silent, int timeoutSeconds, CliRunner runner)
    {
        var previousEncoding = Console.OutputEncoding;

        try
        {
            Console.OutputEncoding = Encoding.UTF8;

            using (var process = new Process { StartInfo = psi })
            {
                process.Start();
                if (psi.RedirectStandardInput)
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

                Supervise(commandLine, process, timeoutSeconds, stdoutThread, stderrThread);

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

    /// <summary> Resolves a command name to a full path by searching PATH with common executable extensions.
    /// [comment:11](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment11)
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

    /// <summary> Splits a command string into executable + arguments.
    /// [comment:12](/docs/references/automation/catzc-base-execution/types/CliRunner.cs.md#comment12)
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
