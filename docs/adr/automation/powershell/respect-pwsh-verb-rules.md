# ADR: Respect PowerShell approved verbs

## Rules: ADR-VERBS

### Rule ADR-VERBS:1

Use only verbs from `Get-Verb`. If the verb you want is not in the list, find the approved verb that matches the semantics (e.g. `New-` not
`Create-`).

- [Common mistakes](#common-mistakes)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-VERBS:2

Respect the semantic contract: a `Get-` function must not modify state, a `Test-` function must return `[bool]`, an `Assert-` function must
throw on failure. The verb is a promise to the caller.

- [Why this matters](#why-this-matters)

### Rule ADR-VERBS:3

Use `Test-` for boolean queries and `Assert-` for preconditions. `Test-` returns true/false for the caller to decide; `Assert-` throws
immediately. Never name a function `Test-` and throw, or `Assert-` and return false. (The repository quality gates are the one sanctioned
exception — see ADR-VERBS:7.)

- [Why this matters](#why-this-matters)

### Rule ADR-VERBS:4

Use `Invoke-` for transparent command wrappers (`Invoke-Python`, `Invoke-Poetry`): they run the underlying tool without deciding what to run
or interpreting output. The caller controls the command.

- [Why this matters](#why-this-matters)

### Rule ADR-VERBS:5

Use `ConvertTo-`/`ConvertFrom-` for format transformations — not `Parse-`, `Serialize-`, `Transform-`, or `Format-` (which means "arranges
for display").

- [Common mistakes](#common-mistakes)

### Rule ADR-VERBS:6

Use a **plural** noun for a function that returns a collection (`Get-AdoYamlFiles`, `Get-BicepTemplates`) and a singular noun for one that
returns exactly one object (`Get-BicepTemplate`), so the cardinality is visible from the name.

- [Cardinality: plural nouns for collections](#cardinality-plural-nouns-for-collections)

### Rule ADR-VERBS:7

The repository quality gates — `Test-Automation` and the `Test-*` gates it aggregates (`Test-Spelling`, `Test-ScriptAnalyzer`,
`Test-Markdownlint`, `Test-Types`) — are the sanctioned exception to ADR-VERBS:2/ADR-VERBS:3: each throws on failure so it can fail the
build, and returns a result object under `-PassThru`. Their noun names a body of work to verify and enforce, not a boolean condition; a
plain predicate (`Test-Path`, `Test-Command`) still returns `[bool]` and never throws.

- [The sanctioned quality-gate exception](#the-sanctioned-quality-gate-exception)

## Context

PowerShell has a curated list of approved verbs (`Get-Verb`), organized into groups (Common, Communications, Data, Diagnostic, Lifecycle,
Security) with precise definitions for each. This is not a suggestion — it is a deliberate design decision by the PowerShell team, and it is
one of the language's true strengths.

### Why this matters

**Verbs are a shared vocabulary.** When a user sees `Get-`, they know it reads without modifying. When they see `Set-`, they know it writes.
When they see `Test-`, they know it returns a boolean. When they see `Assert-`, they know it throws on failure. This contract is universal
across every PowerShell module, every vendor, every team. A user who has never seen your code can predict what `Get-Config` does from the
verb alone.

**Verbs encode behavior guarantees.** The approved verbs are not just naming conventions — they carry semantic promises:

| Verb                                       | Guarantee                                          | Will not                   |
| ------------------------------------------ | -------------------------------------------------- | -------------------------- |
| `Get-`                                     | Safe to call, read-only                            | Change state               |
| `Test-`                                    | Returns `[bool]`                                   | Throw on the negative case |
| `Assert-`                                  | Throws on failure                                  | Return false               |
| `New-`                                     | Creates a resource                                 | Update existing resources  |
| `Set-`                                     | Replaces data on existing, or creates if missing   |                            |
| `Remove-`                                  | Deletes a resource                                 | Archive or soft-delete     |
| `Install-`                                 | Places a resource and initializes it               |                            |
| `Invoke-`                                  | Runs a command or method, transparent pass-through |                            |
| `Update-`                                  | Brings an existing resource up-to-date             | Create new resources       |
| `Build-`                                   | Creates an artifact from input files               |                            |
| `Convert-` / `ConvertTo-` / `ConvertFrom-` | Transforms data between representations            |                            |

**`New-` not `Create-`.** `Create` is not an approved verb. Use `New-` for all resource creation. This is the single most common mistake.

When every function in the codebase respects these guarantees, a user can reason about behavior from the function name without reading the
implementation. This is an extraordinary advantage that most languages do not offer.

**Discovery works.** `Get-Command -Verb Install` shows every install function. `Get-Command -Noun Poetry` shows every poetry function. This
only works when verbs are consistent. A function named `Setup-Poetry` would not appear in either search.

**Tab completion works.** Users type `Get-` and tab through all getters. They type `Install-` and see all installable tools. Non-standard
verbs break this workflow and hide functions from discovery.

### The approved verb groups

#### Common

| Verb     | Meaning                                                          |
| -------- | ---------------------------------------------------------------- |
| `Add`    | Adds a resource to a container                                   |
| `Clear`  | Removes contents from a container without deleting the container |
| `Close`  | Makes a resource inaccessible or unusable                        |
| `Copy`   | Copies a resource to another name or container                   |
| `Get`    | Retrieves a resource (read-only, no side effects)                |
| `Move`   | Moves a resource from one location to another                    |
| `New`    | Creates a resource                                               |
| `Open`   | Makes a resource accessible or usable                            |
| `Remove` | Deletes a resource from a container                              |
| `Rename` | Changes the name of a resource                                   |
| `Reset`  | Sets a resource back to its original state                       |
| `Search` | Creates a reference to a resource in a container                 |
| `Select` | Locates a resource in a container                                |
| `Set`    | Replaces data on an existing resource                            |
| `Show`   | Makes a resource visible to the user                             |

#### Data

| Verb          | Meaning                                                 |
| ------------- | ------------------------------------------------------- |
| `Compare`     | Evaluates data from one resource against another        |
| `Convert`     | Changes data bidirectionally between representations    |
| `ConvertFrom` | Converts from a specific format to general objects      |
| `ConvertTo`   | Converts from general objects to a specific format      |
| `Export`      | Encapsulates input into a persistent store (file, etc.) |
| `Import`      | Creates a resource from data in a persistent store      |
| `Merge`       | Creates a single resource from multiple resources       |
| `Publish`     | Makes a resource available to others                    |
| `Save`        | Preserves data to avoid loss                            |
| `Update`      | Brings a resource up-to-date                            |

#### Lifecycle

| Verb        | Meaning                                             |
| ----------- | --------------------------------------------------- |
| `Assert`    | Affirms the state of a resource (throws on failure) |
| `Build`     | Creates an artifact from input files                |
| `Deploy`    | Sends a solution to a remote target for consumption |
| `Disable`   | Configures a resource to an inactive state          |
| `Enable`    | Configures a resource to an active state            |
| `Install`   | Places a resource in a location and initializes it  |
| `Invoke`    | Performs an action such as running a command        |
| `Start`     | Initiates an operation                              |
| `Stop`      | Discontinues an activity                            |
| `Uninstall` | Removes a resource from a location                  |

#### Diagnostic

| Verb      | Meaning                                                            |
| --------- | ------------------------------------------------------------------ |
| `Debug`   | Examines a resource to diagnose problems                           |
| `Measure` | Identifies resources consumed by an operation                      |
| `Test`    | Verifies the operation or consistency of a resource (returns bool) |
| `Trace`   | Tracks activities of a resource                                    |

#### Communications

| Verb      | Meaning                               |
| --------- | ------------------------------------- |
| `Read`    | Acquires information from a source    |
| `Write`   | Adds information to a target          |
| `Send`    | Delivers information to a destination |
| `Receive` | Accepts information from a source     |

#### Security

| Verb        | Meaning                                   |
| ----------- | ----------------------------------------- |
| `Block`     | Restricts access to a resource            |
| `Grant`     | Allows access to a resource               |
| `Protect`   | Safeguards a resource from attack or loss |
| `Revoke`    | Removes access to a resource              |
| `Unblock`   | Removes restrictions to a resource        |
| `Unprotect` | Removes safeguards from a resource        |

### Common mistakes

| Wrong                  | Right                              | Why                                                                     |
| ---------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| `Setup-Tools`          | `Install-DevBoxTools`              | `Setup` is not an approved verb; `Install` means "place and initialize" |
| `Create-ResourceGroup` | `New-ResourceGroup`                | `Create` is not approved; `New` means "creates a resource"              |
| `Delete-Config`        | `Remove-Config`                    | `Delete` is not approved; `Remove` means "deletes from a container"     |
| `Run-Pipeline`         | `Invoke-Pipeline`                  | `Run` is not approved; `Invoke` means "performs an action"              |
| `Check-Version`        | `Test-Version` or `Assert-Version` | `Check` is not approved; `Test` returns bool, `Assert` throws           |
| `Load-Module`          | `Import-Module`                    | `Load` is not approved; `Import` means "creates from persistent store"  |
| `Parse-Yaml`           | `ConvertFrom-Yaml`                 | `Parse` is not approved; `ConvertFrom` means "converts from format X"   |
| `Validate-Config`      | `Assert-Config` or `Test-Config`   | `Validate` is not approved; use `Assert` (throws) or `Test` (bool)      |
| `Fetch-Data`           | `Get-Data`                         | `Fetch` is not approved; `Get` means "retrieves a resource"             |
| `Execute-Command`      | `Invoke-Command`                   | `Execute` is not approved; `Invoke` means "performs an action"          |

### Cardinality: plural nouns for collections

The verb carries the action; the **noun carries the cardinality**. A function that returns a set or list takes a plural noun, and one that
returns a single object takes the singular — so a caller knows from the name alone whether to expect a collection:

- `Get-BicepTemplates`, `Get-AdoYamlFiles` — return collections.
- `Get-BicepTemplate`, `Get-Config` — return one object.

This is a deliberate clarity choice over PowerShell's default lean toward singular nouns; the number of the noun is part of the contract.

### The sanctioned quality-gate exception

Most `Test-` functions are predicates — `Test-Path`, `Test-Command`, `Test-IsRunningInPipeline` — and obey ADR-VERBS:2: they answer a
boolean and never throw. The repository's quality gates are different in kind. `Test-Automation`, `Test-Spelling`, `Test-ScriptAnalyzer`,
`Test-Markdownlint`, and `Test-Types` each run a body of checks and exist to **fail the build** when those checks fail — throwing is their
job, not a broken contract. They still expose the boolean-shaped answer through `-PassThru`, which returns a result object (issue counts,
report path) for a caller that wants to branch rather than break. The distinction is in the noun: `Test-Path` names a condition to evaluate;
`Test-Spelling` names a corpus to verify and a gate to enforce. Naming these `Assert-` would be defensible, but `Test-<Area>` reads as the
CI gate it is and keeps the gate family under one discoverable verb. This is the one place `Test-`-and-throw is correct; a genuine predicate
that throws is still a bug.

## Decision

All functions must use approved PowerShell verbs. No exceptions.

### How this is enforced

- **PSScriptAnalyzer rule `PSUseApprovedVerbs`** (built-in, enabled) — warns on any function that uses a verb not in the `Get-Verb` list.
  Runs as part of the L2 test suite via `Test-ScriptAnalyzer.Tests.ps1`.

## Consequences

- Every function is discoverable via `Get-Command -Verb` and `Get-Command -Noun`.
- Users can predict function behavior from the name without reading code.
- Code reads as natural language: `Assert-Command python`, `Install-Poetry`, `Get-Config azure`, `Test-IsAdministrator`.
- PSScriptAnalyzer warns on unapproved verbs, catching mistakes before code review.
- New team members familiar with any PowerShell module can immediately navigate the codebase because the vocabulary is shared.

## Dora explains:

DORA research shows that consistent naming conventions improve code maintainability and enable teams to understand unfamiliar code by name
alone. Using PowerShell's approved verbs as the shared vocabulary transforms function names into behavioral contracts every team member
recognizes.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — consistent verbs reduce cognitive load, enable behavior
  prediction.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — verbs encode contracts that document behavior in names.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — shared verbs enable independent navigation of unfamiliar
  code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
