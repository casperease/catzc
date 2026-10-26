# ADR: Assert idioms — failing fast in pwsh

## Rules: ADR-PWSH-ASSERT

### Rule ADR-PWSH-ASSERT-DECLAREDTIMELIMIT

A function that bounds its own long-running work declares its limit beside its code, as a
`[Catzc.Base.Timeouts.TimeLimit(<devbox seconds>, Pipeline = <seconds>)]` attribute on its param block, and takes it through
`Get-TimeoutSeconds -Command <name>` — never a number literal as a parameter default. The limit resolves most specific first: an exemption
for the decoration's budget GUID (`timeout-exemptions.yml`), then the command's entry under `commands` in `timeouts.yml`, then the
decoration for the run environment, then the environment's pwsh default (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT).

- [The TimeLimit attribute](#the-timelimit-attribute)

### Rule ADR-PWSH-ASSERT-ENTRYASSERTCALLS

In pwsh, the entry assertions of ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY are `Assert-*` calls at the top of the function body, directly after
the `param` block and before any statement that uses a parameter, for what the `[Parameter]` and `Validate*` attributes do not express.

- [Guard placement](#guard-placement)

### Rule ADR-PWSH-ASSERT-EXTERNALCALLSVIARUNNER

In pwsh, the external calls of ADR-AUTO-FAILFAST-ASSERTAFTEREXTERNALCALLS are native tools run through `Invoke-Executable`, file reads such
as `Get-Content`, and REST and cloud calls. The result is held in a named local and asserted on the next line, before it is passed on or
returned. `Invoke-Executable` asserts the exit code itself (ADR-PWSH-AUTOVAR-EXITCODECYCLE), so its caller asserts the output.

- [Guard placement](#guard-placement)

### Rule ADR-PWSH-ASSERT-NOINLINETHROWCHECK

In pwsh, the inline check ADR-AUTO-FAILFAST-USEASSERTIONLIBRARY rules out is `if (-not $x) { throw '...' }` around a precondition: the
precondition is an `Assert-*` call instead. `throw` is for a failure that is not an assumption check (ADR-PWSH-ERROR-THROWNOTWRITEERROR).

- [The Assert library](#the-assert-library)

### Rule ADR-PWSH-ASSERT-NOCATCHAROUNDASSERT

In pwsh, no `try`/`catch` or `trap` encloses an `Assert-*` call to absorb its failure (ADR-AUTO-FAILFAST-NEVERCATCHASSERTIONS). A test
proves an assertion fires with `Should -Throw`, which is the one place an assertion failure is caught.

- [Catching an assertion](#catching-an-assertion)

### Rule ADR-PWSH-ASSERT-TWOWAITBOUNDS

In pwsh, the waits ADR-AUTO-FAILFAST-BOUNDEVERYWAIT bounds are bounded in two ways. A native tool runs through `Invoke-Executable`, which
kills the child process tree at its executable's limit. In-process work runs as a script block passed to `Invoke-WithTimeout`,
`Assert-CompletesWithin`, or `Test-CompletesWithin`, with `-Budget <guid>` when it carries an exempted budget. No wait is left open: no
`Wait-Job`, `WaitForExit()`, or polling loop without a limit.

- [Bounding a wait](#bounding-a-wait)

### Rule ADR-PWSH-ASSERT-WATCHBEHINDSWITCH

In pwsh, the watchpoint of ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND is a `Watch-Blocking` call behind the entry's `-DiagnoseBlocking` switch,
`if ($DiagnoseBlocking) { Watch-Blocking }`, standing where a writer exists, after the modules load. It writes its ticks and one closing
`Write-Message -Warning` line, and throws only for an invalid argument. Once its run is read the call is deleted: a block it found is
bounded through `Invoke-WithTimeout` with a `timeouts.yml` limit. An entry carries `-DiagnoseBlocking` only while a watchpoint stands behind
it: the switch is added together with the watchpoint and deleted with the last one.

- [Standing a watchpoint](#standing-a-watchpoint)

## Context

[fail-fast-with-asserts](../fail-fast-with-asserts.md) decides that every assumption is asserted where it is made, through the assertion
library, and that every wait is bounded. This ADR is how that reads in PowerShell: which functions assert, where in a function they sit,
what replaces an inline `if`/`throw`, and how a function declares its own time limit.

### The Assert library

The `Catzc.Base.Asserts` module is the library. Each function checks one assumption and throws a structured, self-contained message naming
it; none returns a value:

```powershell
Assert-Command python                    # throws: "'python' is not installed"
Assert-ToolVersion -Tool 'python'        # throws: "python version mismatch: expected 3.13.x, found 3.10.2"
Assert-PathExist $configPath             # throws: "Path does not exist: /app/config.yml"
Assert-NotNullOrWhitespace $name         # throws: "Assertion failed: value was null or whitespace — Deploy.ps1, line 42"
```

An inline `if (-not $x) { throw "..." }` checks the same thing but reads as control flow, and its message is whatever the author typed that
day. The `Assert-*` call names its intent, carries the library's message, and is found by one search. `throw` keeps its place for a failure
that is not an assumption check — an unsupported combination of arguments, a state the function has found and cannot proceed from
([error-handling](error-handling.md#rule-adr-pwsh-error-thrownotwriteerror)).

### Guard placement

```powershell
function Invoke-Poetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments
    )

    Assert-NotNullOrWhitespace $Arguments           # validate input, redundant with Mandatory, shown for demo. Contract check with caller
    Assert-Command poetry                           # tool exists. Contract check with system
    Assert-ToolVersion -Tool 'Poetry'               # correct version. Contract check with system

    $result = Invoke-Executable "poetry $Arguments" -PassThru
    Assert-NotNullOrWhitespace $result              # got output. Contract check with integration: We got "something" rather than nothing.

    $result
}
```

The entry guards sit directly after the `param` block, so a reader sees the function's preconditions before its work. They cover what the
parameter attributes cannot: `[Parameter(Mandatory)]` rejects a missing argument but not a whitespace one, and `[ValidateScript]` runs again
on every reassignment ([automatic-variable-pitfalls](automatic-variable-pitfalls.md#rule-adr-pwsh-autovar-novalidatedreassignment)), so a
check that has to hold once, at entry, is an assertion. The output guard follows the external call on the next line, before `$result` leaves
the function.

### Catching an assertion

An assertion failure is a bug or an unmet precondition, so nothing in a function catches it: a `try`/`catch` around `Assert-PathExist`
either hides a broken assumption or says the condition was never an assumption, and should have been a `Test-*` call and a branch. Tests are
different by design: they prove the assertion fires, and `Should -Throw` catches the failure to compare its message
([pester-testing](pester-testing.md)).

### The TimeLimit attribute

A function whose own work is long by nature — a full test run, a build — declares its limit where it is written:

```powershell
function Test-Widget {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 1800)]
    param([int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Test-Widget'))
    # ...
}
```

A number literal as a parameter default would say the same thing where nothing reads it: config cannot tune it, the environment cannot
change it, and a reader cannot find it. The decoration keeps the value beside the code and lets the more specific settings win in order — an
exemption for the decoration's `Budget` GUID while the work is tuned, a `commands` entry when a machine needs a different value, the
decoration otherwise, and the environment's pwsh default for a function that declares nothing. The attribute checks its values when it is
created: whole seconds above zero, and a pipeline limit at least the devbox one.

### Bounding a wait

[fail-fast-with-asserts](../fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait) bounds every wait. In pwsh the two kinds of
wait have one helper each. A native tool is a child process, so `Invoke-Executable` owns its limit and kills the whole process tree when it
is reached. Work inside the session — a long loop, a scan, a call into a module — is passed as a script block:

```powershell
$report = Invoke-WithTimeout { Get-WidgetReport -Path $Path } -Activity 'widget report'
Assert-CompletesWithin { Sync-Gadget } -Budget $gadgetBudget
```

With no `-Seconds`, the limit is the run environment's pwsh limit in `timeouts.yml`, or the budget's exemption ceiling. `Invoke-WithTimeout`
returns the block's output and, past the limit, stops it and throws an error naming the limit; `Assert-CompletesWithin` is the assertion
form, and `Test-CompletesWithin` returns whether the block finished in time. A `Wait-Job`, a `WaitForExit()`, or a `while` loop polling for
a condition, each with no limit of its own, is the unbounded wait the rule exists to remove.

### Standing a watchpoint

A suspected block in a startup gets one line where it is suspected, behind a `-DiagnoseBlocking` switch the same change adds to the entry:

```powershell
Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot
if ($DiagnoseBlocking) {
    Watch-Blocking
}
```

`Watch-Blocking` holds the thread for its configured duration (the `wait` keys of `timeouts.yml`, one second by default) in ten ticks and
writes each tick through `Write-Message`: when it was due, when it ran, and how late. Its closing line is `Write-Message -Warning`, not the
`Write-Warning` cmdlet, because the importer makes warnings stop the session and a watchpoint must let go. A free thread runs each tick a
few milliseconds late, the timer's resolution; a held one misses the schedule. The call stands for one measured run and is deleted after it,
and the switch with it when no other watchpoint stands behind it: a switch nothing reads is a parameter the analyzer reports as unused, and
one living version keeps no parameter for a future use.

## Decision

In pwsh, assumptions are asserted with the `Assert-*` functions: input guards directly after the `param` block, output guards on the line
after an external call, never an inline `if`/`throw` for a precondition, and never a `try`/`catch` around an assertion outside a test. A
function that bounds its own long work declares its limit with the `TimeLimit` attribute and reads it through `Get-TimeoutSeconds`. A native
tool is bounded by `Invoke-Executable`, and in-process work by passing it as a script block to `Invoke-WithTimeout` or its assertion and
test forms. A suspected block is found with a `Watch-Blocking` call behind a `-DiagnoseBlocking` switch added with it, both deleted once its
run is read.

### How this is enforced

- **`Catzc.Base.Asserts`** — the `Assert-*` library, the one way a precondition is checked.
- **`Catzc.Base.Timeouts.TimeLimitAttribute`** — rejects a limit that is not a positive whole number of seconds, or a pipeline limit below
  the devbox one, when the function is defined; **`Get-TimeoutSeconds -Command`** reads the decoration in the order of
  ADR-PWSH-ASSERT-DECLAREDTIMELIMIT.
- **Code review** — guard placement, an inline `if`/`throw` that should be an assertion, a `try`/`catch` around an assertion, and a number
  literal as a timeout default are review concerns, against this ADR.

## Consequences

- A function's preconditions are the first lines of its body, readable before its work.
- Every assumption check fails with the library's message, so errors read the same everywhere and are found by one search.
- A long-running function carries its time limit with its code; config states only what was tuned.
- Assertion failures reach the caller untouched; only a test catches one, to prove it fires.
