# Catzc.Base.Execution

The external-process boundary module. It **owns the complete lifecycle of running an external tool from PowerShell** — logging the exact
command before it executes (see [log-before-invoke](../../../drs/automation/log-before-invoke.md)), capturing separated standard output and
error through the native `CliRunner` C# type (see [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md)), managing the
exit-code boundary so a stale code can never leak across a call, and returning a structured `CliResult` when the caller needs to inspect
output programmatically. It also locates an executable and confirms its version before anything runs it, so a caller runs a managed tool by
its path and never by a bare name. Every CLI wrapper in the platform funnels through this module; no feature module ever spawns a process
directly. It is a member of the `Base` group alongside [Catzc.Base.Writers](../base-writers/index.md),
[Catzc.Base.Repository](../base-repository/index.md), and [Catzc.Base.Asserts](../base-asserts/index.md).

## Responsibilities

| Responsibility   | Area      | Name                                                                       |
| ---------------- | --------- | -------------------------------------------------------------------------- |
| responsibility:1 | execution | [External process execution](#responsibility1--external-process-execution) |
| responsibility:2 | location  | [Executable location](#responsibility2--executable-location)               |
| responsibility:3 | exit-code | [Exit-code lifecycle](#responsibility3--exit-code-lifecycle)               |

### responsibility:1 — External process execution

How an external process is run. One wrapper owns the whole invocation lifecycle: it logs the exact command before it runs (see
[log-before-invoke](../../../drs/automation/log-before-invoke.md)), captures separated standard output and error via the native `CliRunner`
type, resets and re-checks the exit code so a stale code can never leak across a call boundary, and supports a dry-run mode that returns the
command string instead of executing it — giving callers a testable, side-effect-free path through the same code. When a call is expected to
run long, a companion function wraps it with a liveness indicator. The `-PassThru` switch returns a `CliResult` object that separates stdout
from stderr for callers that need to inspect output programmatically, and `-AsBytes` returns stdout as its exact bytes for a binary stream
such as `git cat-file --batch`. Every run is bounded twice: a process that outlives its time limit is killed with its whole tree, and a
process that exits while something it started still holds its output open fails at once with an error that names the cause, instead of
hanging for that holder's lifetime.

### responsibility:2 — Executable location

Where an executable is and which version it is, answered cheaply and timed. The locate step starts no process: the first existing candidate
path wins, then PATH, and an excluded path never counts (for bash on Windows, the WSL launcher). Only a located executable runs its version
command, once per executable file per session (a lazy cache entry keyed by its path and last write time, see
[script-scope-caching](../../../drs/automation/pwsh/script-scope-caching.md)), so a reinstall is seen on the next check. The answer is one
record: found, path, method, version against the required one, the two timings, and the session actor. For a tool declared in `tools.yml`,
the module reads the entry itself — the candidates for the running platform and run environment, the exclusions, the version command and
pin, and the devbox version lever outside a pipeline — so a Base module locates a managed tool without depending on the tooling modules. The
module owns `tools.yml` and its `ToolsConfig`/`ToolConfig` types: the module furthest down the stack that reads the lock file owns it, so
every bundle that can run a process can also resolve the tools it runs. An execution engine's executable is located the way the engine model
says ([ADR-AUTO-ENGINE](../../../drs/automation/execution-engines.md)): pwsh beside the running PowerShell, never through PATH, and bash
through its `tools.yml` entry.

### responsibility:3 — Exit-code lifecycle

How the exit-code boundary is managed. `$LASTEXITCODE` in PowerShell is global and mutable: a prior external command can leave a non-zero
code that the next call inherits. This responsibility provides the two primitives the execution responsibility relies on internally, and
that any caller can use when orchestrating multiple commands: read the current code and reset it to a known state before a new invocation.
Together they are the mechanism that keeps each `Invoke-Executable` call exit-code-clean regardless of what ran before it.

## What the module does

The module is the platform's external-process boundary, and it is built around one invariant: before any tool runs, its full command is
logged. That rule — from [log-before-invoke](../../../drs/automation/log-before-invoke.md) — means a failing run is always diagnosable from the
log alone, without reconstructing what was called. `Invoke-Executable` enforces it unconditionally; `Invoke-WithProgress` inherits it by
delegating there.

The process-running machinery lives in the native C# type `Catzc.Base.Execution.CliRunner` (see
[native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md)). `CliRunner` is what actually spawns the subprocess and captures its
streams; `Invoke-Executable` is the PowerShell wrapper that adds logging, exit-code hygiene, and dry-run. When the caller passes
`-PassThru`, the result comes back as `Catzc.Base.Execution.CliResult` — a typed object with separated `.Stdout` and `.Stderr` properties
rather than a mixed output stream. Feature module wrappers such as `Invoke-AzCli` use `-PassThru` when they need to parse tool output; plain
script calls omit it and let the streams flow through.

Executable location sits in front of execution. The generic check takes plain inputs and returns the `Catzc.Base.Execution.ExecutableProbe`
record; its version run goes through `Invoke-Executable` like any other process start. The tools.yml reading on top of it is global config
access, never guarded by module dependencies (see [module-config-loading](../../../drs/configuration/module-config-loading.md)), which is what
lets the tooling modules' presence checks ([Catzc.Tooling.Core](../tooling-core/index.md)) and the Base modules share one record and one
reading of an entry.

The exit-code responsibility (responsibility 3) is a supporting mechanism. `$LASTEXITCODE` is shared state: any external command can leave a
non-zero code behind. `Reset-LastExitCode` gives the invocation responsibility — and any caller that orchestrates a sequence of external
commands — explicit control over that boundary. `Invoke-Executable` always resets before it runs and checks after; callers that compose
multiple calls can use the same primitives to do the same.

The module depends on [Catzc.Base.Writers](../base-writers/index.md) for the pre-invocation log line,
[Catzc.Base.Repository](../base-repository/index.md) for the run environment and the session actor, and
[Catzc.Base.Asserts](../base-asserts/index.md) for argument validation. Its one configuration file is `tools.yml`, the tool lock file the
tooling modules read as well.

The diagram below draws process invocation from the source. It has two paths. The default streamed path runs through the C# runner under the
executable's time limit from `timeouts.yml`, and kills the process tree when the limit runs out. The direct path, for interactive use, hands
the command to the console with no time limit.

```yml drawio
description:
  "Invoke-Executable forks by parameter set: the streamed path looks up the executable's time limit and runs it through the C# runner, which
  kills the process tree when the limit runs out; the direct path runs through Invoke-Expression with no time limit."
about:
  adrs: [ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT, ADR-AUTO-TEST, ADR-PWSH-ASSERT-DECLAREDTIMELIMIT]
  lens: source
content:
  title: "Invoke-Executable: only the streamed path is time-bounded"
  kind: reference
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-stream, label: STREAM }
    - { id: band-direct, label: DIRECT }
  groups:
    - { id: grp-timeouts, label: Catzc.Base.Timeouts, in: band-stream }
  glyphs:
    - { id: g-invoke, kind: code, label: Invoke-Executable, in: band-entry }
    - { id: g-timeout, kind: code, label: Get-TimeoutSeconds, in: grp-timeouts }
    - { id: f-timeouts-yml, kind: file, label: timeouts.yml, in: grp-timeouts }
    - { id: g-streamed, kind: private, label: Invoke-ExecutableStreamed, in: band-stream }
    - { id: t-runner, kind: type, label: CliRunner, in: band-stream }
    - { id: f-kill, kind: failure, label: Kill · TimeoutException, in: band-stream }
    - { id: g-direct, kind: private, label: Invoke-ExecutableDirect, in: band-direct }
    - { id: g-expression, kind: code, label: Invoke-Expression, in: band-direct }
    - { id: n-no-limit, kind: drsonly, label: no time limit, in: band-direct }
  edges:
    - { from: g-invoke, to: g-timeout, kind: flow, label: calls }
    - { from: g-timeout, to: g-streamed, kind: flow, label: feeds }
    - { from: g-streamed, to: t-runner, kind: flow, label: calls }
    - { from: t-runner, to: f-kill, kind: fail, label: "" }
    - { from: g-invoke, to: g-direct, kind: flow, label: calls }
    - { from: g-direct, to: g-expression, kind: flow, label: calls }
  markers:
    - { at: g-invoke, number: 1 }
    - { at: g-timeout, number: 2 }
    - { at: g-streamed, number: 3 }
    - { at: t-runner, number: 4 }
    - { at: f-kill, number: 5 }
    - { at: g-direct, number: 6 }
    - { at: g-expression, number: 7 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-entry: { x: 20, y: 84, w: 380, h: 310 }
  band-stream: { x: 420, y: 84, w: 860, h: 190 }
  band-direct: { x: 420, y: 294, w: 860, h: 100 }
  g-invoke: { x: 160, y: 230, w: 170, h: 40 }
  grp-timeouts: { x: 440, y: 108, w: 200, h: 158 }
  g-timeout: { x: 455, y: 148, w: 170, h: 40 }
  f-timeouts-yml: { x: 485, y: 204, w: 110, h: 50 }
  g-streamed: { x: 680, y: 148, w: 200, h: 40 }
  t-runner: { x: 925, y: 148, w: 120, h: 40 }
  f-kill: { x: 1092, y: 146, w: 178, h: 44 }
  g-direct: { x: 680, y: 328, w: 200, h: 40 }
  g-expression: { x: 925, y: 328, w: 150, h: 40 }
  n-no-limit: { x: 1110, y: 328, w: 140, h: 40 }
```

![Invoke-Executable: only the streamed path is time-bounded](../.assets/invoke-executable-two-paths-one-bounded.drawio.png)

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                | Function                   |
| --------------------------------------------- | -------------------------- |
| responsibility:1 — External process execution | `Invoke-Executable`        |
|                                               | `Invoke-WithProgress`      |
| responsibility:2 — Executable location        | `Find-Executable`          |
|                                               | `Resolve-ToolExecutable`   |
|                                               | `Resolve-EngineExecutable` |
| config                                        | `tools.yml`                |
| responsibility:3 — Exit-code lifecycle        | `Reset-LastExitCode`       |
