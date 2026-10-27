# ADR: Single-responsibility functions

## Rules: ADR-AUTO-ONEJOB

### Rule ADR-AUTO-ONEJOB-ASSERTDONTFIX

Assert, don't fix. If a function needs a prerequisite, assert it with `Assert-Tool` (or `Assert-Command`); never silently install,
configure, or repair prerequisites. Assertions are guard clauses, part of the contract.

- [Violations](#violations)

### Rule ADR-AUTO-ONEJOB-NAMEISCONTRACT

The function name is the contract. `Get-Config` must not modify state; `Invoke-Poetry` must not install Poetry. If the name does not cover
what the function does, rename it or remove the behavior.

- [Composition vs mixing](#composition-vs-mixing)

### Rule ADR-AUTO-ONEJOB-EXPLICITORCHESTRATION

Orchestration functions are explicit: higher-level functions that chain a sequence are fine when the name and purpose make the composition
obvious (`Install-DevBoxTools`, `Publish-Module`).

- [Composition vs mixing](#composition-vs-mixing)

### Rule ADR-AUTO-ONEJOB-NOHIDDENBUNDLING

Hidden bundling is the anti-pattern — not composition itself, but composition that surprises the caller. If the caller must read the
implementation to learn what the function does, it is doing too much for its name.

- [Composition vs mixing](#composition-vs-mixing)

### Rule ADR-AUTO-ONEJOB-CALLERHANDLESERRORS

Error handling is the caller's job. Functions throw on failure; whether to retry, log, or continue is the caller's decision. Functions do
not catch-and-retry/log/continue unless error handling is their single stated purpose.

- [Violations](#violations)

### Rule ADR-AUTO-ONEJOB-EXPLICITSTATECHANGES

State changes are explicit. Functions do not mutate ambient global state — error preferences, the working directory, environment variables —
as a side effect; a temporary change is restored before the function returns, on the failure path as well as the success path.

- [Why it matters in a scripting engine](#why-it-matters-in-a-scripting-engine)
- [Violations](#violations)

## Context

Scripting engines make it easy to write functions that do too much. They encourage long pipelines, implicit state, and "helpful" side
effects. A function starts as a simple wrapper and gradually accumulates setup, validation, logging, retries, and cleanup — all in one body.
This is the root cause of most automation bugs.

The Single Responsibility Principle (the S in SOLID) states that a function should have one reason to change. In automation code, the
practical test is: **everything in the function must serve a single cohesive outcome.** Assertions verify preconditions for that outcome.
Sub-steps produce intermediate results that feed the next step. If you could remove a sub-step and the remaining steps would still produce a
valid (just different) result, that sub-step is an independent concern and belongs in a separate function.

This matters more in an interpreted engine than in a compiled language because there is no compiler to catch the breakage — you find out at
runtime, often in production.

### Why it matters in a scripting engine

`Why this is critical for an interpreted engine specifically`

**No compile-time safety.** A compiled method that calls a renamed function fails at compile time. An interpreted function that calls a
renamed function fails when that line executes — which may be a rare branch that CI never hits. The more a function does, the more surface
area for these latent failures.

**Implicit state is everywhere.** The engine's error preference, the last exit code, the current directory, environment variables and
module-level variables are all mutable global state that any function can read or modify. A function that touches multiple concerns
interacts with more state, and interactions between implicit state variables are the hardest bugs to diagnose.

**Testing multiplies combinatorially.** A function that does A then B then C needs tests for A×B×C combinations, including partial failures
at each step. Three single-responsibility functions need A + B + C tests. The compound function is also harder to mock because it tangles
external dependencies together.

**Error messages become useless.** When `Deploy-Application` fails because `winget` returned a non-zero exit code, the user has to read the
stack trace to discover that `Deploy-Application` tried to install Python, which tried to call `winget`, which could not find the package.
If the function only deployed, the failure would point directly at the deployment, and the missing Python would have been caught by an
`Assert-Command` at the top.

**Reuse becomes impossible.** A function that installs-then-configures cannot be called when the tool is already installed. A function that
validates-then-deploys cannot be called when you need to deploy without validation (emergency hotfix). The caller ends up duplicating the
part they need because they cannot use the function without the part they do not want.

### Violations

`Patterns that violate single responsibility`

- **`Invoke-Foo` installs Foo if missing**: a side effect the caller did not ask for. Fix: `Assert-Command Foo` at the top; a separate
  `Install-Foo`.
- **The function changes the current directory to do its work**: it leaks state to the caller. Fix: restore it in a `finally`, or use
  absolute paths.
- **The function sets the engine's error preference globally**: it changes error handling for everything downstream. Fix: set it on the
  individual calls, or scope it with a `try`/`catch`.
- **The function validates input, transforms it, and writes output**: three reasons to change. Fix: separate `Assert-*`, `ConvertTo-*`, and
  `Write-*` functions.
- **The function retries on failure with backoff**: retry logic tangles with business logic. Fix: a separate `Invoke-WithRetry` that takes
  the operation as an argument.
- **The function creates a resource, then configures it**: a partial failure leaves an orphaned resource. Fix: separate `New-*` and `Set-*`;
  the caller composes them.
- **The function logs before and after its work**: logging concerns change independently. Fix: use the engine's verbose and debug streams,
  or wrap at the call site.

The engine twin gives the forms of a temporary state change and of a retry wrapper.

### Composition vs mixing

`Composition is not the same as mixing concerns`

Higher-level functions that call lower-level functions are fine — that is normal composition. The problem is when a function bundles
sub-steps that produce independently valid results. The test: **if you removed a sub-step, would the remaining steps still produce a
coherent (just smaller) outcome?** If yes, that sub-step is an independent concern.

Assertions and precondition checks are never independent concerns — remove an `Assert-Command` and the function becomes incorrect, not
different. They are part of the function's contract. But two operations that each leave the system in a valid state on their own (creating a
resource, writing a file) are independent even if they happen to run in sequence. The examples are pseudo-code:

```text
# FINE — one responsibility: "run poetry safely"
# The assertions are guard clauses for the core action, not separate concerns.
# You would never want to run poetry without checking it exists first.
function Invoke-Poetry(arguments):
    Assert-Command("poetry")
    Assert-ToolVersion("Poetry")
    Invoke-Executable("poetry " + arguments)
```

```text
# BAD — two responsibilities: "make sure poetry exists" AND "run poetry"
# The caller asked to run a command, not install software.
# In CI, poetry is pre-installed — this silently wastes time or breaks on permissions.
function Invoke-Poetry(arguments):
    if not Test-Command("poetry"):
        Install-Poetry()                        # side effect the caller did not ask for
    Invoke-Executable("poetry " + arguments)
```

```text
# BAD — "create infrastructure" and "write local config" tangled together
function Initialize-Environment(resource_group, location, path, json):
    New-ResourceGroup(resource_group, location)
    write_file(path + "/config.json", json)
# What happens when the file write fails?
# The resource group exists, but the function threw, so the caller thinks
# nothing happened. Re-running creates a duplicate error or silently
# overwrites. The caller cannot create the resource group without also
# writing a file, and cannot write the file without also creating a
# resource group.

# GOOD — two functions, caller composes
New-ResourceGroup(resource_group, location)
write_file(path + "/config.json", json)
# Now if the file write fails, the caller knows the resource group
# succeeded and can decide what to do. They can also call either
# step alone — in CI the resource group already exists, so the
# script only writes the config file.
```

```text
# FINE — higher-level function with one cohesive goal
# "Publish a module" is one thing, even though it involves multiple steps.
# You would never want to pack without testing, or push without packing.
function Publish-Module(module_path, repository):
    artifact = Build-ModulePackage(module_path)
    Test-ModulePackage(artifact)
    Push-ModulePackage(artifact, repository)
```

The last example is key: composition into higher-level operations is expected and encouraged. Remove the build step and there is nothing to
test. Remove the test step and you publish an unverified artifact — the outcome is incomplete, not just different. Each step depends on the
previous one; none produces an independently valid result. That is one cohesive outcome, not three concerns bundled together.

## Decision

Every function must have one _reason to change_. Functions that compose steps toward a single goal are fine — including orchestration
functions whose stated purpose is to chain a known sequence (like `Install-DevBoxTools` calling `Install-Python`, `Install-Poetry`,
`Install-Dotnet`). The responsibility there IS the orchestration: "make the workstation ready."

The problem is when a function does things the caller did not ask for and cannot opt out of. `Invoke-Poetry` that secretly installs Poetry
is not an orchestration function — it is a command runner with a hidden side effect. The function's name and purpose is "run poetry," but it
silently does something else too.

### How this is enforced

- **Custom analyzer rule `Measure-FunctionLength`** (`pwsh/.scriptanalyzer/FunctionLength.psm1`) — warns when a function body exceeds 300
  lines. A function that long is almost certainly doing too much. The limit counts the body only (opening brace to closing brace) —
  comment-based help placed before the function is not counted.

## Consequences

- Functions are small, testable, and composable.
- Failures produce clear, actionable error messages that point at the actual problem.
- Callers have full control over workflow, retries, and error handling.
- Code review is easier because each function has one thing to evaluate.
- Scripts read as a sequence of named steps, not as nested abstractions that hide behavior.
