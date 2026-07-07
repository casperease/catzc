# ADR: Automatic variable pitfalls

## Rules: ADR-AUTOVAR

### Rule ADR-AUTOVAR:1

Never use `$?` for control flow — every statement (including the read itself) overwrites it; rely on `-ErrorAction Stop` plus `try`/`catch`
instead.

- [`$?` — never use](#--never-use)

### Rule ADR-AUTOVAR:2

With `$LASTEXITCODE`: reset → invoke → assert → reset. Prefer `Invoke-Executable` (or its `-PassThru` result's `ExitCode`) so you never read
the variable directly.

- [`$LASTEXITCODE` — use immediately, then reset](#lastexitcode--use-immediately-then-reset)

### Rule ADR-AUTOVAR:3

Capture `$Matches` into a named local on the very next line after a `-match` — the next match silently clobbers it.

- [`$Matches` — capture immediately](#matches--capture-immediately)

### Rule ADR-AUTOVAR:4

Capture `$_`/`$PSItem` into a named local before nesting pipelines or mixing pipeline with `catch`/`switch` — inner scopes shadow it.

- [`$_` / `$PSItem` — scoped to the current pipeline or catch block](#_--psitem--scoped-to-the-current-pipeline-or-catch-block)

### Rule ADR-AUTOVAR:5

Never use `$Error` for control flow — it is a global session-wide list; handle errors with `try`/`catch`.

- [`$Error` — never use for control flow](#error--never-use-for-control-flow)

### Rule ADR-AUTOVAR:6

Never use `??` to default a `[string]` parameter or variable — `[string]` coerces `$null` to `''`, so the default never fires; guard with
`if`/`IsNullOrEmpty` and reserve `??` for genuinely nullable operands.

- [`??` on a `[string]` value — the default never applies](#-on-a-string-value--the-default-never-applies)

### Rule ADR-AUTOVAR:7

Never reassign a parameter variable that carries a `Validate*` attribute (`[ValidateScript]`, `[ValidateSet]`, `[ValidateRange]`, …) — the
validator re-fires on every assignment, not just at binding, so assigning a different-shaped value into that name throws
`ValidationMetadataException`. Give the derived value a fresh local name.

- [`Validate*` parameters — never reassign](#validate-parameters--never-reassign)

## Context

PowerShell defines dozens of
[automatic variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables) —
variables set and updated by the engine implicitly. Some are stable (`$PSScriptRoot`, `$PSVersionTable`, `$true`/`$false`/`$null`). Others
are **implicit mutable state** that the engine overwrites silently after every statement, pipeline stage, or regex match.

The core problem: **automatic variables are only valid at the exact point they are set.** One statement later they may reflect a completely
different operation. Code that reads them "at a distance" — separated from the operation that set them by other statements, function calls,
or control flow — is reading stale state.

### The general principle

> If an automatic variable is set implicitly by the engine, treat it like a register value in assembly: **read it immediately or lose it.**
> If you need the value later, capture it in a named local on the very next line. Better yet, use a wrapper that encapsulates the
> read-and-reset cycle so callers never touch the variable directly.

## Decision

Automatic variables that carry implicit state must be handled according to the rules below. Variables not listed here (e.g.,
`$PSScriptRoot`, `$true`, `$null`, `$PSVersionTable`) are stable and safe to use freely.

---

### `$?` — never use

`$?` contains the success/failure status of the **last statement**. Every statement overwrites it — including the statement that tries to
read it.

```powershell
# BROKEN — $? reflects the assignment, not Get-Item
Get-Item 'C:\nonexistent'
$ok = $?        # $ok is True — the assignment "$ok = $?" succeeded
```

```powershell
# BROKEN — the Assert-Success anti-pattern
Invoke-Something          # fails
Do-SomethingElse          # succeeds
Assert-Success            # checks $? — sees True from Do-SomethingElse, not the failure
```

There is no reliable way to use `$?` in general-purpose code.

**What to do instead:**

- For **cmdlets and functions**: `-ErrorAction Stop` (set globally by the importer) so failures throw. Catch with `try`/`catch`. See
  [error-handling](error-handling.md#rule-adr-error1).
- For **native executables**: use `$LASTEXITCODE` (see below) or `Invoke-Executable` which handles the entire cycle.

**Enforced by:** PSScriptAnalyzer custom rule `Measure-NoAutomaticVariableMisuse` (severity: Error).

---

### `$LASTEXITCODE` — use immediately, then reset

`$LASTEXITCODE` holds the exit code of the last native executable. Unlike `$?`, it **persists** until the next native executable runs. This
means a stale `$LASTEXITCODE` from a previous call can leak across function boundaries and appear to belong to a later operation.

**The safe pattern — `Invoke-Executable`:**

```powershell
# Invoke-Executable encapsulates the entire cycle:
#   1. Reset-LastExitCode          ← clean slate
#   2. Invoke-Expression $Command  ← run the native call
#   3. Assert-LastExitCodeWasZero  ← check immediately
#   4. Reset-LastExitCode          ← clean slate for next caller

Invoke-Executable 'az account show --output json'
# At this point $LASTEXITCODE is cleared — no stale state can leak
```

**When you need the exit code with `-NoAssert`** (e.g., for expected non-zero exits):

`Invoke-Executable -PassThru` returns a `CliResult` object with an `ExitCode` property. This eliminates the need to touch `$LASTEXITCODE`
directly:

```powershell
# Correct — use the result object's ExitCode property
$result = Invoke-Executable 'az account show --output json' -PassThru -NoAssert -Silent
if ($result.ExitCode -ne 0 -or -not $result.Output) {
    Write-Message 'Not logged in — nothing to do'
    return
}
$account = $result.Output | ConvertFrom-Json
```

**Pipeline trap — cmdlets mask native exit state:**

When a native executable pipes into a cmdlet, the cmdlet becomes the last command in the pipeline. `$?` reflects the **cmdlet**, not the
executable — and if the cmdlet succeeds, the native failure is silently swallowed.

```powershell
# BROKEN — $? reflects ConvertFrom-Json, not az
$myvar = az account show | ConvertFrom-Json
Assert-Success   # passes even when az exited non-zero

# Why it's insidious:
#   1. az fails (exit code 1) but emits an error response as JSON
#   2. ConvertFrom-Json happily parses the error JSON → $? is True
#   3. $myvar now contains an error object, and nobody noticed
#
# Even when az emits nothing, ConvertFrom-Json returns $null
# without error in PS 7.4+ — $? is still True.
```

`$LASTEXITCODE` _is_ still set correctly by the native call, but code that checks `$?` (or an `Assert-Success` that checks `$?`) will never
see the failure.

```powershell
# Correct — use Invoke-Executable -PassThru, then parse the result
$result = Invoke-Executable 'az account show --output json' -PassThru
$myvar = $result.Output | ConvertFrom-Json
```

**Rules:**

- **Always reset before invoking.** Prevents a stale exit code from a prior call from leaking into your check.
- **Always check (or assert) immediately after invoking.** No intervening statements between the native call and the exit code check.
- **Always reset after checking.** Prevents your exit code from leaking to the next caller.
- **Prefer `Invoke-Executable`.** It encapsulates all three steps. Only use raw `$LASTEXITCODE` when you need `-NoAssert` for expected
  failures.

---

### `$Matches` — capture immediately

`$Matches` is overwritten by every `-match` or `-replace` operation. Sequential matches silently clobber previous results.

```powershell
# BROKEN — second -match overwrites $Matches from the first
$line -match 'name=(.+)'
$header -match 'version=(\d+)'
$name = $Matches[1]   # this is the version, not the name
```

```powershell
# Correct — capture immediately after each match
$line -match 'name=(.+)'
$name = $Matches[1]

$header -match 'version=(\d+)'
$version = $Matches[1]
```

**Rule:** If you use `-match`, capture `$Matches` into a named local on the very next line.

---

### `$_` / `$PSItem` — scoped to the current pipeline or catch block

`$_` is set by the pipeline, `ForEach-Object`, `Where-Object`, `catch`, `trap`, and `switch`. Each of these scopes overwrites `$_` — inner
pipelines shadow the outer `$_` silently.

```powershell
# BROKEN — inner ForEach-Object shadows $_
$users | ForEach-Object {
    $_.Roles | ForEach-Object {
        # $_ is now a Role, not a User
        Write-Message "$($_.Name) has role $_"   # $_.Name is Role.Name, not User.Name
    }
}
```

```powershell
# Correct — capture in a named variable before nesting
$users | ForEach-Object {
    $user = $_
    $user.Roles | ForEach-Object {
        Write-Message "$($user.Name) has role $_"
    }
}
```

**Rule:** When nesting pipelines or mixing pipeline with `catch`/`switch`, always capture `$_` in a named local at the top of the outer
block.

---

### `$Error` — never use for control flow

`$Error` is a global list that **accumulates every error** across the entire session. It is not scoped to your function or script.

- It contains errors from the importer, from modules loading, from previous commands the user ran interactively.
- `$Error[0]` is only "your" error if nothing else has errored since — which you cannot guarantee.
- `$Error.Clear()` affects the global session state and may break other code that inspects `$Error`.

**What to do instead:** Use `try`/`catch` to handle errors structurally. The caught exception in `catch` is scoped and unambiguous. See
[error-handling](error-handling.md).

**Exception:** `Catzc.Base.Writers/Write-Exception.ps1` reads `$global:Error[$GlobalErrorIndex]` (default index `0`) as a fallback when
called with no `ErrorRecord` — a deliberate diagnostic convenience for displaying the most recent error. This is infrastructure/diagnostic
code with a legitimate need to read the global error list; it is not control flow.

---

---

### `??` on a `[string]` value — the default never applies

Not an automatic variable, but the same class of surprise: an implicit coercion that makes a read return something other than what the
author expects, so it belongs with the others here.

The null-coalescing operator `??` substitutes its right side **only when the left side is `$null`**. A `[string]`-typed variable or
parameter can never _be_ `$null` — the engine coerces `$null` to the empty string `''` at assignment and at parameter binding. So an
**unbound `[string]` parameter is `''`, not `$null`** (and even `[string]$x = $null` stores `''`). Therefore the default silently never
fires:

```powershell
function Get-Thing {
    param([string] $Label)      # caller omits -Label  →  $Label is '', not $null
    $Label ?? 'default'         # → ''  (NOT 'default')
}

# The bite in practice — a blank error message:
throw ($ErrorText ?? "Path does not exist: $Path")   # throws ''  when -ErrorText is omitted
```

This is distinct from an **untyped** value, where `??` works as expected because the value really is `$null`: `$null ?? 'default'` →
`'default'`, and an absent object/hashtable property (`$config.Foo`, `$json.name`) is genuinely `$null`, so `??` is the right tool there.

**What to do instead** — for a `[string]`, guard on emptiness, not nullness:

```powershell
$value = if ($Label) { $Label } else { 'default' }                 # falsy covers '' and $null
# or, explicit:
$value = if ([string]::IsNullOrEmpty($Label)) { 'default' } else { $Label }
```

**Rule:** never use `??` to default a `[string]`-typed parameter or variable — use an `if`/`IsNullOrEmpty` guard. Reserve `??` for genuinely
nullable operands (untyped variables, object/hashtable properties).

---

### `Validate*` parameters — never reassign

A validation attribute (`[ValidateScript]`, `[ValidateSet]`, `[ValidateRange]`, …) does not only run when the parameter is bound — it
re-runs on **every assignment to that variable**. Variable names are case-insensitive, so reassigning a value into a name that matches the
parameter re-fires the validator against the new value:

```powershell
function Get-AzureEnvironment {
    param(
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )
    # BROKEN — re-runs the ValidateScript against the typed result, throws ValidationMetadataException
    $Subscription = Get-AzureSubscription $Subscription
}
```

The bug is silent at author time and only surfaces at runtime; the error names the type, not the cause ("the value `<Type>` is not a valid
value for the `Subscription` variable"). A parameter with only an `ArgumentCompleter` (no `Validate*`) is unaffected — this bites the typed
producers whose `-Subscription`/`-Environment` carry a `ValidateScript`.

**Rule:** give the derived value a fresh local name (`$subscriptionDescriptor`, `$environmentDescriptor`) — never the validated parameter's
name. Grep the `param()` block for `Validate` before reusing a name.

---

## Summary of rules

| Variable / operator | Rule                                                            | Alternative                             |
| ------------------- | --------------------------------------------------------------- | --------------------------------------- |
| `$?`                | In general, don't use                                           | `-ErrorAction Stop` + `try`/`catch`     |
| `$LASTEXITCODE`     | Reset → invoke → assert → reset (use `Invoke-Executable`)       | Direct check only with `-NoAssert`      |
| `$Matches`          | Capture into a named local on the very next line after `-match` | —                                       |
| `$_` / `$PSItem`    | Capture into a named local before nesting pipelines             | —                                       |
| `$Error`            | Never use for control flow                                      | `try`/`catch`                           |
| `??` on `[string]`  | Default never applies (`[string]` coerces `$null`→`''`)         | `if ($x) {} else {}` / `IsNullOrEmpty`  |
| `Validate*` param   | Validator re-fires on every reassignment, not just at binding   | Assign the result to a fresh local name |

## Consequences

- Eliminates the "stale read" class of bugs where automatic variables reflect a different operation than the author intended.
- `Invoke-Executable` is the standard entry point for native executables — callers never need to think about `$LASTEXITCODE` lifecycle.
- The `$?` ban is enforced statically by PSScriptAnalyzer. Other variables are enforced by code review and this ADR.
- All error handling follows the patterns in [error-handling](error-handling.md).

## Dora explains:

DORA's research links code maintainability to delivery performance—and automatic-variable pitfalls are a major class of silent bugs that
slip through code review. Handling automatic variables safely (read immediately, capture in locals, prefer wrappers) builds the robust error
handling that enables high-frequency deployment.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — avoiding subtle variable-scoping bugs that slip past code
  review.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — robust error handling and consistent patterns enable safe
  automation at scale.
- [Test automation](https://dora.dev/capabilities/test-automation/) — proper error handling patterns surface failures early in testing.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
