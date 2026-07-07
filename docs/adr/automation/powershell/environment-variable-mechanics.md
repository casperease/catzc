# ADR: Environment-variable mechanics — the PowerShell layer over environment-variables

## Rules: ADR-PSENV

### Rule ADR-PSENV:1

PowerShell code applies the boundary doctrine of [environment-variables](../environment-variables.md) (`ADR-ENVVAR`) with the language
mechanics below: `$env:` is the boundary-only channel, and everything internal flows through PowerShell's own scoping.

- [The internal-state mechanisms](#the-internal-state-mechanisms)

### Rule ADR-PSENV:2

Internal state uses the language's scoped mechanisms — function parameters, return values, `$local:` locals, and module-scoped `$script:`
state — never `$env:`. Each is destroyed or scoped automatically; `$env:` persists for the process lifetime with no scoped cleanup.

- [The internal-state mechanisms](#the-internal-state-mechanisms)

### Rule ADR-PSENV:3

Runspaces share one process environment block. Never read or write `$env:` inside `ForEach-Object -Parallel` or a runspace worker to
coordinate work — concurrent access races. Pass values in with `$using:` and aggregate through pipeline output or a thread-safe collection.

- [Runspaces share one environment block](#runspaces-share-one-environment-block)

### Rule ADR-PSENV:4

Pester provides no `$env:` isolation. A test that must set an environment variable snapshots and restores it (`try`/`finally`, or
`BeforeAll`/`AfterAll`), and never leaves a value behind for the next test — leaked `$env:` state creates order-dependent failures.

- [Tests get no environment isolation](#tests-get-no-environment-isolation)

## Context

[environment-variables](../environment-variables.md) fixes the doctrine: environment variables are for external boundaries, never internal
state. This ADR is the PowerShell layer under it — the concrete mechanics of obeying that doctrine in this codebase's language.

PowerShell makes `$env:` variables dangerously convenient. They look like regular variables, they are accessible everywhere, and they
survive function calls — which makes them tempting for passing state between functions, caching results, or storing configuration. The
language also supplies exactly the scoped alternatives the doctrine demands: `$local:`, `$script:`, module scope, function parameters, and
return values, all destroyed or scoped automatically. `$env:FOO` set inside any function, at any call depth, persists for the entire process
lifetime unless someone explicitly removes it; there is no `try`/`finally` equivalent that cleans up environment variables when a scope
exits.

### The internal-state mechanisms

| Mechanism            | Scope   | Cleanup        | Type-safe    | Testable                  |
| -------------------- | ------- | -------------- | ------------ | ------------------------- |
| Function parameters  | Call    | Automatic      | Yes          | Trivially                 |
| Return values        | Call    | Automatic      | Yes          | Trivially                 |
| `$script:` variables | Module  | Module unload  | Yes          | Mockable                  |
| `$env:` variables    | Process | Never (manual) | No (strings) | Requires snapshot/restore |

To pass a value between functions, pass it as a parameter. To share state within a module, use `$script:`. To cache a result, use a
module-scoped variable (see [caching](../caching.md)). None of these leak to child processes, pollute tests, or persist beyond their natural
lifetime — and unlike `$env:` (always strings), each carries the type system: `[int]`, `[switch]`, `[ValidateRange()]` catch errors at the
call site.

### Runspaces share one environment block

All runspaces in a `ForEach-Object -Parallel` block share the same process environment block. Environment variables are not isolated per
runspace — they are process-wide. Concurrent reads and writes to the same `$env:` variable from different runspaces produce race conditions.
Unlike `$using:` variables (which are copied per-runspace), `$env:` is a single shared namespace — so a parallel block that needs an outer
value takes it through `$using:`, and one that produces results emits them through the pipeline or a thread-safe collection (see
[prefer-foreach-over-foreach-object](prefer-foreach-over-foreach-object.md) for the wider `-Parallel` rules).

### Tests get no environment isolation

Environment variables set in one test leak into subsequent tests. If Test A sets `$env:MODE = 'test'` and forgets to clean up, Test B runs
with an unexpected `$env:MODE` — an order-dependent failure that is extremely difficult to diagnose. Pester provides `TestDrive:` for file
isolation and scoped cleanup for PowerShell variables, but it provides **no automatic isolation for environment variables**: a test that
must touch `$env:` snapshots the value and restores it in a `finally` (or `AfterAll`), every time. That ceremony is itself the argument for
function parameters over `$env:` — proper parameters need none of it.

## Decision

PowerShell code keeps internal state in the language's scoped mechanisms (parameters, return values, `$local:`, `$script:`), treats `$env:`
in parallel runspaces as a shared, race-prone namespace never used for coordination, and snapshots/restores any `$env:` value a test must
touch.

### How this is enforced

- **The doctrine layer** — which `$env:` uses are legitimate at all is [environment-variables](../environment-variables.md) (`ADR-ENVVAR`);
  this ADR only fixes the language mechanics.
- **Code review** — a `$env:` read or write that is not an external-boundary use per `ADR-ENVVAR`, a `-Parallel` block touching `$env:`, or
  a test that sets `$env:` without restoring it is rejected against this ADR.

## Consequences

- Internal state flows through contracts the engine cleans up automatically — no manual environment hygiene, no leakage between functions,
  child processes, runspaces, or tests.
- Parallel code stays race-free by construction: `$using:` copies values per runspace, and results travel through the pipeline.
- Tests stay order-independent: the few that legitimately touch `$env:` (external toggles like `$env:CATZC_*`) restore what they change.
- The cost is remembering four mechanisms instead of one global bag — which is the point: each mechanism carries its scope in its name.

## Dora explains:

DORA's research on test automation and deployment reliability emphasizes isolation and predictability—and process-wide environment variables
violate both. Using scoped mechanisms (parameters, return values, `$script:` state) instead of `$env:` for internal coordination provides
automatic cleanup, prevents test leakage, and enables confident concurrent execution.

- [Test automation](https://dora.dev/capabilities/test-automation/) — scoped, isolated state prevents order-dependent test failures and race
  conditions.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — proper scoping bounds state lifetime and surfaces contracts
  at the call site.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — predictable state isolation enables safe parallelism and
  reduces deployment friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
