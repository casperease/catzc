---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md
    kind: comment-page
    body_sha: "4a8deb0c1258"
    adrs:
      - ADR-AUTO-DRYRUN#2
    links: []
---

# automation/Catzc.Base.Execution/Invoke-Executable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Central wrapper for external tool invocation.

Default: Live-streams output to the console via a C# process runner
that reads char-by-char (preserves spinners, progress bars, \r).
Output bypasses PowerShell's pipeline — zero leaks. With -PassThru,
returns a Catzc.Base.Execution.CliResult object with separated stdout/stderr.
Note: ANSI colors are lost — child processes disable them when stdout
is a pipe (isatty check). Use -Direct when colors matter.

-Direct: Like typing the command at the prompt. Full color, full
fidelity. Output flows to the console AND the pipeline — leaks into
caller's return value. Use for interactive commands or when colors
are important.

Both modes share the same LASTEXITCODE lifecycle (reset before, assert
after, reset after). -PassThru returns a Catzc.Base.Execution.CliResult object:
  .Output   — stdout only (string)
  .Errors   — stderr only (string)
  .Full     — both merged in original order (string)
  .ExitCode — raw exit code (int)
  .Raw      — unprocessed output array

-PassThru and -Direct are mutually exclusive (separate parameter sets).

The default (Stream) mode runs inside a time safeguard: a process that outlives its limit is killed with its
whole tree and the call throws a TimeoutException. The limit is the executable's entry in timeouts.yml, or
the run environment's pwsh limit (Get-TimeoutSeconds); -TimeoutSeconds sets it for one call. -Direct is the interactive
mode — a person at the prompt is its safeguard — so it has no limit.
```

## comment:2

Section `.PARAMETER Direct` of the comment-based help.

```text
Raw execution with full color support. Output leaks to the pipeline.
Use when colors matter or for interactive commands.
```

## comment:3

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
Not compatible with -Direct.
```

## comment:4

Section `.PARAMETER AsBytes` of the comment-based help.

```text
Capture stdout as its exact bytes, for a binary stream such as `git cat-file --batch`: returns the CliResult
with stdout in .Bytes (and an empty .Output), never echoed to the console. Not compatible with -Direct.
```

## comment:5

Section `.PARAMETER NoAssert` of the comment-based help.

```text
Skip the exit code assertion. The ExitCode is still available on the
result object when combined with -PassThru.
```

## comment:6

Section `.PARAMETER Silent` of the comment-based help.

```text
Suppress the command log line and all console output. A silent run is non-interactive: the child gets an
empty, closed stdin, so a prompt fails instead of waiting invisibly. A visible run gets the same when this
session's stdin is not a terminal (a worker, an agent, a pipe), since no one could answer a prompt there.
```

## comment:7

Section `.PARAMETER WorkingDirectory` of the comment-based help.

```text
The directory to run the command in. Defaults to the repository root
($env:RepositoryRoot). Callers that need a specific directory should
pass it explicitly rather than relying on $PWD.
```

## comment:8

Section `.PARAMETER TimeoutSeconds` of the comment-based help.

```text
The time limit for this call, in seconds. Defaults to the executable's limit from timeouts.yml
(Get-TimeoutSeconds). Not compatible with -Direct.
```

## comment:9

Above `function Invoke-Executable {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:10

Above `if ($env:CATZC_BLOCK_REAL_PROCESS -and -not $DryRun) {`.

```text
Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this
throws). When a unit (L1) run sets $env:CATZC_BLOCK_REAL_PROCESS, a real process launch means a Mock
failed to intercept — almost always a -ModuleName pointing at the wrong module — so the test was
silently hitting the live tool. Fail loudly instead. -DryRun is exempt (it never launches).
See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md).
```
