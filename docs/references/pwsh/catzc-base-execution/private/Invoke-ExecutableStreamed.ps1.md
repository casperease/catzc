# pwsh/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a CLI command with live-streamed output, exit code handling, and optional structured output capture.

### description

Private implementation for Invoke-Executable (default mode).

Uses a C# CliRunner class (types/CliRunner.cs) that reads stdout/stderr char-by-char on background threads via Console.Write. Preserves \r
carriage returns (spinners, progress bars) and Unicode. Output bypasses PowerShell's output stream entirely — zero pipeline leaks.

Limitation: ANSI color codes are NOT preserved. When stdout is redirected to a pipe (which Process does internally), most CLI tools detect
this via isatty() and disable colored output. This is a fundamental OS-level constraint — the child process never emits the escape
sequences. Solving this would require ConPTY (pseudo-terminal). Use -Direct when colors are important and pipeline leaks are acceptable.

### parameter `Command`

The command string to execute.

### parameter `WorkingDirectory`

The directory to run the command in.

### parameter `PassThru`

Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.

### parameter `NoAssert`

Skip the exit code assertion.

### parameter `Silent`

Suppress all console output. Output is still captured for -PassThru.

### parameter `TimeoutSeconds`

The run's time limit. Past it CliRunner kills the process tree and throws a TimeoutException.

### parameter `DrainSeconds`

How long CliRunner waits for the output to end after the process exits. Past it CliRunner throws an IOException naming a process the command
started that still holds the output open.

### parameter `AsBytes`

Capture stdout as its exact bytes (CliResult.Bytes) instead of text, with no console echo — for a binary stream. Returns the CliResult as
-PassThru does.

### parameter `InputText`

Written to the child's stdin, which is then closed; absent, stdin is left as before.

### parameter `DryRun`

Return the command string without executing.

## comment:1

Above `$suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name...`, written with `#`.

```text
During a Pester run, also suppress the child's streamed output. CliRunner echoes stdout/stderr via
Console.Write, which bypasses the Write-Message/Write-Object suppression (so a real tool's chatter —
e.g. an `az bicep` upgrade nag — would otherwise leak into test logs). Output is still captured into
the result, so -PassThru and the exit-code assertion are unaffected. Same global the writers read,
set by Test-Automation. Read through Get-Variable: the flag is unset outside a test run, and strict mode
rejects an unset variable even when scope-qualified.
```
