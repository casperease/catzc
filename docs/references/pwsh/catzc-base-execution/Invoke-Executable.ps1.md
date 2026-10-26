# pwsh/Base.Execution/Invoke-Executable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a CLI command with exit code handling, stream separation, and optional structured output capture.

### description

Central wrapper for external tool invocation.

Default: Live-streams output to the console via a C# process runner that reads char-by-char (preserves spinners, progress bars, \r). Output
bypasses PowerShell's pipeline — zero leaks. With -PassThru, returns a Catzc.Base.Execution.CliResult object with separated stdout/stderr.
Note: ANSI colors are lost — child processes disable them when stdout is a pipe (isatty check). Use -Direct when colors matter.

-Direct: Like typing the command at the prompt. Full color, full fidelity. Output flows to the console AND the pipeline — leaks into
caller's return value. Use for interactive commands or when colors are important.

Both modes share the same LASTEXITCODE lifecycle (reset before, assert after, reset after). -PassThru returns a
Catzc.Base.Execution.CliResult object:

```text
.Output   — stdout only (string)
.Errors   — stderr only (string)
.Full     — both merged in original order (string)
.ExitCode — raw exit code (int)
.Raw      — unprocessed output array
```

-PassThru and -Direct are mutually exclusive (separate parameter sets).

The default (Stream) mode runs inside a time safeguard: a process that outlives its limit is killed with its whole tree and the call throws
a TimeoutException. The limit is the executable's entry in timeouts.yml, or the run environment's pwsh limit (Get-TimeoutSeconds);
-TimeoutSeconds sets it for one call. -Direct is the interactive mode — a person at the prompt is its safeguard — so it has no limit.

### parameter `Command`

The command string to execute.

### parameter `Direct`

Raw execution with full color support. Output leaks to the pipeline. Use when colors matter or for interactive commands.

### parameter `PassThru`

Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw. Not compatible with -Direct.

### parameter `AsBytes`

Capture stdout as its exact bytes, for a binary stream such as `git cat-file --batch`: returns the CliResult with stdout in .Bytes (and an
empty .Output), never echoed to the console. Not compatible with -Direct.

### parameter `TimeoutSeconds`

The time limit for this call, in seconds. Defaults to the executable's limit from timeouts.yml (Get-TimeoutSeconds). Not compatible with
-Direct.

### parameter `DrainSeconds`

How long to wait, after the process exits, for its output to end; past it the call throws, naming a process the command started that still
holds the output open. Defaults to wait.drain_seconds of timeouts.yml. Not compatible with -Direct.

### parameter `InputText`

Written to the child's stdin, which is then closed: how one process reads a list that would overflow the command line.

### parameter `NoAssert`

Skip the exit code assertion. The ExitCode is still available on the result object when combined with -PassThru.

### parameter `Silent`

Suppress the command log line and all console output. A silent run is non-interactive: the child gets an empty, closed stdin, so a prompt
fails instead of waiting invisibly. A visible run gets the same when this session's stdin is not a terminal (a worker, an agent, a pipe),
since no one could answer a prompt there.

### parameter `WorkingDirectory`

The directory to run the command in. Defaults to the repository root
($env:RepositoryRoot). Callers that need a specific directory should
pass it explicitly rather than relying on $PWD.

### parameter `DryRun`

Return the command string without executing. Used for testing.

### example 1

```powershell
Invoke-Executable 'python --version'
```

### example 2

```powershell
Invoke-Executable 'winget install --id Python.Python.3.11' -Direct
```

### example 3

```powershell
$result = Invoke-Executable 'az account show --output json' -PassThru
$result.Output | ConvertFrom-Json
```

### example 4

```powershell
$result = Invoke-Executable 'terraform apply' -PassThru
$result.ExitCode
```

### example 5

```powershell
Invoke-Executable 'python --version' -DryRun
```

## comment:1

Above `function Invoke-Executable {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT](/docs/drs/automation/dry-run.md#rule-adr-auto-dryrun-branchbeforesideeffect).
```

## comment:2

Above `if (-not $DryRun -and (Test-RealProcessBlocked)) {`, written with `#`.

```text
Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this
throws). When a run sets $env:CATZC_BLOCK_REAL_PROCESS (1 for every launch, tier for the L0 and L1
Describes alone, Test-RealProcessBlocked), a real process launch there means a Mock failed to
intercept — almost always a -ModuleName pointing at the wrong module — so the test was silently
hitting the live tool. Fail loudly instead. -DryRun is exempt (it never launches).
See [ADR-AUTO-TEST](/docs/drs/automation/test-automation.md).
```
