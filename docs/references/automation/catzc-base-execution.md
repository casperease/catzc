# Catzc.Base.Execution

The external-process boundary module. It **owns the complete lifecycle of running an external tool from PowerShell** — logging the exact
command before it executes (see [log-before-invoke](../../adr/automation/log-before-invoke.md)), capturing separated standard output and
error through the native `CliRunner` C# type (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)), managing the
exit-code boundary so a stale code can never leak across a call, and returning a structured `CliResult` when the caller needs to inspect
output programmatically. Every CLI wrapper in the platform funnels through this module; no domain module ever spawns a process directly. It
is a member of the `Base` group alongside [Catzc.Base.Writers](catzc-base-writers.md), [Catzc.Base.Repository](catzc-base-repository.md),
and [Catzc.Base.Asserts](catzc-base-asserts.md).

## Domains

| Domain   | Area      | Name                                                               |
| -------- | --------- | ------------------------------------------------------------------ |
| domain:1 | execution | [External process execution](#domain1--external-process-execution) |
| domain:2 | exit-code | [Exit-code lifecycle](#domain2--exit-code-lifecycle)               |

### domain:1 — External process execution

How an external process is run. One wrapper owns the whole invocation lifecycle: it logs the exact command before it runs (see
[log-before-invoke](../../adr/automation/log-before-invoke.md)), captures separated standard output and error via the native `CliRunner`
type, resets and re-checks the exit code so a stale code can never leak across a call boundary, and supports a dry-run mode that returns the
command string instead of executing it — giving callers a testable, side-effect-free path through the same code. When a call is expected to
run long, a companion function wraps it with a liveness indicator. The `-PassThru` switch returns a `CliResult` object that separates stdout
from stderr for callers that need to inspect output programmatically.

### domain:2 — Exit-code lifecycle

How the exit-code boundary is managed. `$LASTEXITCODE` in PowerShell is global and mutable: a prior external command can leave a non-zero
code that the next call inherits. This domain provides the two primitives the execution domain relies on internally, and that any caller can
use when orchestrating multiple commands: read the current code and reset it to a known state before a new invocation. Together they are the
mechanism that keeps each `Invoke-Executable` call exit-code-clean regardless of what ran before it.

## What the module does

The module is the platform's external-process boundary, and it is built around one invariant: before any tool runs, its full command is
logged. That rule — from [log-before-invoke](../../adr/automation/log-before-invoke.md) — means a failing run is always diagnosable from the
log alone, without reconstructing what was called. `Invoke-Executable` enforces it unconditionally; `Invoke-WithProgress` inherits it by
delegating there.

The process-running machinery lives in the native C# type `Catzc.Base.Execution.CliRunner` (see
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). `CliRunner` is what actually spawns the subprocess and captures its
streams; `Invoke-Executable` is the PowerShell wrapper that adds logging, exit-code hygiene, and dry-run. When the caller passes
`-PassThru`, the result comes back as `Catzc.Base.Execution.CliResult` — a typed object with separated `.Stdout` and `.Stderr` properties
rather than a mixed output stream. Domain module wrappers such as `Invoke-AzCli` use `-PassThru` when they need to parse tool output; plain
script calls omit it and let the streams flow through.

The exit-code domain (domain 2) is a supporting mechanism. `$LASTEXITCODE` is shared state: any external command can leave a non-zero code
behind. `Get-LastExitCode` and `Reset-LastExitCode` give the invocation domain — and any caller that orchestrates a sequence of external
commands — explicit control over that boundary. `Invoke-Executable` always resets before it runs and checks after; callers that compose
multiple calls can use the same primitives to do the same.

The module depends on [Catzc.Base.Writers](catzc-base-writers.md) for the pre-invocation log line and
[Catzc.Base.Asserts](catzc-base-asserts.md) for argument validation. It exposes no configuration files.

## Division

The module's public functions, sorted into the domains above.

| Domain                                | Function              |
| ------------------------------------- | --------------------- |
| domain:1 — External process execution | `Invoke-Executable`   |
|                                       | `Invoke-WithProgress` |
| domain:2 — Exit-code lifecycle        | `Get-LastExitCode`    |
|                                       | `Reset-LastExitCode`  |
