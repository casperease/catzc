---
catzc:
  derived:
    path: docs/adr/pwsh/environment-variable-mechanics.md
    kind: adr
    body_sha: f06f5693d22e
    defines:
      - ADR-PWSH-ENV#{1-11}
    adrs:
      - ADR-AUTO-ENVVAR#*
      - ADR-AUTO-NOPWD#6
      - ADR-FLOW-CD-DETECT#1
    links:
      - docs/adr/automation/caching.md
      - docs/adr/automation/cross-platform.md
      - docs/adr/automation/environment-variables.md
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar2
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar3
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar4
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar5
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar6
      - docs/adr/automation/environment-variables.md#rule-adr-auto-envvar7
      - docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6
      - docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1
      - docs/adr/pwsh/prefer-foreach-over-foreach-object.md
      - docs/adr/pwsh/script-scope-caching.md
      - docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4
---

# ADR: Environment-variable mechanics — the PowerShell layer over environment-variables

## Rules: ADR-PWSH-ENV

### Rule ADR-PWSH-ENV:1

PowerShell code applies the boundary doctrine of [environment-variables](../automation/environment-variables.md) (`ADR-AUTO-ENVVAR`) with
the language mechanics below: `$env:` is the boundary-only channel, and everything internal flows through PowerShell's own scoping.

