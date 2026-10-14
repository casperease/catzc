# docs/adr/automation/fail-fast-with-asserts.md

`ADR: Fail fast with inline assertions`

## Rules: ADR-AUTO-FAILFAST

### Rule ADR-AUTO-FAILFAST:1

Assert inputs at function entry. Use `Assert-NotNullOrWhitespace`, `Assert-True`, `Assert-PathExist`, `Assert-TypeIs`, and other `Assert-*`
functions to validate variables.

- [The inline assertion pattern](#the-inline-assertion-pattern)
- [In practice](#in-practice)

### Rule ADR-AUTO-FAILFAST:2

Assert after every external call. After `Invoke-Executable`, `Get-Content`, API calls, or any operation that talks to the outside world,
assert the result meets expectations before passing it downstream.

- [Why every fifth line](#why-every-fifth-line)
- [In practice](#in-practice)

### Rule ADR-AUTO-FAILFAST:3

Assert preconditions, not just inputs. `Assert-Tool` verifies a tool's command is present and at the expected version before doing work; it
does not validate inputs and deliberately does not resolve `DependsOn` (an install-time concern handled by `Get-ToolInstallOrder`).

- [Why every fifth line](#why-every-fifth-line)
- [Decision](#decision)

### Rule ADR-AUTO-FAILFAST:4

Use the `Assert-*` library, never inline `if/throw`. The library gives consistent, greppable error messages and makes assertion intent
visible in review; bare `if (-not $x) { throw }` obscures it.

- [The inline assertion pattern](#the-inline-assertion-pattern)

### Rule ADR-AUTO-FAILFAST:5

Never catch assertion failures. Assertions indicate a bug or unmet precondition, not a recoverable error; let them propagate. Wrapping an
assertion in `try`/`catch` means the assertion is wrong or the condition should be handled differently.

- [Decision](#decision)

### Rule ADR-AUTO-FAILFAST:6

Treat assertions as documentation. `Assert-PathExist $configPath` both checks at runtime and specifies the function's expectations — more
reliable than a comment because it executes.

- [Why every fifth line](#why-every-fifth-line)

### Rule ADR-AUTO-FAILFAST:7

Bound every wait. Every external call and every unbounded piece of work runs inside a time safeguard, so a hang fails fast with a message
naming the limit instead of waiting forever. The limits live in one config (`timeouts.yml`, owned by `Catzc.Base.Timeouts`), keyed by run
environment (devbox | pipeline) and shell (bash | pwsh), with sensible defaults declared on its config type — deliberately tight on a devbox
— plus per-executable entries, and no "no limit" value. `Invoke-Executable` kills a child process tree at its executable's limit;
`Invoke-WithTimeout` / `Assert-CompletesWithin` / `Test-CompletesWithin` stop a script block at its limit. The bash limits bound every shell
call an agent makes, foreground and background, and a hook denies a call outside them. Work that legitimately runs longer while it is tuned
carries an immutable budget GUID and is exempted in `timeout-exemptions.yml`, which raises its limit to a ceiling but never lifts it.

- [A hang is the slowest failure](#a-hang-is-the-slowest-failure)
- [Bounding an agent's shell calls](#bounding-an-agents-shell-calls)

### Rule ADR-AUTO-FAILFAST:8

A function that bounds its own long-running work declares its limit beside its code, as a
`[Catzc.Base.Timeouts.TimeLimit(<devbox seconds>, Pipeline = <seconds>)]` attribute on its param block, and takes it through
`Get-TimeoutSeconds -Command <name>` — never a number literal as a parameter default. The limit resolves most specific first: an exemption
for the decoration's budget GUID (`timeout-exemptions.yml`), then the command's entry under `commands` in `timeouts.yml`, then the
decoration for the run environment, then the environment's pwsh default.

- [A hang is the slowest failure](#a-hang-is-the-slowest-failure)

## Context

PowerShell automation code is fundamentally about side effects — creating resources, calling APIs, installing tools, writing files. This
makes it hard to test with traditional unit testing approaches:

- **Mocking is fragile and misleading.** You can mock `Invoke-Executable` to return a canned string, but that tells you nothing about
  whether the real CLI will behave the same way. Mock-heavy tests pass in CI and fail in production because the mock does not replicate the
  real tool's exit codes, stderr behavior, or edge cases.

- **Integration tests are slow and environment-dependent.** A real test that installs Python, runs poetry, and deploys to Azure takes
  minutes, requires credentials, and breaks when the network is flaky. You cannot run these on every save.

- **Coverage is deceptive.** You can hit 90% line coverage and still miss the bug, because the bug is not in the logic — it is in the
  assumption that a variable is non-null, a path exists, a command returned the expected format, or an exit code was zero. These are the
  actual failure modes of automation code.

Traditional testing works best for pure functions with inputs and outputs. Automation code is mostly impure — it orchestrates external
systems. We need a strategy that matches this reality.

### The inline assertion pattern

Instead of relying solely on after-the-fact testing, we build quality _into_ the code itself with inline assertions. The principle: **assert
every assumption at the point where it is made.** On average, roughly every fifth line of code should be an assertion.

This is not a replacement for Pester tests — it is a complementary strategy. Pester tests verify behavior in controlled conditions. Inline
assertions verify assumptions in _every_ execution, including production, including the edge cases no test anticipated.

### In practice

```powershell
function Invoke-Poetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments
    )

    Assert-NotNullOrWhitespace $Arguments           # validate input
    Assert-Command poetry                           # tool exists
    Assert-ToolVersion -Tool 'Poetry'               # correct version

    $result = Invoke-Executable "poetry $Arguments" -PassThru
    Assert-NotNullOrWhitespace $result              # got output

    $result
}
```

Five functional lines, four assertions. This is not excessive — it is the minimum needed to produce a clear error for every failure mode:

- Caller passed empty arguments → immediate throw with parameter name
- Poetry not installed → immediate throw naming the missing tool
- Poetry is the wrong version → immediate throw with expected vs actual
- Command produced no output → immediate throw at the source

Without the assertions, all four failures eventually surface as something unhelpful: `Cannot index into a null array` three functions down
the call stack, or a silent empty result that corrupts downstream state.

### Why every fifth line

The ratio is a guideline, not a rigid rule. The point is that assertions should be _pervasive_, not sprinkled in as an afterthought. Code
that goes 20 lines without an assertion is almost certainly making unchecked assumptions. Common assertion points:

- **Function entry.** Validate parameters beyond what `[Parameter]` attributes can express. Check that paths exist, strings are non-empty,
  objects have expected properties.

- **After external calls.** CLI tools, APIs, and file operations can fail in ways that do not throw — non-zero exit codes, empty responses,
  partial writes. Assert the result is what you expected.

- **Before using a value.** If a variable could be null, empty, or the wrong type, assert before using it. Do not trust upstream code to
  have validated it — the upstream code might change.

- **State transitions.** After modifying state (environment variables, files, registry), assert the state is what you set it to. External
  processes, group policies, or concurrent scripts can interfere.

### A hang is the slowest failure

An assertion fails fast only if the code reaches it. A process waiting on a prompt no one can answer, a network call that never returns, or
a loop that never ends produces no error at all — it holds a terminal, a pipeline agent or an AI agent until a person notices, often minutes
later, with nothing to say where it stopped. A time limit turns that silence into an ordinary failure: the work is stopped at a known point
and the error names the limit and where to change it.

The limits are tuned, not guessed per call site. They sit in one config with a deliberately tight default, so a call that legitimately needs
longer shows up as a blocker to tune — a per-executable entry, or a move to the background — rather than a limit raised quietly in code.
There is no "no limit" value, because an unbounded wait is exactly the failure the limit exists to remove.

Two axes decide a limit, and both are read from the session rather than passed in. The run environment (devbox or pipeline,
`Get-RunEnvironment`) sets how tight it is: a devbox has a person to tune with, a pipeline has nobody watching and longer ordinary builds.
The shell (bash or pwsh) sets what it bounds: pwsh code bounds its own script blocks and processes, and the agent hook bounds bash calls. A
caller can pin the environment with an `-EnvironmentAssertIs` guard, which verifies and never selects.

An exemption is for work that is known to be slow while it is fixed. It names the work by an immutable budget GUID — registered in the
managed-GUID registry ([ADR-AUTO-GUIDS](managed-guids.md)), one at a time or as an inclusive range of a minted family — and carries the
reason. It raises the budget's limit to a ceiling and never removes it, and a gate that must not run exempt says so with
`Assert-IsNotTimeoutExempt`.

A function whose own work is long by nature — a full test run, a build — knows its limit better than any config, so it declares it where it
is written, as a `TimeLimit` attribute on its param block (ADR-AUTO-FAILFAST#8). A number literal as a parameter default would say the same
thing where nothing reads it: config cannot tune it, the environment cannot change it, and a reader cannot find it. The decoration keeps the
value beside the code and still lets the more specific settings win in order — an exemption while the work is tuned, a `commands` entry when
a machine needs a different value, the decoration otherwise, and the environment's default for a function that declares nothing. Each
setting is current and states something different; none is a fallback for an old shape.

### Bounding an agent's shell calls

A coding agent's shell call is the same wait with a different caller, so the hook (`.claude/hooks/Assert-BashTimeout/`) applies the same
bash limits to it. A foreground call passes a `timeout` within the foreground limit. A background call is different: the Bash tool does not
apply its `timeout` parameter to it, so it must start with a GNU `timeout <duration>` within the background limit, around a single command —
a compound command would leave everything after its first command unbounded. Exit 124 means the safeguard stopped it.

The hook denies and never rewrites. A hook that rewrites a command must also approve it, and an approval skips the permission prompt, while
a command wrapped in `bash -c` no longer matches the deny rules written for it. Denial leaves every other safeguard in force. Who asked
changes only what the denial says: the main session raises the blocker with the user, a subagent reports it to its coordinator, and a
pipeline fixes the call or its limit. Each denial is also appended to `out/time-safeguard.log`, the list of blockers to tune.

The hook compiles the module's own config and verdict types (`TimeoutsConfig`, `BashSafeguard`), so its limits and decisions are the ones
`Get-TimeoutSeconds` resolves and the L0 tests check; an integrity test runs the published hook against the shipped config to prove it.

## Decision

Use inline assertions pervasively throughout all automation code. Every assumption about inputs, state, and external results must be
asserted at the point where the assumption is made, and every wait is bounded by a configured time limit.

## Consequences

- Errors surface immediately at the point of failure with a clear message naming the exact assumption that was violated.
- A hang becomes a failure at a known limit instead of an indefinite wait; a limit too tight for real work surfaces as a blocker to tune in
  `timeouts.yml`, or an exemption with a reason in `timeout-exemptions.yml`.
- An agent cannot start a shell call that has no limit, in the foreground or the background; a denied call says how to re-issue it.
- Stack traces are short — typically one or two frames — because the assertion fires before the bad value propagates.
- Debugging is rarely needed. The error message from the assertion usually contains everything needed to diagnose the problem.
- Code is self-documenting: reading the assertions tells you the function's preconditions, postconditions, and invariants.
- Performance cost is negligible — assertions are simple boolean checks. The cost of _not_ asserting (silent corruption, misleading errors,
  hours of debugging) is orders of magnitude higher.
- Pester tests focus on behavior and integration, not on re-checking assumptions that the code already asserts on every execution.
