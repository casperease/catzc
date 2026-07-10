# ADR: Environment variables are for external boundaries, not internal state

## Rules: ADR-AUTO-ENVVAR

### Rule ADR-AUTO-ENVVAR:1

Set `$env:` only for external tool contracts. If the consumer is our own code, use parameters or module-scoped variables.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR:2

Read `$env:` only for external system inputs — CI detection, OS paths, user-set toggles are inputs from outside our boundary.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR:3

Never require an `$env:` variable to be set for a function to work. Use `[Parameter(Mandatory)]` instead; the function signature is the
contract, not a hidden environment variable.

- [Prohibited uses](#prohibited-uses)
- [The correct alternative for internal state](#the-correct-alternative-for-internal-state)

### Rule ADR-AUTO-ENVVAR:4

Never mutate `$env:` mid-execution to communicate between functions. That is invisible coupling through global state; pass values through
parameters and return values.

- [Why environment variables are global mutable state](#why-environment-variables-are-global-mutable-state)
- [Prohibited uses](#prohibited-uses)

### Rule ADR-AUTO-ENVVAR:5

Bootstrap anchors (`$env:RepositoryRoot`) are set once in `importer.ps1` and never modified. They are treated as constants; modifying a
bootstrap anchor means the design is wrong.

- [Legitimate uses](#legitimate-uses)

### Rule ADR-AUTO-ENVVAR:6

Never store secrets in `$env:` as internal state our own code reads back — durable state, config, or a value our own code later reads. A
secret may cross to a child or external process through the environment only via the single disciplined seam `Write-EnvironmentSet`
(ADR-AUTO-ENVVAR:7), never written ad-hoc. `$env:` is visible to child processes, process-inspection tools, and crash dumps (CWE-526).

- [They are a security surface](#they-are-a-security-surface)
- [The one sanctioned secret hand-off](#the-one-sanctioned-secret-hand-off)

### Rule ADR-AUTO-ENVVAR:7

Handing a secret to a child or external process through the environment is a legitimate external-boundary use (ADR-AUTO-ENVVAR:1), permitted
only through `Write-EnvironmentSet` (`Catzc.Tooling.Environment`). That seam takes secrets as `[SecureString]`; never logs or returns the
plaintext (masks `***`); decrypts only at the `$env:` assignment; and defaults to scoped set/restore, persisting only on explicit
`-Persist`. Ad-hoc `$env:TOKEN = $plaintext` stays prohibited.

- [The one sanctioned secret hand-off](#the-one-sanctioned-secret-hand-off)

## Context

PowerShell makes `$env:` variables dangerously convenient. They look like regular variables, they are accessible everywhere, and they
survive function calls. This makes them tempting for passing state between functions, caching results, or storing configuration.

That temptation is the problem. Environment variables are the worst form of global mutable state because they have **no scoping, no type
safety, no automatic cleanup, and no visibility boundaries.**

A language gives code scoped mechanisms for its own state — parameters, return values, locals, module state — all destroyed or scoped
automatically. An environment variable set inside any function, at any call depth, persists for the entire process lifetime unless someone
explicitly removes it; no scope exit cleans it up. The PowerShell mechanics of obeying this rule — which scoped mechanism replaces which
`$env:` temptation, runspace sharing, test isolation — are the language layer,
[environment-variable-mechanics](powershell/environment-variable-mechanics.md) (`ADR-AUTO-PSENV`).

### Why environment variables are global mutable state

- **Global.** `$env:FOO` is readable and writable from any function, any module, any scope. There is no access control. Any code — yours,
  vendored, third-party — can read or mutate any environment variable. This couples all code together: you must reason about the entire
  process, not just the function you are reading.

- **Mutable.** Any code path can change the value at any time. Two consecutive reads of `$env:FOO` can return different values if something
  in between modified it.

- **Unscoped.** Unlike a language's scoped variables (a function local, module-level state), `$env:` has no boundaries at all. It bypasses
  the language's scope isolation entirely.

### They are always strings

`$env:` values are always strings. There is no type safety. `$env:COUNT = 42` stores the string `"42"`. `$env:ENABLED = $true` stores the
string `"True"`. Every consumer must parse and validate. There is no schema, no constraint, no `[ValidateSet()]`. Compare this to a function
parameter with `[int]`, `[switch]`, or `[ValidateRange()]` — the type system catches errors at the call site.

### They leak to child processes

Every process spawned via `Start-Process`, `Start-Job`, `&`, or external tool invocation inherits **all** environment variables from the
parent. A child process (a linter, a build tool, a third-party CLI) sees every `$env:` variable the parent set, even if it has no need for
them. This violates least privilege and creates an invisible coupling between parent and child.

### They break parallel execution and poison tests

Environment variables are process-wide, so concurrent workers share one mutable namespace — parallel reads and writes race — and a value set
in one test leaks into the next, producing order-dependent failures that are extremely difficult to diagnose. The PowerShell specifics
(runspace sharing, `$using:`, Pester's lack of `$env:` isolation) live in
[environment-variable-mechanics](powershell/environment-variable-mechanics.md).

### They are a security surface

Environment variables are visible to all child processes, can be dumped via `/proc/<pid>/environ` on Linux or process inspection tools on
Windows, and are frequently logged by CI systems and error-reporting frameworks. MITRE classifies "Cleartext Storage of Sensitive
Information in an Environment Variable" as CWE-526. Never store secrets, tokens, or credentials in `$env:` as internal state — for our own
code, use secret managers, `SecureString`, or secure parameter passing.

There is one narrow exception, and it is a hand-off, not a store: when an external tool's contract is to read a secret from the environment
(ADR-AUTO-ENVVAR:1), the secret must reach it through the environment. That crossing is confined to a single disciplined seam
([the one sanctioned secret hand-off](#the-one-sanctioned-secret-hand-off)); an ad-hoc `$env:TOKEN = $plaintext` remains prohibited.

### Case sensitivity is inconsistent

`$env:Path` and `$env:PATH` refer to the same variable on Windows but different variables on Linux. Using environment variables for internal
state means dealing with this cross-platform inconsistency in every consumer. Module-scoped variables have no such problem.

### The correct alternative for internal state

Internal state belongs in the mechanisms the language scopes and cleans up automatically: pass values between functions as parameters and
return values, and keep shared state in module scope. None of these leak to child processes, pollute tests, or persist beyond their natural
lifetime. The PowerShell mechanism table and idioms are the language layer,
[environment-variable-mechanics](powershell/environment-variable-mechanics.md) (`ADR-AUTO-PSENV`).

## Decision

Environment variables are used exclusively at external boundaries — never as internal state between our own functions.

### Legitimate uses

These are the only acceptable patterns for `$env:` in our code:

**1. Setting variables for external tools to consume.** External tools define their configuration contract through environment variables. We
set these so the tool behaves correctly:

```powershell
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'     # dotnet CLI reads this
$env:GIT_TERMINAL_PROMPT = '0'             # git reads this
$env:AZURE_CONFIG_DIR = $configPath         # Azure CLI reads this
$env:PSModulePath = $vendorPaths            # PowerShell reads this
```

The key distinction: the _consumer_ of the variable is an external process, not our code.

**2. Reading variables that external systems set.** CI platforms, container runtimes, and operating systems communicate via environment
variables. Reading these is fine — they are inputs from outside our boundary:

```powershell
$env:TF_BUILD          # set by Azure DevOps — are we in a pipeline?
$env:GITHUB_ACTIONS    # set by GitHub Actions — are we in a workflow?
$env:SystemRoot        # set by Windows — where is the OS?
```

A small family of `$env:CATZC_*` flags belongs to this category as well. They are deliberate external/diagnostic toggles — signals set by
the outer environment (a developer's shell, a test harness) that our code _reads_ to alter a presentation or test-isolation behaviour, never
to pass internal state between our own functions:

```powershell
$env:CATZC_MESSAGE_TIMESTAMPS   # opt-in: prefix Write-Message output with timestamps
$env:CATZC_BLOCK_REAL_PROCESS   # set by the L1 test harness: a real process launch means a mock was missed
```

The distinguishing feature is the same as `TF_BUILD`: the value is an input from outside our boundary (a human or a harness flips it), and
the function merely observes it. This is the boundary rule, not an exception to it — these are external toggles, not internal-state
plumbing.

**3. Setting a well-known anchor once at bootstrap.** `$env:RepositoryRoot` is set by `importer.ps1` at startup and never modified again. It
is effectively a constant — a process-wide anchor that removes the need to depend on `$PWD`. This is acceptable because it is set once,
never mutated, and serves the same role as a tool's contract variable (every function needs a stable root, and `$env:` is the only mechanism
that crosses module boundaries without passing parameters through every call).

### The one sanctioned secret hand-off

Setting a variable for an external tool (legitimate use 1) covers non-secret contract values directly — `$env:GIT_TERMINAL_PROMPT = '0'`.
Some external contracts are for a **secret**: a CLI or container that reads its token, key, or connection string from the environment. That
is still an external-boundary use — the consumer is an outside process, not our code — but a secret crossing the boundary demands more
discipline than a bare assignment, because the plaintext must not leak into a log, a return value, or a persisted variable that outlives the
call.

`ADR-AUTO-ENVVAR:6` forbids using `$env:` as a secret **store** — durable or internal state, config, or any secret our own code reads back
out of the environment. It does not forbid a disciplined secret **hand-off** to an external consumer that reads the secret from the
environment; that narrow, external-boundary crossing is `ADR-AUTO-ENVVAR:7`, and it is permitted through exactly one seam:

**`Write-EnvironmentSet`** (`Catzc.Tooling.Environment`) is the sole sanctioned way to place a secret in the environment for a child or
external process. It:

- takes secrets as `[SecureString]`, so a plaintext token is never a parameter value sitting in a caller's variables or a transcript;
- never logs or returns the plaintext — it masks the value as `***`, the same discipline as `Set-AdoPipelineVariable -IsSecret`;
- decrypts to plaintext only at the `$env:` assignment itself (the boundary), via
  `[System.Net.NetworkCredential]::new('', $secure).Password`;
- defaults to a **scoped** set/restore — it snapshots, sets, invokes a `-ScriptBlock`, and restores in a `finally`, so the secret leaves the
  environment when the block exits — and persists past the call only on an explicit `-Persist`.

The plaintext does land in `$env:` for the instant the external tool reads it — that is unavoidable, because the tool's contract is to read
it there, and it is the boundary hand-off the whole rule is about. What `ADR-AUTO-ENVVAR:7` guarantees is that this is the _only_ place the
plaintext exists, that it is not logged or returned, and that it does not outlive the hand-off. `SecureString` is DPAPI-encrypted only on
Windows; on Linux/macOS .NET stores it obfuscated rather than encrypted (see [cross-platform](cross-platform.md)). The value of the type
here is the **contract** — do not log, do not internalize, decrypt only at the boundary — not at-rest cryptography.

This _strengthens_ `ADR-AUTO-ENVVAR:6` rather than weakening it: scattered ad-hoc `$env:TOKEN = $plaintext` writes are replaced by one seam
that carries the don't-log / don't-persist / decrypt-at-boundary discipline, so a reviewer has one function to audit instead of every string
assignment.

### Prohibited uses

**Never use `$env:` as internal state between our own functions:**

```powershell
# BAD — passing state through the environment
function Install-Tool {
    # ...install logic...
    $env:LAST_INSTALLED_TOOL = $toolName      # leaks to every child process
}
function Show-Summary {
    Write-Host "Installed: $env:LAST_INSTALLED_TOOL"  # invisible coupling
}

# GOOD — pass it as a return value or parameter
function Install-Tool {
    # ...install logic...
    return $toolName
}
$installed = Install-Tool -Name 'python'
Show-Summary -ToolName $installed
```

**Never use `$env:` as a cache or flag:**

```powershell
# BAD — caching in the environment
function Get-Config {
    if ($env:CONFIG_LOADED) { return $script:CachedConfig }
    $script:CachedConfig = Import-PowerShellDataFile $path
    $env:CONFIG_LOADED = '1'
    return $script:CachedConfig
}

# GOOD — module-scoped variable, no env var needed
function Get-Config {
    if ($script:CachedConfig) { return $script:CachedConfig }
    $script:CachedConfig = Import-PowerShellDataFile $path
    return $script:CachedConfig
}
```

**Never use `$env:` to gate functionality:**

```powershell
# BAD — "if this env is not defined, we don't work"
function Deploy-App {
    if (-not $env:DEPLOY_TARGET) {
        throw 'Set $env:DEPLOY_TARGET before calling Deploy-App'
    }
}

# GOOD — make it a parameter with validation
function Deploy-App {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('preprod', 'production')]
        [string] $Target
    )
}
```

The parameter approach gives you type validation, tab completion, mandatory enforcement, and documentation — all for free. The `$env:`
approach gives you a stringly-typed global that the caller has to know about by reading the implementation.

## On twelve-factor app configuration

The twelve-factor app methodology recommends storing configuration in environment variables that are "granular controls, each fully
orthogonal to other env vars" and "never grouped together as environments."

This is sound advice for its original domain: stateless web applications with a handful of independent settings (a database URL, an API key,
a log level).

Each knob is truly independent — changing the log level has no relationship to the database host.

Infrastructure platform configuration is a fundamentally different domain.

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

This is what `Catzc.Azure.Templates/configs/azure.yml` and `Get-Config -Config azure` provide: the selection dimensions (customers,
environments, types), validated for referential integrity on load. They are not the configuration system itself — they are the axes by which
configuration is selected.

The actual configuration system (resource names, connection strings, feature flags) is a separate concern that consumes these dimensions.

This does not contradict twelve-factor's underlying principle — "don't bake environment-specific values into code." It recognizes that
twelve-factor's implementation advice (flat independent env vars) breaks down when configuration values depend on each other and are
selected by structured, interrelated dimensions.

Environment variables remain the right answer when your config is genuinely a flat set of independent knobs.

## Consequences

- Function signatures document their inputs. Callers do not need to set hidden environment variables before calling a function.
- Tests are isolated. No environment variable leaks between test cases, no snapshot/restore ceremony.
- Parallel execution is safe. Module-scoped variables are per-runspace; `$env:` is not.
- Child processes only see variables that were set intentionally for them, not internal state that leaked.
- Debugging is straightforward. State flows through parameters and return values — you can trace it by reading the code. Global mutable
  state requires tracing every possible mutation site in the entire process.
- The codebase has a single persistent path anchor — `$env:RepositoryRoot`, set once at bootstrap and never modified. The only other `$env:`
  our code defines for itself are the handful of `$env:CATZC_*` external/diagnostic toggles, which are read (not written) as boundary
  inputs. Internal state flows through function contracts, not the environment.
- Secrets reach an external tool through one auditable seam. A secret bound into `$env:` for a child process goes through
  `Write-EnvironmentSet` (ADR-AUTO-ENVVAR:7) — `SecureString` in, masked in logs, decrypted only at the assignment, scoped by default — so
  there is a single function to review rather than scattered ad-hoc secret-into-env writes.