- [The internal-state mechanisms](#the-internal-state-mechanisms)

### Rule ADR-PWSH-ENV:2

Internal state uses the language's scoped mechanisms — function parameters, return values, `$local:` locals, and module-scoped `$script:`
state — never `$env:`. Each is destroyed or scoped automatically; `$env:` persists for the process lifetime with no scoped cleanup.

- [The internal-state mechanisms](#the-internal-state-mechanisms)

### Rule ADR-PWSH-ENV:3

Runspaces share one process environment block. Never read or write `$env:` inside `ForEach-Object -Parallel` or a runspace worker to
coordinate work — concurrent access races. Pass values in with `$using:` and aggregate through pipeline output or a thread-safe collection.

- [One environment block](#one-environment-block)

### Rule ADR-PWSH-ENV:4

Pester provides no `$env:` isolation. A test that must set an environment variable snapshots and restores it (`try`/`finally`, or
`BeforeAll`/`AfterAll`), and never leaves a value behind for the next test — leaked `$env:` state creates order-dependent failures.

- [No test isolation](#no-test-isolation)

### Rule ADR-PWSH-ENV:5

A `$env:` assignment in our code sets an external tool's contract variable — `$env:GIT_TERMINAL_PROMPT = '0'`,
`$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'`, `$env:PSModulePath` — and nothing else
([ADR-AUTO-ENVVAR#1](../automation/environment-variables.md#rule-adr-auto-envvar1)). A value our own code consumes is a parameter, a return
value, or `$script:` state (ADR-PWSH-ENV#2).

- [Setting a contract variable](#setting-a-contract-variable)

### Rule ADR-PWSH-ENV:6

A `$env:` read is an input from outside the boundary ([ADR-AUTO-ENVVAR#2](../automation/environment-variables.md#rule-adr-auto-envvar2)): a
tool's contract variable (`$env:JAVA_HOME`, `$env:DOTNET_ROOT`), an OS location (`$env:SystemRoot`), or one of the `$env:CATZC_*` toggles a
developer's shell or a test harness sets, which module code reads and never writes. Whether the code runs in a pipeline is never such a
read: it goes through the detection function, `Test-IsRunningInPipeline`.

- [Reading an external input](#reading-an-external-input)

### Rule ADR-PWSH-ENV:7

A required input is a `[Parameter(Mandatory)]` parameter, typed and validated (`[ValidateSet()]`, `[ValidateRange()]`), never a guard that
throws when a `$env:` variable is unset ([ADR-AUTO-ENVVAR#3](../automation/environment-variables.md#rule-adr-auto-envvar3)).

- [A parameter, not a variable](#a-parameter-not-a-variable)

### Rule ADR-PWSH-ENV:8

No function of ours assigns `$env:` for a later function of ours to read, as a hand-off, a cache, or a flag
([ADR-AUTO-ENVVAR#4](../automation/environment-variables.md#rule-adr-auto-envvar4)). The value is returned and passed on as a parameter, and
a cache lives in `$script:` state ([script-scope-caching](script-scope-caching.md)).

- [No hand-off through the environment](#no-hand-off-through-the-environment)

### Rule ADR-PWSH-ENV:9

The bootstrap anchors of [ADR-AUTO-ENVVAR#5](../automation/environment-variables.md#rule-adr-auto-envvar5) are `$env:RepositoryRoot` (the
working root) and `$env:CatzcModulesRoot` (the code root). The importer entry sets them once — `importer.ps1` in source mode, the build's
`Import-Catzc.ps1` in build mode — and only a function whose job is the variable itself reassigns one, restoring it before it returns
(`Test-InIsolation`). Module code reads the working root through `Get-RepositoryRoot`
([ADR-AUTO-NOPWD#6](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6)).

- [The bootstrap anchors](#the-bootstrap-anchors)

### Rule ADR-PWSH-ENV:10

A secret is never assigned to `$env:` as internal state — no `$env:TOKEN = $plaintext`
([ADR-AUTO-ENVVAR#6](../automation/environment-variables.md#rule-adr-auto-envvar6)). Inside our code a secret travels as a `[SecureString]`
parameter.

- [The secret hand-off](#the-secret-hand-off)

### Rule ADR-PWSH-ENV:11

`Write-EnvironmentSet` realises the one secret hand-off of
[ADR-AUTO-ENVVAR#7](../automation/environment-variables.md#rule-adr-auto-envvar7): it takes the secret as `[SecureString]`, masks it as
`***` in everything it writes or returns, decrypts it with `[System.Net.NetworkCredential]::new('', $secure).Password` only at the `$env:`
assignment, and by default snapshots the variable, sets it, invokes its `-ScriptBlock`, and restores it in a `finally`; it persists the
value past the call only on `-Persist`.

- [The secret hand-off](#the-secret-hand-off)

## Context

[environment-variables](../automation/environment-variables.md) fixes the doctrine: environment variables are for external boundaries, never
internal state. This ADR is the PowerShell layer under it — the concrete mechanics of obeying that doctrine in this codebase's language.

PowerShell makes `$env:` variables dangerously convenient. They look like regular variables, they are accessible everywhere, and they
survive function calls — which makes them tempting for passing state between functions, caching results, or storing configuration. The
language also supplies exactly the scoped alternatives the doctrine demands: `$local:`, `$script:`, module scope, function parameters, and
return values, all destroyed or scoped automatically. `$env:FOO` set inside any function, at any call depth, persists for the entire process
lifetime unless someone explicitly removes it; there is no `try`/`finally` equivalent that cleans up environment variables when a scope
exits.

`$env:` values are always strings: `$env:COUNT = 42` stores the string `"42"`, and `$env:ENABLED = $true` stores the string `"True"`. Every
process started with `Start-Process`, `Start-Job`, `&`, or `Invoke-Executable` inherits every `$env:` variable the session holds. And
`$env:Path` and `$env:PATH` name the same variable on Windows but two different variables on Linux.

### The internal-state mechanisms

| Mechanism            | Scope   | Cleanup        | Type-safe    | Testable                  |
| -------------------- | ------- | -------------- | ------------ | ------------------------- |
| Function parameters  | Call    | Automatic      | Yes          | Trivially                 |
| Return values        | Call    | Automatic      | Yes          | Trivially                 |
| `$script:` variables | Module  | Module unload  | Yes          | Mockable                  |
| `$env:` variables    | Process | Never (manual) | No (strings) | Requires snapshot/restore |

To pass a value between functions, pass it as a parameter. To share state within a module, use `$script:`. To cache a result, use a
module-scoped variable (see [caching](../automation/caching.md)). None of these leak to child processes, pollute tests, or persist beyond
their natural lifetime — and unlike `$env:` (always strings), each carries the type system: `[int]`, `[switch]`, `[ValidateRange()]` catch
errors at the call site.

### Setting a contract variable

External tools define their configuration contract through environment variables, and our code sets those so the tool behaves correctly:

```powershell
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'     # dotnet CLI reads this
$env:GIT_TERMINAL_PROMPT = '0'             # git reads this
$env:AZURE_CONFIG_DIR = $configPath         # Azure CLI reads this
$env:PSModulePath = $vendorPaths            # PowerShell reads this
```

The consumer of each variable is an external process, not our code.

### Reading an external input

External tools, container runtimes, and operating systems communicate through environment variables, and reading them is reading an input
from outside the boundary:

```powershell
$env:JAVA_HOME         # set by a JDK install — where is java?
$env:DOTNET_ROOT       # set by a .NET install — where is dotnet?
$env:SystemRoot        # set by Windows — where is the OS?
```

The variables a CI platform sets to say "this is a pipeline run" are not read this way. They are read in one place,
`Test-IsRunningInPipeline`, and every other caller asks that function
([ADR-FLOW-CD-DETECT#1](../flow/pipeline-detection.md#rule-adr-flow-cd-detect1)).

The `$env:CATZC_*` flags are the same kind of input: deliberate external or diagnostic toggles that the outer environment sets and our code
reads to alter a presentation or test-isolation behaviour.

```powershell
$env:CATZC_MESSAGE_TIMESTAMPS   # opt-in: prefix Write-Message output with timestamps
$env:CATZC_BLOCK_REAL_PROCESS   # set by the L1 test harness: a real process launch means a mock was missed
```

### A parameter, not a variable

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

The parameter gives type validation, tab completion, mandatory enforcement, and documentation for free. The `$env:` guard gives a
stringly-typed global that the caller has to know about by reading the implementation.

### No hand-off through the environment

```powershell
# BAD — passing state through the environment
function Install-Tool {
    # ...install logic...
    $env:LAST_INSTALLED_TOOL = $toolName      # leaks to every child process
}
function Show-Summary {
    Write-Message "Installed: $env:LAST_INSTALLED_TOOL"  # invisible coupling
}

# GOOD — pass it as a return value or parameter
function Install-Tool {
    # ...install logic...
    return $toolName
}
$installed = Install-Tool -Name 'python'
Show-Summary -ToolName $installed
```

A cache or a "loaded" flag is the same hand-off in another shape:

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

The strict-clean form of that probe is [script-scope-caching](script-scope-caching.md#rule-adr-pwsh-cache4).

### The bootstrap anchors

`importer.ps1` is dot-sourced, so the `$env:RepositoryRoot` it sets lands in the caller's session and stays there for every function called
afterwards; the build's `Import-Catzc.ps1` sets the same anchors for an installed bundle. `$env:` is the one mechanism that crosses module
boundaries without a parameter threaded through every call, which is why the anchors use it and nothing else does. Module code still never
reads `$env:RepositoryRoot` directly: `Get-RepositoryRoot` is the one reader, so a change to where the root comes from lands in one place.

### The secret hand-off

`Write-EnvironmentSet` (`Catzc.Tooling.Environment`) is the sole sanctioned way to place a secret in the environment for a child or external
process. It:

- takes secrets as `[SecureString]`, so a plaintext token is never a parameter value sitting in a caller's variables or a transcript;
- never logs or returns the plaintext — it masks the value as `***`, the same discipline as `Set-AdoPipelineVariable -IsSecret`;
- decrypts to plaintext only at the `$env:` assignment itself (the boundary), via
  `[System.Net.NetworkCredential]::new('', $secure).Password`;
- defaults to a **scoped** set/restore — it snapshots, sets, invokes a `-ScriptBlock`, and restores in a `finally`, so the secret leaves the
  environment when the block exits — and persists past the call only on an explicit `-Persist`.

`SecureString` is DPAPI-encrypted only on Windows; on Linux and macOS .NET stores it obfuscated rather than encrypted (see
[cross-platform](../automation/cross-platform.md)). The value of the type here is the **contract** — do not log, do not internalize, decrypt
only at the boundary — not at-rest cryptography.

### One environment block

`Runspaces share one environment block`

All runspaces in a `ForEach-Object -Parallel` block share the same process environment block. Environment variables are not isolated per
runspace — they are process-wide. Concurrent reads and writes to the same `$env:` variable from different runspaces produce race conditions.
Unlike `$using:` variables (which are copied per-runspace), `$env:` is a single shared namespace — so a parallel block that needs an outer
value takes it through `$using:`, and one that produces results emits them through the pipeline or a thread-safe collection (see
[prefer-foreach-over-foreach-object](prefer-foreach-over-foreach-object.md) for the wider `-Parallel` rules).

### No test isolation

`Tests get no environment isolation`

Environment variables set in one test leak into subsequent tests. If Test A sets `$env:MODE = 'test'` and forgets to clean up, Test B runs
with an unexpected `$env:MODE` — an order-dependent failure that is extremely difficult to diagnose. Pester provides `TestDrive:` for file
isolation and scoped cleanup for PowerShell variables, but it provides **no automatic isolation for environment variables**: a test that
must touch `$env:` snapshots the value and restores it in a `finally` (or `AfterAll`), every time. That ceremony is itself the argument for
function parameters over `$env:` — proper parameters need none of it.

## Decision

PowerShell code keeps internal state in the language's scoped mechanisms (parameters, return values, `$local:`, `$script:`), writes `$env:`
only for an external tool's contract and reads it only as an external input, declares required inputs as mandatory parameters, leaves the
bootstrap anchors to the importer entry, hands a secret to a child process only through `Write-EnvironmentSet`, treats `$env:` in parallel
runspaces as a shared, race-prone namespace never used for coordination, and snapshots/restores any `$env:` value a test must touch.

### How this is enforced

- **The doctrine layer** — which environment-variable uses are legitimate at all is
  [environment-variables](../automation/environment-variables.md) (`ADR-AUTO-ENVVAR`); this ADR only fixes the language mechanics.
- **Custom PSScriptAnalyzer rule `Measure-NoEnvRepositoryRoot`** — flags a `$env:RepositoryRoot` read in a module function file
  (ADR-PWSH-ENV#9, through [ADR-AUTO-NOPWD#6](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6)).
- **Code review** — a `$env:` read or write that is not an external-boundary use per `ADR-AUTO-ENVVAR`, a `-Parallel` block touching
  `$env:`, a secret assigned to `$env:` outside `Write-EnvironmentSet`, or a test that sets `$env:` without restoring it is rejected against
  this ADR.

## Consequences

- Internal state flows through contracts the engine cleans up automatically — no manual environment hygiene, no leakage between functions,
  child processes, runspaces, or tests.
- Parallel code stays race-free by construction: `$using:` copies values per runspace, and results travel through the pipeline.
- Tests stay order-independent: the few that legitimately touch `$env:` (external toggles like `$env:CATZC_*`) restore what they change.
- A secret bound into `$env:` for a child process passes through one function a reviewer can audit.
- The cost is remembering four mechanisms instead of one global bag — which is the point: each mechanism carries its scope in its name.
