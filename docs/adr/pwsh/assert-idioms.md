# docs/adr/pwsh/assert-idioms.md

`ADR: Assert idioms — failing fast in pwsh`

## Rules: ADR-PWSH-ASSERT

### Rule ADR-PWSH-ASSERT:1

A function that bounds its own long-running work declares its limit beside its code, as a
`[Catzc.Base.Timeouts.TimeLimit(<devbox seconds>, Pipeline = <seconds>)]` attribute on its param block, and takes it through
`Get-TimeoutSeconds -Command <name>` — never a number literal as a parameter default. The limit resolves most specific first: an exemption
for the decoration's budget GUID (`timeout-exemptions.yml`), then the command's entry under `commands` in `timeouts.yml`, then the
decoration for the run environment, then the environment's pwsh default (ADR-AUTO-FAILFAST#7).

- [The TimeLimit attribute](#the-timelimit-attribute)

### Rule ADR-PWSH-ASSERT:2

In pwsh, the entry assertions of ADR-AUTO-FAILFAST#1 are `Assert-*` calls at the top of the function body, directly after the `param`
block and before any statement that uses a parameter, for what the `[Parameter]` and `Validate*` attributes do not express.

- [Guard placement](#guard-placement)

### Rule ADR-PWSH-ASSERT:3

In pwsh, the external calls of ADR-AUTO-FAILFAST#2 are native tools run through `Invoke-Executable`, file reads such as `Get-Content`, and
REST and cloud calls. The result is held in a named local and asserted on the next line, before it is passed on or returned.
`Invoke-Executable` asserts the exit code itself (ADR-PWSH-AUTOVAR#2), so its caller asserts the output.

- [Guard placement](#guard-placement)

### Rule ADR-PWSH-ASSERT:4

In pwsh, the inline check ADR-AUTO-FAILFAST#4 rules out is `if (-not $x) { throw '...' }` around a precondition: the precondition is an
`Assert-*` call instead. `throw` is for a failure that is not an assumption check (ADR-PWSH-ERROR#3).

- [The Assert library](#the-assert-library)

### Rule ADR-PWSH-ASSERT:5

In pwsh, no `try`/`catch` or `trap` encloses an `Assert-*` call to absorb its failure (ADR-AUTO-FAILFAST#5). A test proves an assertion
fires with `Should -Throw`, which is the one place an assertion failure is caught.

- [Catching an assertion](#catching-an-assertion)

## Context

[fail-fast-with-asserts](../automation/fail-fast-with-asserts.md) decides that every assumption is asserted where it is made, through the
assertion library, and that every wait is bounded. This ADR is how that reads in PowerShell: which functions assert, where in a function
they sit, what replaces an inline `if`/`throw`, and how a function declares its own time limit.

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
([error-handling](error-handling.md#rule-adr-pwsh-error3)).

### Guard placement

```powershell
function Invoke-Poetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments
    )

    Assert-NotNullOrWhitespace $Arguments           # validate input, redundant because of Mandatory, but shown here for demo. Contract check with caller
    Assert-Command poetry                           # tool exists. Contract check with system
    Assert-ToolVersion -Tool 'Poetry'               # correct version. Contract check with system

    $result = Invoke-Executable "poetry $Arguments" -PassThru
    Assert-NotNullOrWhitespace $result              # got output. Contract check with integration: We got "something" rather than nothing.

    $result
}
```

The entry guards sit directly after the `param` block, so a reader sees the function's preconditions before its work. They cover what the
parameter attributes cannot: `[Parameter(Mandatory)]` rejects a missing argument but not a whitespace one, and `[ValidateScript]` runs
again on every reassignment ([automatic-variable-pitfalls](automatic-variable-pitfalls.md#rule-adr-pwsh-autovar7)), so a check that has to
hold once, at entry, is an assertion. The output guard follows the external call on the next line, before `$result` leaves the function.

### Catching an assertion

An assertion failure is a bug or an unmet precondition, so nothing in a function catches it: a `try`/`catch` around `Assert-PathExist`
either hides a broken assumption or says the condition was never an assumption, and should have been a `Test-*` call and a branch. Tests
are different by design: they prove the assertion fires, and `Should -Throw` catches the failure to compare its message
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

## Decision

In pwsh, assumptions are asserted with the `Assert-*` functions: input guards directly after the `param` block, output guards on the line
after an external call, never an inline `if`/`throw` for a precondition, and never a `try`/`catch` around an assertion outside a test. A
function that bounds its own long work declares its limit with the `TimeLimit` attribute and reads it through `Get-TimeoutSeconds`.

### How this is enforced

- **`Catzc.Base.Asserts`** — the `Assert-*` library, the one way a precondition is checked.
- **`Catzc.Base.Timeouts.TimeLimitAttribute`** — rejects a limit that is not a positive whole number of seconds, or a pipeline limit below
  the devbox one, when the function is defined; **`Get-TimeoutSeconds -Command`** reads the decoration in the order of
  ADR-PWSH-ASSERT#1.
- **Code review** — guard placement, an inline `if`/`throw` that should be an assertion, a `try`/`catch` around an assertion, and a number
  literal as a timeout default are review concerns, against this ADR.

## Consequences

- A function's preconditions are the first lines of its body, readable before its work.
- Every assumption check fails with the library's message, so errors read the same everywhere and are found by one search.
- A long-running function carries its time limit with its code; config states only what was tuned.
- Assertion failures reach the caller untouched; only a test catches one, to prove it fires.
