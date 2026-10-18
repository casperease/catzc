# ADR: An explicit dry-run parameter on every side-effecting function

## Rules: ADR-AUTO-DRYRUN

### Rule ADR-AUTO-DRYRUN:1

Every function that performs a side effect (deploy, install, delete, tag, CLI invocation) takes an explicit dry-run parameter, `DryRun`.

- [An explicit parameter](#an-explicit-parameter)
- [The idiom](#the-idiom)

### Rule ADR-AUTO-DRYRUN:2

Branch before the side effect: the dry-run path returns the planned action (command string, resolved target) and mutates nothing. The result
must be observable by return value or captured output, never only narration written to the terminal.

- [The idiom](#the-idiom)
- [Why not an implicit mode](#why-not-an-implicit-mode)

### Rule ADR-AUTO-DRYRUN:3

Propagate the dry-run value explicitly down the call chain: a function passes its own value to every callee that takes one. No ambient
setting, no implicit inheritance — pass the flag like any other argument.

- [An explicit parameter](#an-explicit-parameter)

### Rule ADR-AUTO-DRYRUN:4

Do not ask for confirmation. A genuinely destructive operation makes itself safe by idempotent design (a no-op when there is nothing to
remove), not by an interactive prompt.

- [Decision](#decision)
- [An explicit parameter](#an-explicit-parameter)

## Context

Side-effecting automation functions — those that deploy, install, delete, tag, or shell out to a CLI — need a "don't actually do it" mode,
for previewing and for tests that must verify _what would happen_ without making it happen. Engines and frameworks often ship an implicit
one: a session-wide what-if mode that functions opt into, a preference that flows down the call chain on its own, and a confirmation prompt
before each destructive step. It looks like the idiomatic choice. We deliberately do **not** use it.

### Why not an implicit mode

`Why an implicit what-if mode is the wrong tool here`

- **Its output is not capturable, so it is not testable.** An implicit mode typically narrates what it would do straight to the terminal,
  past the output a caller can capture, and answers only "go ahead or not". A test cannot assert on the narration, cannot silence it, and
  the function cannot **return the action it would take** for a test to inspect. Good tests assert on a return value or a mockable call — an
  implicit mode gives neither.

- **It is special plumbing that is easy to get subtly wrong.** Making an implicit mode actually safe requires separate, invisible steps:
  opting the function in, guarding **every** side effect at exactly the right place, and making sure the mode reaches **every** nested call
  that has its own side effects. Miss any one and the side effect fires in what-if mode — a silent, dangerous failure that looks like it
  worked. The ceremony is not visible at the call site, and people forget it.

- **It is ambient state.** Whether a call previews or acts depends on settings inherited from wherever the call came from — implicit,
  surprising, and hard to reason about. An explicit parameter passed by hand has none of that ambiguity.

### An explicit parameter

A plain **`DryRun`** switch. When set, the function **returns the action it would take** (the command string, the would-be target) and
performs **no** side effect. This is the established convention across the `Invoke-*` family and `Invoke-Executable`: a caller passes the
switch on, explicitly, to each callee that takes one, and a test asserts on what comes back.

A dry-run parameter is a normal parameter: explicit, greppable, returns an assertable value, propagates by plain pass-through, and adds no
terminal noise. A destructive function needs no confirmation prompt on top of it: it is written to converge
([idempotent-state-functions](idempotent-state-functions.md)), so running it when there is nothing to do does nothing, and a dry run shows
what it would do before anyone runs it for real.

## Decision

Side-effecting functions take an explicit `DryRun` parameter, branch on it before the side effect, return the planned action, and pass it on
explicitly. No implicit what-if mode, no ambient preference, and no confirmation prompt.

### The idiom

The function checks the dry-run value first, before anything changes. When it is set, the function returns the action it would take — the
exact command string, the resolved target — and returns nothing else. Otherwise it performs the action. A test calls the function with the
switch set, asserts on the returned plan, and verifies that the call that would have made the change never ran.

### How this is enforced

- **The exemplars.** The `Tooling` group's `Invoke-*` family and `Invoke-Executable` are the patterns new side-effecting functions copy.
- **Code review.** An implicit what-if mode or a confirmation prompt is rejected in review in favour of `DryRun`.
- **Tests stay quiet and assertive.** Because dry-run is a returned value (not terminal narration), tests capture it directly — no
  un-suppressable narration polluting the run (see [test-automation](test-automation.md) and
  [console-output-matters](console-output-matters.md)).

## Consequences

- Side effects are previewable and testable by **return value** — a dry-run call returns the planned action and the test confirms nothing
  ran.
- No terminal noise: the run is clean because nothing narrates past the output a caller captures.
- No silent-failure mode from a forgotten guard or an un-propagated mode.
- Behaviour is explicit and local — no ambient setting to reason about across the call chain.
- The cost: we forgo an engine's built-in what-if and confirmation support, and any analyzer rule that asks for it. We accept that —
  testability and a low-ceremony, hard-to-misuse API win.
