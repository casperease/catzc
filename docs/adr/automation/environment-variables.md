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

Environment variables are dangerously convenient. In most engines they look like regular variables, they are accessible everywhere, and they
survive function calls. This makes them tempting for passing state between functions, caching results, or storing configuration.

That temptation is the problem. Environment variables are the worst form of global mutable state because they have **no scoping, no type
safety, no automatic cleanup, and no visibility boundaries.**

A language gives code scoped mechanisms for its own state — parameters, return values, locals, module state — all destroyed or scoped
automatically. An environment variable set inside any function, at any call depth, persists for the entire process lifetime unless someone
explicitly removes it; no scope exit cleans it up. The PowerShell mechanics of obeying this rule — which scoped mechanism replaces which
environment-variable temptation, runspace sharing, test isolation — are the language layer,
[environment-variable-mechanics](../pwsh/environment-variable-mechanics.md) (`ADR-PWSH-ENV`).

### Global mutable state

`Why environment variables are global mutable state`

- **Global.** An environment variable is readable and writable from any function, any module, any scope. There is no access control. Any
  code — yours, vendored, third-party — can read or mutate any environment variable. This couples all code together: you must reason about
  the entire process, not just the function you are reading.

- **Mutable.** Any code path can change the value at any time. Two consecutive reads of the same variable can return different values if
  something in between modified it.

- **Unscoped.** Unlike a language's scoped variables (a function local, module-level state), an environment variable has no boundaries at
  all. It bypasses the language's scope isolation entirely.

### They are always strings

An environment variable's value is always a string. There is no type safety: a number or a boolean is stored as its text, and every consumer
must parse and validate it. There is no schema, no constraint, and no validation at the call site. Compare this to a typed function
parameter with a validated range or set — the type system catches errors at the call site.

### They leak to child processes

Every child process inherits **all** environment variables from the parent. A child process (a linter, a build tool, a third-party CLI) sees
every variable the parent set, even if it has no need for them. This violates least privilege and creates an invisible coupling between
parent and child.

### Parallel runs and tests

`They break parallel execution and poison tests`

