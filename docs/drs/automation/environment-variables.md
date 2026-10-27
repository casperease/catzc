# ADR: Environment variables are for external boundaries, not internal state

## Rules: ADR-AUTO-ENVVAR

### Rule ADR-AUTO-ENVVAR-SETONLYFORTOOLS

Set an environment variable only to meet an external tool's contract. When the consumer is our own code, the value travels as a parameter or
in module state.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR-READONLYOUTSIDEINPUT

Read an environment variable only as an input from outside our boundary — CI detection, OS paths, and user-set toggles. CI detection reads
its variables in one place, `Test-IsRunningInPipeline`, and every other caller asks that function.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR-NEVERREQUIRED

Never require an environment variable to be set for a function to work. A required input is a mandatory, typed parameter; the function
signature is the contract, not a hidden environment variable.

- [Prohibited uses](#prohibited-uses)
- [Internal state instead](#internal-state-instead)

### Rule ADR-AUTO-ENVVAR-NOTFORCOMMUNICATION

Never write an environment variable mid-execution to communicate between functions. That is invisible coupling through global state; pass
values through parameters and return values.

- [Global mutable state](#global-mutable-state)
- [Prohibited uses](#prohibited-uses)

### Rule ADR-AUTO-ENVVAR-ANCHORSSETONCE

The bootstrap anchors — the working root and the code root — are set once by the importer entry and never modified. They are treated as
constants; modifying a bootstrap anchor means the design is wrong.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR-NOSECRETSTATE

Never store a secret in an environment variable as internal state our own code reads back — durable state, config, or a value our own code
later reads. A secret may cross to a child or external process through the environment only via the single disciplined seam
`Write-EnvironmentSet` (ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS), never written ad hoc. The environment is visible to child processes,
process-inspection tools, and crash dumps (CWE-526).

- [They are a security surface](#they-are-a-security-surface)
- [The secret hand-off](#the-secret-hand-off)

### Rule ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS

Handing a secret to a child or external process through the environment is a legitimate external-boundary use
(ADR-AUTO-ENVVAR-SETONLYFORTOOLS), permitted only through `Write-EnvironmentSet` (`Catzc.Tooling.Environment`). That seam takes the secret
as a protected value, never as plain text; never logs or returns the plaintext (it masks it as `***`); decrypts only at the moment it sets
the variable; and defaults to a scoped set and restore, persisting only on explicit request. An ad-hoc assignment of a plaintext secret
stays prohibited.

- [The secret hand-off](#the-secret-hand-off)

## Context

Environment variables are dangerously convenient: in most engines they look like regular variables, reach everywhere, and survive function
calls, which tempts code to pass state, cache results, or store configuration in them. They are the worst form of global mutable state: **no
scoping, no type safety, no automatic cleanup, and no visibility boundaries.**

A language confines its own state — parameters, return values, locals, module state — and cleans it up automatically. An environment
variable set at any call depth persists for the whole process until someone removes it. How an engine obeys this rule — which scoped
mechanism replaces which temptation, worker sharing, test isolation — is its twin record's to say.

### Global mutable state

`Why environment variables are global mutable state`

- **Global.** Any code — ours, vendored, third-party — can read or mutate any environment variable from any scope, with no access control,
  so reasoning about one function means reasoning about the whole process.

- **Mutable.** Two consecutive reads can return different values if anything in between changed it.

- **Unscoped.** It bypasses the language's scope isolation entirely.

### They are always strings

A number or a boolean is stored as its text, and every consumer must parse and validate it — no schema, no constraint, no call-site check,
where a typed parameter with a validated range or set fails at the call site.

### They leak to child processes

Every child process (a linter, a build tool, a third-party CLI) inherits **all** of the parent's variables, needed or not — a breach of
least privilege and an invisible coupling between parent and child.

### Parallel runs and tests

`They break parallel execution and poison tests`

Concurrent workers share one process-wide mutable namespace, so parallel reads and writes race, and a value set in one test leaks into the
next as an order-dependent failure that is hard to diagnose. The engine specifics live in the engine twin.

### They are a security surface

Environment variables are visible to all child processes, can be dumped via `/proc/<pid>/environ` on Linux or process inspection tools on
Windows, and are frequently logged by CI systems and error-reporting frameworks. MITRE classifies "Cleartext Storage of Sensitive
Information in an Environment Variable" as CWE-526. Never store secrets, tokens, or credentials in an environment variable as internal state
— for our own code, use secret managers, protected secret types, or secure parameter passing.

There is one narrow exception, and it is a hand-off, not a store: when an external tool's contract is to read a secret from the environment
(ADR-AUTO-ENVVAR-SETONLYFORTOOLS), the secret must reach it through the environment. That crossing is confined to a single disciplined seam
([the one sanctioned secret hand-off](#the-secret-hand-off)); an ad-hoc assignment of a plaintext secret remains prohibited.

### Inconsistent case sensitivity

`Case sensitivity is inconsistent`

Names are case-insensitive on Windows and case-sensitive on Linux, so `Path` and `PATH` are one variable on one platform and two on the
other, and every consumer of internal state kept there inherits the inconsistency. Module-scoped variables do not.

### Internal state instead

`The correct alternative for internal state`

Values pass between functions as parameters and return values, and shared state lives in module scope — mechanisms whose scope and cleanup
the language manages, which never leak to child processes, pollute tests, or outlive their natural lifetime. The engine's mechanism table is
in its twin.

## Decision

Environment variables are used exclusively at external boundaries — never as internal state between our own functions.

### Legitimate uses

These are the only acceptable uses of environment variables in our code:

**1. Setting variables for external tools to consume.** External tools define their configuration contract through environment variables —
the dotnet CLI's telemetry opt-out, git's terminal prompt, the Azure CLI's config folder, an engine's module path. The _consumer_ is an
external process, not our code.

**2. Reading variables that external systems set.** CI platforms, container runtimes, and operating systems communicate through them — the
Azure DevOps and GitHub Actions markers, the Windows system root — as inputs from outside our boundary. The two CI markers are read only
inside `Test-IsRunningInPipeline`.

The small family of `CATZC_*` flags belongs here too: external/diagnostic toggles that a developer's shell or a test harness sets and our
code only _reads_, to alter a presentation or test-isolation behaviour — the boundary rule, not an exception to it.

**3. Setting a well-known anchor once at bootstrap.** The importer entry sets the working root at startup and never changes it, so it is
effectively a constant that removes any dependence on the working directory. It plays a tool contract variable's role: every function needs
a stable root, and the environment is the only mechanism that crosses module boundaries without threading a parameter through every call.

The engine twin gives an example of each use.

### The secret hand-off

`The one sanctioned secret hand-off`

Some external contracts are for a **secret**: a CLI or container that reads its token, key, or connection string from the environment. That
is still an external-boundary use, but it needs more discipline than a bare assignment, because the plaintext must not leak into a log, a
return value, or a variable that outlives the call.

ADR-AUTO-ENVVAR-NOSECRETSTATE forbids the environment as a secret **store** — durable or internal state, config, or a secret our own code
reads back. A **hand-off** to an external consumer is ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS, permitted through exactly one seam:
**`Write-EnvironmentSet`** (`Catzc.Tooling.Environment`). It takes the secret as a protected value, never logs or returns the plaintext,
decrypts only at the assignment that is the boundary, and by default removes the secret when the hand-off ends; the engine twin gives its
mechanics.

The plaintext lands in the environment for the instant the tool reads it — unavoidable, since that is the tool's contract — and that seam is
the _only_ place it exists, never logged, unreturned, and not outliving the hand-off. One auditable function in place of scattered ad-hoc
assignments _strengthens_ ADR-AUTO-ENVVAR-NOSECRETSTATE.

### Prohibited uses

- **Never use an environment variable as internal state between our own functions.** One function writing a variable that another reads
  leaks the value to every child process and couples the two invisibly; the value is a return value and a parameter instead.
- **Never use an environment variable as a cache or flag.** A "loaded" flag in the environment outlives the session's own cache and leaks to
  child processes; a cache lives in module state ([caching](caching.md)).
- **Never make functionality depend on an environment variable being set.** A function that throws when a variable is unset hides its input;
  a mandatory, validated parameter gives type validation, tab completion, mandatory enforcement, and documentation for free.

The engine twin shows each as BAD and GOOD code.

## Twelve-factor configuration

`On twelve-factor app configuration`

The twelve-factor app methodology stores configuration in environment variables that are "granular controls, each fully orthogonal to other
env vars" and "never grouped together as environments." That suits its setting: a stateless web application with a handful of independent
knobs (a database URL, an API key, a log level).

Infrastructure platform configuration is a different problem. In a multi-customer, multi-environment system the values form a dependency
graph: a resource group name derives from the customer shortname, the environment, and the type; the subscription depends on the
environment, and the service connection on the subscription. Flat variables for this produce hundreds of individually managed values with no
visible relationships, no consistency validation, and the customer shortname duplicated in dozens of them — a new customer touches dozens of
places, and nobody can see the structure.

So an infrastructure platform separates **selection criteria** from **configuration**. Selection criteria — customer, environment,
environment type — are control signals that decide _which_ configuration applies: in a pipeline they steer the flow, in a function they
decide what to look up. `Catzc.Azure/configs/azure.yml` and `Get-Config -Config azure` provide these dimensions, validated for referential
integrity on load; the configuration proper (resource names, connection strings, feature flags) is a separate concern that consumes them.

This keeps twelve-factor's principle — "don't bake environment-specific values into code" — and drops only its implementation advice where
values depend on each other. Environment variables remain right for configuration that is genuinely a flat set of independent knobs.

## Consequences

- Function signatures document their inputs. Callers do not need to set hidden environment variables before calling a function.
- Tests are isolated. No environment variable leaks between test cases, no snapshot/restore ceremony.
- Parallel execution is safe. Module state is per worker; the environment is not.
- Child processes only see variables that were set intentionally for them, not internal state that leaked.
- Debugging is straightforward. State flows through parameters and return values — you can trace it by reading the code. Global mutable
  state requires tracing every possible mutation site in the entire process.
- The codebase has two persistent path anchors — the working root and the code root (see [platform-bundle](platform-bundle.md)), each set
  once at bootstrap and never modified. The only other environment variables our code defines for itself are the handful of `CATZC_*`
  external/diagnostic toggles, which are read (not written) as boundary inputs. Internal state flows through function contracts, not the
  environment.
- Secrets reach an external tool through one auditable seam. A secret bound into the environment for a child process goes through
  `Write-EnvironmentSet` (ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS) — protected in, masked in logs, decrypted only at the assignment, scoped by
  default — so there is a single function to review rather than scattered ad-hoc secret-into-environment writes.
