// A streaming process runner: it parses a command string and runs the executable directly (no shell, via
// CreateProcess/fork+exec), streaming stdout/stderr to the console char-by-char on background threads while
// also capturing them. The instance is both the runner and its own result — Run/RunDirect populate the
// three captured fields below. Every run is inside a time safeguard: a process that outlives its limit is killed
// with its whole tree and the run throws a TimeoutException (the limit comes from timeouts.yml, resolved by the
// caller through Get-TimeoutSeconds).

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

    // The captured stdout as the exact bytes the process wrote — set by RunBytes only (null for a text run), for
    // a binary stream such as `git cat-file --batch`, whose object sizes count bytes, not characters.
    public byte[] StdoutBytes { get; private set; }

    /// <summary>
    /// Runs a command string. Parses it into executable + arguments and runs
    /// directly (no shell). Throws if shell operators (|, &amp;&amp;, ||, ;) are detected,
    /// and throws a TimeoutException (after killing the process tree) when the run
    /// outlives timeoutSeconds.
    /// </summary>
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

    /// <summary>
    /// Runs a command string silently and captures its stdout as raw bytes (StdoutBytes) — no decoding, no
    /// console echo — for a binary stream. Stderr is captured as text. Same single-command rule and time
    /// safeguard as Run; stdin is empty and closed.
    /// </summary>
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

    /// <summary>
    /// The executable a command string runs (its first token, quotes removed), or an
    /// empty string for a blank command — the name its time limit is looked up by.
    /// </summary>
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

        // A child inheriting a stdin pipe that another thread is blocked reading hangs at startup (Git for
        // Windows probes its std handles). Whenever no person can answer a prompt anyway (a silent run, or
        // a caller whose stdin is not a terminal), the child gets an empty, closed stdin and reads EOF. A
        // visible run from a terminal keeps it, so interactive prompts still work.
        var psi = NewStartInfo(executable, arguments, workingDirectory, redirectInput: silent || Console.IsInputRedirected);

        return Execute(commandLine, psi, stdoutSb, stderrSb, silent, timeoutSeconds, runner);
    }

    private static ProcessStartInfo NewStartInfo(string executable, List<string> arguments, string workingDirectory,
        bool redirectInput)
    {
        // Resolve the executable on PATH. Process.Start with UseShellExecute=false
        // doesn't resolve .cmd/.bat/.ps1 extensions — only exact filenames.
        // Tools like az, poetry, npm, pyspark are .cmd scripts on Windows.
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

    // An output reader: a background thread, so one still blocked on a pipe a leftover process holds can never keep
    // the host alive, and one that swallows the error a disposed stream raises, since an exception escaping a thread
    // would end the host.
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

    // How long the output readers may take to reach end-of-stream once the process has exited. The rest of a
    // finished process's output drains in milliseconds; a reader still blocked after this is waiting on a pipe
    // that a process the command started (a detached server, a grandchild) still holds open.
    private static readonly TimeSpan DrainLimit = TimeSpan.FromSeconds(5);

    // Waits for the process within its time limit, then — bounded too — for its output readers. Past the limit it
    // kills the whole tree and throws a TimeoutException. A reader the pipe never releases fails the run with an
    // IOException naming the cause, instead of hanging the caller for that holder's lifetime.
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

    /// <summary>
    /// Resolves a command name to a full path by searching PATH with
    /// common executable extensions. On Windows, checks .exe, .cmd, .bat,
    /// .com in order (matching cmd.exe PATHEXT behavior). On Unix, checks
    /// the bare name (executables have no extension convention).
    /// Returns the original name if already a full path or not found.
    /// </summary>
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

    /// <summary>
    /// Splits a command string into executable + arguments.
    /// Handles single and double quoted regions.
    /// Detects unquoted | && || which require shell execution.
    /// </summary>
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