Environment variables are process-wide, so concurrent workers share one mutable namespace — parallel reads and writes race — and a value set
in one test leaks into the next, producing order-dependent failures that are extremely difficult to diagnose. The PowerShell specifics
(runspace sharing, `$using:`, Pester's lack of environment isolation) live in
[environment-variable-mechanics](../pwsh/environment-variable-mechanics.md).

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

Environment-variable names are case-insensitive on Windows and case-sensitive on Linux, so `Path` and `PATH` are one variable on one
platform and two on the other. Using environment variables for internal state means dealing with this cross-platform inconsistency in every
consumer. Module-scoped variables have no such problem.

### Internal state instead

`The correct alternative for internal state`

Internal state belongs in the mechanisms whose scope and cleanup the language manages automatically: pass values between functions as
parameters and return values, and keep shared state in module scope. None of these leak to child processes, pollute tests, or persist beyond
their natural lifetime. The PowerShell mechanism table and idioms are the language layer,
[environment-variable-mechanics](../pwsh/environment-variable-mechanics.md) (`ADR-PWSH-ENV`).

## Decision

Environment variables are used exclusively at external boundaries — never as internal state between our own functions.

### Legitimate uses

These are the only acceptable uses of environment variables in our code:

**1. Setting variables for external tools to consume.** External tools define their configuration contract through environment variables —
the dotnet CLI's telemetry opt-out, git's terminal prompt, the Azure CLI's config folder, PowerShell's module path. We set these so the tool
behaves correctly. The key distinction: the _consumer_ of the variable is an external process, not our code.

**2. Reading variables that external systems set.** CI platforms, container runtimes, and operating systems communicate via environment
variables — the Azure DevOps and GitHub Actions markers, the Windows system root. Reading these is fine — they are inputs from outside our
boundary. The two CI markers are read only inside `Test-IsRunningInPipeline`; the related flow rule is
[ADR-FLOW-CD-DETECT-NODIRECTVARIABLECHECK](../flow/pipeline-detection.md#rule-adr-flow-cd-detect-nodirectvariablecheck).

A small family of `CATZC_*` flags belongs to this category as well. They are deliberate external/diagnostic toggles — signals set by the
outer environment (a developer's shell, a test harness) that our code _reads_ to alter a presentation or test-isolation behaviour, never to
pass internal state between our own functions. The value is an input from outside our boundary (a human or a harness flips it), and the
function merely observes it. This is the boundary rule, not an exception to it.

**3. Setting a well-known anchor once at bootstrap.** The working root is set by the importer entry at startup and never modified again. It
is effectively a constant — a process-wide anchor that removes the need to depend on the working directory. This is acceptable because it is
set once, never mutated, and serves the same role as a tool's contract variable (every function needs a stable root, and the environment is
the only mechanism that crosses module boundaries without passing parameters through every call).

The PowerShell examples of each use are [environment-variable-mechanics](../pwsh/environment-variable-mechanics.md).

### The secret hand-off

`The one sanctioned secret hand-off`

Setting a variable for an external tool (legitimate use 1) covers non-secret contract values directly. Some external contracts are for a
**secret**: a CLI or container that reads its token, key, or connection string from the environment. That is still an external-boundary use
— the consumer is an outside process, not our code — but a secret crossing the boundary demands more discipline than a bare assignment,
because the plaintext must not leak into a log, a return value, or a persisted variable that outlives the call.

ADR-AUTO-ENVVAR-NOSECRETSTATE forbids using the environment as a secret **store** — durable or internal state, config, or any secret our own
code reads back out of the environment. It does not forbid a disciplined secret **hand-off** to an external consumer that reads the secret
from the environment; that narrow, external-boundary crossing is ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS, and it is permitted through exactly
one seam: **`Write-EnvironmentSet`** (`Catzc.Tooling.Environment`). It takes the secret as a protected value, never logs or returns the
plaintext, decrypts only at the assignment that is the boundary, and by default removes the secret from the environment when the hand-off
ends. Its PowerShell mechanics are [environment-variable-mechanics](../pwsh/environment-variable-mechanics.md#the-secret-hand-off).

The plaintext does land in the environment for the instant the external tool reads it — that is unavoidable, because the tool's contract is
to read it there, and it is the boundary hand-off the whole rule is about. What ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS guarantees is that this
is the _only_ place the plaintext exists, that it is not logged or returned, and that it does not outlive the hand-off.

This _strengthens_ ADR-AUTO-ENVVAR-NOSECRETSTATE rather than weakening it: scattered ad-hoc plaintext assignments are replaced by one seam
that carries the don't-log / don't-persist / decrypt-at-boundary discipline, so a reviewer has one function to audit instead of every string
assignment.

### Prohibited uses

- **Never use an environment variable as internal state between our own functions.** One function writing a variable that another reads
  leaks the value to every child process and couples the two invisibly; the value is a return value and a parameter instead.
- **Never use an environment variable as a cache or flag.** A "loaded" flag in the environment outlives the session's own cache and leaks to
  child processes; a cache lives in module state ([caching](caching.md)).
- **Never make functionality depend on an environment variable being set.** A function that throws when a variable is unset hides its input;
  a mandatory, validated parameter gives type validation, tab completion, mandatory enforcement, and documentation for free.

The PowerShell form of each, as BAD and GOOD code, is [environment-variable-mechanics](../pwsh/environment-variable-mechanics.md).

## Twelve-factor configuration

`On twelve-factor app configuration`

The twelve-factor app methodology recommends storing configuration in environment variables that are "granular controls, each fully
orthogonal to other env vars" and "never grouped together as environments."

This is sound advice for its original setting: stateless web applications with a handful of independent settings (a database URL, an API
key, a log level).

Each knob is truly independent — changing the log level has no relationship to the database host.

Infrastructure platform configuration is a fundamentally different problem.

In a multi-customer, multi-environment system, configuration values form a dependency graph, not a flat set of independent knobs.

A resource group name derives from the customer shortname, the environment, and the type.

The subscription depends on the environment. The service connection depends on the subscription.

These values are not orthogonal — they are computed from a small set of dimensions.

Applying twelve-factor's flat env var advice to this domain produces hundreds of individually managed variables with no visible
relationships, no consistency validation, and rampant duplication (the customer shortname appears in dozens of variables).

Adding a new customer means touching dozens of places and hoping they all agree.

No one can look at the configuration and understand its structure.

The correct approach for infrastructure platforms is to separate **selection criteria** from **configuration**.

Selection criteria are the dimensions that determine _which_ configuration applies: customer, environment, environment type.

They are control signals — in a pipeline they control the path of flow, in a function they determine what to look up.

This is what `Catzc.Azure/configs/azure.yml` and `Get-Config -Config azure` provide: the selection dimensions (customers, environments,
types), validated for referential integrity on load. They are not the configuration system itself — they are the axes by which configuration
is selected.

The actual configuration system (resource names, connection strings, feature flags) is a separate concern that consumes these dimensions.

This does not contradict twelve-factor's underlying principle — "don't bake environment-specific values into code." It recognizes that
twelve-factor's implementation advice (flat independent env vars) breaks down when configuration values depend on each other and are
selected by structured, interrelated dimensions.

Environment variables remain the right answer when your config is genuinely a flat set of independent knobs.

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
