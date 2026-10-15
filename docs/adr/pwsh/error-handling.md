---
catzc:
  derived:
    path: docs/adr/pwsh/error-handling.md
    kind: adr
    body_sha: d289b074815d
    defines:
      - ADR-PWSH-ERROR#{1-3,5,7-11}
    adrs:
      - ADR-AUTO-FAILFAST#4
      - ADR-AUTO-ONEJOB#6
      - ADR-AUTO-RETRY#{1,5,6}
    links:
      - docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast4
      - docs/adr/automation/retry-as-last-resort.md
      - docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5
      - docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob6
      - docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert4
      - docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4
---

# ADR: Error handling — fail immediately, no warnings

## Rules: ADR-PWSH-ERROR

### Rule ADR-PWSH-ERROR:1

Set `$ErrorActionPreference = 'Stop'` globally (the importer does this); never change it inside a function.

- [Why no Write-Error](#why-no-write-error)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-ERROR:2

Set `$WarningPreference = 'Stop'` globally so every warning terminates; suppress an unavoidable third-party warning with
`-WarningAction SilentlyContinue` on that one call only.

- [Why no warnings](#why-no-warnings)
- [The -AllowWarnings escape hatch](#the--allowwarnings-escape-hatch)

### Rule ADR-PWSH-ERROR:3

Use `throw` for errors, never `Write-Error` — `throw` always terminates, while `Write-Error` depends on the caller's preference and may not
stop execution.

- [Why no Write-Error](#why-no-write-error)

### Rule ADR-PWSH-ERROR:5

Never use `Write-Warning`. If something is wrong, throw; if it is informational, use `Write-Message` or `Write-Verbose`.

- [Why no warnings](#why-no-warnings)

### Rule ADR-PWSH-ERROR:7

In scripts, add `trap { Write-Exception $_; break }` after the importer for full stack traces on unhandled errors, matching the interactive
prompt hook.

- [Interactive error diagnostics](#interactive-error-diagnostics)

### Rule ADR-PWSH-ERROR:8

All code is written strict-clean, because it runs under `Set-StrictMode -Version Latest`: take the first element of a result that may be
empty with `<result> | Select-Object -First 1`, never `@(<result>)[0]`; wrap a producer in `@()` before reading `.Count`; read an optional
key through `.Contains()`, an indexer, or the typed config record, never as a bare property.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-ERROR:9

In pwsh, the ambient state ADR-AUTO-ONEJOB#6 protects is the preference variables (`$ErrorActionPreference` first), the location, `$env:`
variables, and `$global:` variables. A function that needs a different error behaviour for one call passes `-ErrorAction` to that call. A
temporary change is made inside `try` and undone in its `finally` — `Push-Location` paired with `Pop-Location`, a saved value written back —
so it is restored when the body throws too.

- [Temporary state](#temporary-state)

### Rule ADR-PWSH-ERROR:10

In pwsh, a test never retries (ADR-AUTO-RETRY#1): no loop or retry wrapper around a call inside an `It`, and no re-run of a failed Pester
run. An external dependency is replaced with `Mock`, or the test is tagged `L3` and marks itself skipped with
`Set-ItResult -Skipped -Because '<reason>'` when its dependency is unavailable.

- [Retry](#retry)

### Rule ADR-PWSH-ERROR:11

In pwsh, the retry wrapper of ADR-AUTO-RETRY#6 is its own function that takes the one operation to repeat as a `[scriptblock]` parameter,
with an explicit attempt count and delay, writes each retry with `Write-Message -Warning` (ADR-AUTO-RETRY#5; never `Write-Warning`,
ADR-PWSH-ERROR#5), and rethrows the last error unchanged when the attempts run out. The function that does the work holds no retry loop and
no `catch` that repeats a call.

- [Retry](#retry)

## Context

PowerShell has a complex error handling model: terminating errors, non-terminating errors, `$ErrorActionPreference`, `$WarningPreference`,
`-ErrorAction` per call, error records, warning records, and multiple output streams. Most PowerShell code uses a subset of this
incorrectly, leading to errors that are swallowed, warnings that nobody reads, and failures that surface far from their origin.

### The two-state model

We simplify this to two states:

1. **Everything is fine.** Execution continues. Output goes through `Write-Message` and `Write-Verbose`.
2. **Something is wrong.** Execution stops immediately via `throw` or `Assert-*`. The error propagates to the caller with a clear message.

There is no middle ground. No warnings, no non-terminating errors, no "something went wrong but let's keep going." Code that continues after
a problem is code that operates on corrupted state.

### Why no warnings

`Write-Warning` is PowerShell's way of saying "this might be a problem but I will continue anyway." In practice this means:

- **Nobody reads them.** Warnings scroll past in interactive use and get buried in CI logs. If the script succeeded, nobody goes back to
  check for yellow text.

- **They hide bugs.** A warning that fires on every run becomes invisible background noise. The one time it signals a real problem, it is
  lost among the habitual warnings the team has learned to ignore.

- **They create ambiguity.** Did the script succeed or not? It produced output and returned exit code 0, but there were warnings. Should the
  pipeline proceed? Should the user investigate? Nobody knows, so everybody ignores it.

The importer sets `$WarningPreference = 'Stop'`, which turns every `Write-Warning` call into a terminating error. This is deliberate — if a
condition is wrong enough to warn about, it is wrong enough to stop.

### Why no Write-Error

`Write-Error` creates a non-terminating error record. Whether it actually stops execution depends on `$ErrorActionPreference`, which varies
by context. This ambiguity is the root cause of most PowerShell error handling bugs: the author wrote `Write-Error` expecting it to stop,
but the caller's preference was `Continue`, so execution continued with bad state.

`throw` is unambiguous. It always terminates. The importer also sets `$ErrorActionPreference = 'Stop'` so that cmdlet errors (which use the
non-terminating error mechanism internally) also terminate. Between `throw` and `$ErrorActionPreference = 'Stop'`, every error is fatal.

### The Assert-* pattern

A precondition is checked with the `Assert-*` library, not an inline `if ($bad) { throw "message" }`
([ADR-AUTO-FAILFAST#4](../automation/fail-fast-with-asserts.md#rule-adr-auto-failfast4); the pwsh idiom is
[assert-idioms](assert-idioms.md#rule-adr-pwsh-assert4)):

```powershell
Assert-Command python                    # throws: "'python' is not installed"
Assert-ToolVersion -Tool 'python'        # throws: "python version mismatch: expected 3.13.x, found 3.10.2"
Assert-PathExist $configPath             # throws: "Path does not exist: /app/config.yml"
Assert-NotNullOrWhitespace $name         # throws: "Assertion failed: value was null or whitespace — Deploy.ps1, line 42"
```

Each assertion produces a structured, self-contained error message. The message names the specific assumption that was violated. No generic
"an error occurred" — the user knows exactly what is wrong from the error message alone.

### Error recovery

When a function encounters a condition it cannot handle, it throws. The caller decides what to do:

```powershell
# Caller handles the error — the function does not
try {
    Invoke-Poetry 'install'
}
catch {
    Write-Message "Poetry install failed, falling back to manual setup"
    Install-ManualDependencies
}
```

Functions never catch-and-continue internally. If `Invoke-Poetry` fails, it throws. Whether to retry, fall back, or abort is the caller's
decision ([single-responsibility-functions](../automation/single-responsibility-functions.md#rule-adr-auto-onejob5)).

### Temporary state

[single-responsibility-functions](../automation/single-responsibility-functions.md#rule-adr-auto-onejob6) rules out a function that changes
ambient state as a side effect. In pwsh that state is mostly variables the caller cannot see being changed: `$ErrorActionPreference` and the
other preferences, the location, `$env:` and `$global:` variables. Setting `$ErrorActionPreference` inside a function changes error handling
for every call it makes and, in a dot-sourced script, for its caller too; the per-call `-ErrorAction` parameter changes it for the one call
that needs it.

A change that has to hold for a stretch of work is undone in `finally`, because a `finally` block runs whether the body returns or throws:

```powershell
Push-Location $workFolder
try {
    Invoke-Executable 'widget pack'
}
finally {
    Pop-Location
}
```

A restore written after the work, outside `finally`, is skipped by the first error the work throws, and the caller inherits the change.

### Retry

[retry-as-last-resort](../automation/retry-as-last-resort.md) allows a retry only for a transient external failure, never in a test, and
only in a dedicated wrapper. In a Pester test, a dependency that can flake is mocked (`Mock`), or the test is an `L3` test that marks itself
skipped with `Set-ItResult -Skipped -Because '<reason>'` when its dependency is unavailable; a loop around the call, or a re-run of the
failed suite, would turn a real failure green.

Outside tests, the wrapper is a function of its own that takes the operation as a `[scriptblock]`, so the work and the retry policy change
independently. It repeats only that one call, a small fixed number of times, writes each retry as a yellow `Write-Message -Warning` line so
a degrading dependency leaves a trace, and rethrows the last error unchanged when the attempts are spent, so the caller sees the real
failure.

### Interactive error diagnostics

In interactive mode, the importer installs a prompt hook that calls `Write-Exception` after every failed command. This provides a full stack
trace with file names and line numbers — far more useful than PowerShell's default error display. In scripts, authors add
`trap { Write-Exception $_; break }` after the importer for the same effect.

### The -AllowWarnings escape hatch

The importer accepts `-AllowWarnings` to set `$WarningPreference` back to `Continue`. This exists for edge cases where third-party tools
emit warnings through PowerShell's warning stream that cannot be suppressed at the source. It should be rare — if you find yourself using
it, first check whether the warning can be fixed or the call can use `-WarningAction SilentlyContinue` on the specific cmdlet.

## Decision

All errors are terminating. All warnings are terminating. Functions use `throw` and `Assert-*` for failures, never `Write-Error` or
`Write-Warning`. Error recovery is the caller's responsibility. A temporary change of ambient state is undone in `finally`; a retry lives in
its own scriptblock-taking wrapper and never in a test.

### How this is enforced

- **`importer.ps1`** — sets `$ErrorActionPreference = 'Stop'` and `$WarningPreference = 'Stop'` globally.
- **`Set-StrictMode -Version Latest`** — catches uninitialized variables, absent properties, out-of-range indexes, and other common mistakes
  at runtime. Strict mode belongs to a scope, and a session-level `Set-StrictMode` does not reach module code, so it is set where the code
  runs: `Import-AllModules` sets it in each `Catzc.*` module's own script scope right after importing it (every function of the module
  inherits it, in the source tree and in an installed bundle alike), each `.internal` module and custom analyzer rule declares it at its
  top, and `Build-Bicep`/`Deploy-Bicep` set it in a template's `PrePost.psm1` scope after importing it. A pipeline or workflow step that
  runs PowerShell is strict too: dot-sourcing the importer sets it for the step's scope, and a step that runs without the importer declares
  `Set-StrictMode -Version Latest` as its first line. All code is therefore written strict-clean (ADR-PWSH-ERROR#8); a lazy `$script:` cache
  entry is probed as [script-scope-caching](script-scope-caching.md#rule-adr-pwsh-cache4) prescribes.
- **Custom analyzer rules** — `Measure-NoWriteErrorOrWarning` flags `Write-Error` and `Write-Warning`; `Measure-NoUnsafeFirstIndex` flags
  `@(<result>)[0]` and `(<a | b>)[0]`; and `Measure-NoBareCacheEntryRead` flags a function file reading a `$script:` cache entry it has
  neither assigned nor probed. The `.Count` and optional-key forms of ADR-PWSH-ERROR#8 need type knowledge an AST does not carry, so code
  review owns them.
- **Interactive prompt hook** — `Write-Exception` fires automatically after every failed command, providing full diagnostics.

## Consequences

- Every error stops execution immediately. No silent failures, no corrupted state from continuing after errors.
- Error messages are self-contained — the user can diagnose the problem from the message alone.
- CI pipelines fail fast and fail clearly. No ambiguous "succeeded with warnings" status.
- The codebase has exactly two output paths: success (information stream) and failure (throw). No third path for "maybe wrong."
- Third-party cmdlets that emit warnings will terminate under the default settings. Handle these with `-WarningAction SilentlyContinue` on
  the specific call, or use `-AllowWarnings` on the importer as a last resort.
