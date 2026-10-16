---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/types/CliRunner.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a48373545e11
---

# automation/Catzc.Base.Execution/types/CliRunner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A streaming process runner: it parses a command string and runs the executable directly (no shell, via
CreateProcess/fork+exec), streaming stdout/stderr to the console char-by-char on background threads while
also capturing them. The instance is both the runner and its own result — Run/RunDirect populate the
three captured fields below. Every run is inside a time safeguard: a process that outlives its limit is killed
with its whole tree and the run throws a TimeoutException (the limit comes from timeouts.yml, resolved by the
caller through Get-TimeoutSeconds).
```

## comment:2

Above `public byte[] StdoutBytes { get; private set; }`, written with `//`.

```text
The captured stdout as the exact bytes the process wrote — set by RunBytes only (null for a text run), for
a binary stream such as `git cat-file --batch`, whose object sizes count bytes, not characters.
```

## comment:3

Above `public static CliRunner Run(string commandLine, bool silent, string...`, written with `///`.

```text
<summary>
Runs a command string. Parses it into executable + arguments and runs
directly (no shell). Throws if shell operators (|, &amp;&amp;, ||, ;) are detected,
and throws a TimeoutException (after killing the process tree) when the run
outlives timeoutSeconds.
</summary>
```

## comment:4

Above `public static CliRunner RunBytes(string commandLine, string workingDirectory,...`, written with `///`.

```text
<summary>
Runs a command string silently and captures its stdout as raw bytes (StdoutBytes) — no decoding, no
console echo — for a binary stream. Stderr is captured as text. Same single-command rule and time
safeguard as Run; stdin is empty and closed.
</summary>
```

## comment:5

Above `public static string ExecutableName(string commandLine)`, written with `///`.

```text
<summary>
The executable a command string runs (its first token, quotes removed), or an
empty string for a blank command — the name its time limit is looked up by.
</summary>
```

## comment:6

Above `var psi = NewStartInfo(executable, arguments, workingDirectory,...`, written with `//`.

```text
A child inheriting a stdin pipe that another thread is blocked reading hangs at startup (Git for
Windows probes its std handles). Whenever no person can answer a prompt anyway (a silent run, or
a caller whose stdin is not a terminal), the child gets an empty, closed stdin and reads EOF. A
visible run from a terminal keeps it, so interactive prompts still work.
```

## comment:7

Above `var psi = new ProcessStartInfo`, written with `//`.

```text
Resolve the executable on PATH. Process.Start with UseShellExecute=false
doesn't resolve .cmd/.bat/.ps1 extensions — only exact filenames.
Tools like az, poetry, npm, pyspark are .cmd scripts on Windows.
```

## comment:8

Above `private static Thread Reader(Action read)`, written with `//`.

```text
An output reader: a background thread, so one still blocked on a pipe a leftover process holds can never keep
the host alive, and one that swallows the error a disposed stream raises, since an exception escaping a thread
would end the host.
```

## comment:9

Above `private static readonly TimeSpan DrainLimit = TimeSpan.FromSeconds(5);`, written with `//`.

```text
How long the output readers may take to reach end-of-stream once the process has exited. The rest of a
finished process's output drains in milliseconds; a reader still blocked after this is waiting on a pipe
that a process the command started (a detached server, a grandchild) still holds open.
```

## comment:10

Above `private static void Supervise(string commandLine, Process process, int...`, written with `//`.

```text
Waits for the process within its time limit, then — bounded too — for its output readers. Past the limit it
kills the whole tree and throws a TimeoutException. A reader the pipe never releases fails the run with an
IOException naming the cause, instead of hanging the caller for that holder's lifetime.
```

## comment:11

Above `private static string ResolveExecutable(string name)`, written with `///`.

```text
<summary>
Resolves a command name to a full path by searching PATH with
common executable extensions. On Windows, checks .exe, .cmd, .bat,
.com in order (matching cmd.exe PATHEXT behavior). On Unix, checks
the bare name (executables have no extension convention).
Returns the original name if already a full path or not found.
</summary>
```

## comment:12

Above `private static ParsedCommand ParseCommand(string commandLine)`, written with `///`.

```text
<summary>
Splits a command string into executable + arguments.
Handles single and double quoted regions.
Detects unquoted | && || which require shell execution.
</summary>
```
