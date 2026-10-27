# ADR: Fail fast with inline assertions

## Rules: ADR-AUTO-FAILFAST

### Rule ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY

Assert inputs at function entry. Before a function uses a value it receives, it validates that value through the toolset's assertion library
(`Assert-NotNullOrWhitespace`, `Assert-True`, `Assert-PathExist`, `Assert-TypeIs`, and the other `Assert-*` functions), for everything its
parameter declaration cannot express.

- [The inline assertion pattern](#the-inline-assertion-pattern)
- [In practice](#in-practice)

### Rule ADR-AUTO-FAILFAST-ASSERTAFTEREXTERNALCALLS

Assert after every external call. After running an external tool, reading a file, calling an API, or any operation that talks to the outside
world, assert the result meets expectations before passing it downstream.

- [Why every fifth line](#why-every-fifth-line)
- [The assert ladder](#the-assert-ladder)
- [In practice](#in-practice)

### Rule ADR-AUTO-FAILFAST-ASSERTPRECONDITIONS

Assert preconditions, not just inputs. `Assert-Tool` verifies a tool's command is present and at the expected version before doing work; it
does not validate inputs and deliberately does not resolve `DependsOn` (an install-time concern handled by `Get-ToolInstallOrder`).

- [Why every fifth line](#why-every-fifth-line)
- [Decision](#decision)

### Rule ADR-AUTO-FAILFAST-USEASSERTIONLIBRARY

Use the assertion library, never an inline check that raises its own error. The library gives consistent, greppable error messages and makes
assertion intent visible in review; a bare conditional that fails on its own terms obscures it.

- [The inline assertion pattern](#the-inline-assertion-pattern)

### Rule ADR-AUTO-FAILFAST-NEVERCATCHASSERTIONS

Never catch assertion failures. Assertions indicate a bug or unmet precondition, not a recoverable error; let them propagate. An error
handler around an assertion means the assertion is wrong or the condition should be handled differently.

- [Decision](#decision)

### Rule ADR-AUTO-FAILFAST-ASSERTIONSDOCUMENT

Treat assertions as documentation. An assertion that a config path exists (`Assert-PathExist`) both checks at runtime and specifies the
function's expectations — more reliable than a comment because it executes.

- [Why every fifth line](#why-every-fifth-line)

### Rule ADR-AUTO-FAILFAST-BOUNDEVERYWAIT

Bound every wait. Every external call and every unbounded piece of work runs inside a time safeguard, so a hang fails fast with a message
naming the limit instead of waiting forever. The limits live in one config (`timeouts.yml`, owned by `Catzc.Base.Timeouts`), keyed by run
environment (devbox | pipeline) and execution engine
([ADR-AUTO-ENGINE-THREEENGINES](execution-engines.md#rule-adr-auto-engine-threeengines)), with sensible defaults declared on its config type
— deliberately tight on a devbox — plus per-executable entries, and no "no limit" value. `Invoke-Executable` kills a child process tree at
its executable's limit; `Invoke-WithTimeout` / `Assert-CompletesWithin` / `Test-CompletesWithin` stop a piece of in-process work at its
limit. The bash limits bound every shell call an agent makes, foreground and background, and a hook denies a call outside them. Code that
legitimately runs longer while it is tuned carries an immutable budget GUID and is exempted in `timeout-exemptions.yml`, which raises its
limit to a ceiling but never lifts it; an agent's shell call carries no budget, so it takes no exemption.

- [A hang is the slowest failure](#a-hang-is-the-slowest-failure)
- [Bounding an agent's shell calls](#bounding-an-agents-shell-calls)

### Rule ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND

Mark a suspected block with a watchpoint, then bound it. Where a block is suspected but not yet found, a watchpoint stands there for one
measured run: it holds the thread on a fixed schedule and reports how late each tick ran, so a block shows as late ticks at a known place. A
block it finds becomes a time limit (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT) and the watchpoint is removed; a watchpoint that finds no block is
removed too. A watchpoint is a diagnostic behind a switch, never a standing cost, and it stops nothing.

- [A watchpoint finds the block a limit then bounds](#a-watchpoint-finds-the-block-a-limit-then-bounds)

## Context

Automation code is mostly side effects — creating resources, calling APIs, installing tools, writing files — which unit testing serves
poorly:

- **Mocking is fragile and misleading.** A mocked `Invoke-Executable` returning a canned string says nothing about the real CLI's exit
  codes, stderr behaviour, or edge cases, so mock-heavy tests pass in CI and fail in production.

- **Integration tests are slow and environment-dependent.** Installing Python, running poetry and deploying to Azure takes minutes, needs
  credentials, and breaks on a flaky network; it cannot run on every save.

- **Coverage is deceptive.** 90% line coverage still misses the bug, because it sits not in the logic but in the assumption that a variable
  is non-null, a path exists, a command returned the expected format, or an exit code was zero — the real failure modes of automation code.

Testing suits pure functions; automation code orchestrates external systems, and needs a strategy that matches.

### The inline assertion pattern

Quality is built _into_ the code with inline assertions: **assert every assumption at the point where it is made**, roughly every fifth line
on average.

Each assumption is checked by a call into the assertion library, not by a hand-written conditional that raises its own error. The library
call names its intent (`Assert-PathExist`, `Assert-NotNullOrWhitespace`), so a reviewer sees an assumption rather than control flow, and
every failure carries the same structured, self-contained message, so an error is greppable and reads the same wherever it fires.

This complements tests rather than replacing them: tests verify behaviour in controlled conditions, inline assertions verify assumptions in
_every_ execution, production and unanticipated edge cases included.

### In practice

A thin wrapper around an external tool shows the density. It takes one argument string, runs the tool, and returns its output, and it
asserts four things on the way:

1. the argument is not empty — a contract check with the caller, even where the parameter declaration already requires it;
2. the tool is installed — a contract check with the system;
3. the tool is at the expected version — a contract check with the system;
4. the tool produced output — a contract check with the integration: it returned something rather than nothing.

Five functional lines, four assertions — the minimum for a clear, immediate error per failure mode (the parameter name, the missing tool,
expected against actual version, the empty result at its source). Without them, each failure surfaces as a null-reference error three
functions down the stack, or a silent empty result that corrupts downstream state.

### Why every fifth line

The ratio is a guideline; the point is that assertions are _pervasive_, not an afterthought, and 20 lines without one almost certainly make
unchecked assumptions. Common assertion points:

- **Function entry.** What the parameter declaration cannot express: paths exist, strings are non-empty, objects have expected properties.

- **After external calls.** CLI tools, APIs, and file operations fail without raising an error — non-zero exit codes, empty responses,
  partial writes.

- **Before using a value.** A value that could be null, empty, or the wrong type is asserted, since upstream validation can change.

- **State transitions.** After setting state (environment variables, files, registry), assert it holds; external processes, group policies,
  or concurrent scripts can interfere.

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
The shell (one of the execution engines) sets what it bounds: each engine's code bounds its own blocks and processes, and the agent hook
bounds the agent's shell calls (the engine twin gives the forms). A caller can pin the environment with an `-EnvironmentAssertIs` guard,
which verifies and never selects.

An exemption is for work that is known to be slow while it is fixed. It names the work by an immutable budget GUID — registered in the
managed-GUID registry ([ADR-AUTO-GUIDS](managed-guids.md)), one at a time or as an inclusive range of a minted family — and carries the
reason. It raises the budget's limit to a ceiling and never removes it, and a gate that must not run exempt says so with
`Assert-IsNotTimeoutExempt`.

A function whose own work is long by nature — a full test run, a build — knows its limit better than any config, so it declares that limit
beside its own code rather than as a number literal in a default, where config cannot tune it, the environment cannot change it, and a
reader cannot find it. The more specific settings win in order — an exemption while the work is tuned, a `commands` entry in `timeouts.yml`
when a machine needs a different value, the function's own declaration otherwise, and the environment's default for a function that declares
nothing. Each setting is current and states something different; none is a fallback for an old shape.

### A watchpoint finds the block a limit then bounds

A limit is placed where the wait is, and a block that holds a thread without a known cause has no place yet. A watchpoint finds one: a call
that waits on a schedule of its own and reports each tick against it. A thread that is free keeps the schedule within the timer's
resolution, a few milliseconds; a thread held by something else misses it, and the late ticks say where. The watchpoint itself never bounds
anything and never fails the run: it reports, and a person or an agent reads the report.

Each watchpoint costs its full duration on every run that turns it on, so it stands only behind a diagnostic switch and only until the run
is read. Then it goes either way: a block it found is bounded by a limit in `timeouts.yml` at the place it named, and a place that kept its
schedule was not the block. The switch outlives its watchpoints, ready for the next suspicion.

### Bounding an agent's shell calls

A coding agent's shell call is the same wait with a different caller, so the hook (`.claude/hooks/Assert-BashTimeout/`) applies the same
bash limits to it. A foreground call passes a `timeout` within the foreground limit. A background call is different: the Bash tool does not
apply its `timeout` parameter to it, so it must start with a GNU `timeout <duration>` within the background limit, around a single command —
a compound command would leave everything after its first command unbounded. Exit 124 means the safeguard stopped it.

The hook denies and never rewrites. A hook that rewrites a command must also approve it, and an approval skips the permission prompt, while
a command wrapped in `bash -c` no longer matches the deny rules written for it. Denial leaves every other safeguard in force. Who asked
changes only what the denial says: the main session raises the blocker with the user, and a subagent reports it to its coordinator. Each
denial is also appended to `out/time-safeguard.log`, the list of blockers to tune.

The hook is a control, so it denies when it cannot decide: an error inside it, such as a payload it cannot read, denies the call and names
the failure. The one case that lets a call through is a hook not yet built, the bootstrap of a fresh clone before its first import publishes
the hook; the settings entry says so and names the command that builds it. The hook guards agent sessions on a devbox and is not published
in a pipeline, where no agent runs. A call that leaves through the bash tool is the only shell call it sees; a person's own interactive run
(`Invoke-Executable -Direct`) has a person at the prompt as its safeguard and no limit. A call that needs longer goes to the background or
gets a `timeouts.yml` entry; an exemption never applies to it.

The hook compiles the module's own config and verdict types (`TimeoutsConfig`, `BashSafeguard`), so its limits and decisions are the ones
`Get-TimeoutSeconds` resolves and the L0 tests check; an integrity test runs the published hook against the shipped config to prove it.

### The assert ladder

`A configuration is checked at five levels, each at the earliest point it can be`

A configuration value is asserted at the first level that can see what is wrong, so each level checks only what the ones before it cannot:

1. **Construct-time**, the config type's constructor: the shape, the enums and patterns, and each key's posture, so a required key that is
   missing throws naming the key and where to add it
   ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
2. **Load-time**, `Get-Config`: the fragment merged onto the shipped file, and a sealed config refusing one
   ([ADR-AUTO-OVERLAY-CONFIGFRAGMENT](consumer-overlay.md#rule-adr-auto-overlay-configfragment)).
3. **Cross-config**, the config validators and `Test-ConfigValidators`: what holds across configs, such as a name one config declares and
   another uses.
4. **Contract-time**, `Test-Contracts`: a provided asset against what the code takes and gives.
5. **Repo-time**, the gates over the whole tree: `Test-ShippedConfigs`, which also holds each shipped file to its type's defaults, and the
   rest of the quality gates.

A check placed one level too late lets a wrong value travel further before it stops the run, and a check placed one level too early cannot
see what it needs, so the ladder is where a new check is placed, not a list of extra checks.

## Decision

Use inline assertions pervasively throughout all automation code. Every assumption about inputs, state, and external results must be
asserted at the point where the assumption is made, through the assertion library, and an assertion failure is never caught; every wait is
bounded by a configured time limit, and a block not yet found is found with a watchpoint before it is bounded.

## Consequences

- Errors surface immediately at the point of failure with a clear message naming the exact assumption that was violated.
- A hang becomes a failure at a known limit instead of an indefinite wait; a limit too tight for real work surfaces as a blocker to tune in
  `timeouts.yml`, or an exemption with a reason in `timeout-exemptions.yml`.
- An agent cannot start a shell call that has no limit, in the foreground or the background, and a hook that fails denies; a denied call
  says how to re-issue it. Only an unbuilt hook, before the first import, lets a call through.
- Stack traces are short — typically one or two frames — because the assertion fires before the bad value propagates.
- Debugging is rarely needed. The error message from the assertion usually contains everything needed to diagnose the problem.
- Code is self-documenting: reading the assertions tells you the function's preconditions, postconditions, and invariants.
- Performance cost is negligible — assertions are simple boolean checks. The cost of _not_ asserting (silent corruption, misleading errors,
  hours of debugging) is orders of magnitude higher.
- Tests focus on behavior and integration, not on re-checking assumptions that the code asserts on every execution.
