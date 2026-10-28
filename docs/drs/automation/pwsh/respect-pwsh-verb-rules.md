# PowerShell: Respect PowerShell approved verbs

## Rules: ADR-PWSH-VERBS

### Rule ADR-PWSH-VERBS-APPROVEDVERBS

Use only verbs from `Get-Verb`. A verb not in the list gives way to the approved verb that matches its semantics (`New-`, not `Create-`).

- [Common mistakes](#common-mistakes)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-VERBS-SEMANTICCONTRACT

Respect the semantic contract: a `Get-` function must not modify state, a `Test-` function must return `[bool]`, an `Assert-` function must
throw on failure. The verb is a promise to the caller.

- [Why this matters](#why-this-matters)

### Rule ADR-PWSH-VERBS-TESTANDASSERT

Use `Test-` for boolean queries and `Assert-` for preconditions. `Test-` returns true/false for the caller to decide; `Assert-` throws
immediately. Never name a function `Test-` and throw, or `Assert-` and return false. (The repository quality gates are the one sanctioned
exception — see ADR-PWSH-VERBS-GATESARETEST.)

- [Why this matters](#why-this-matters)

### Rule ADR-PWSH-VERBS-INVOKEWRAPPERS

Use `Invoke-` for transparent command wrappers (`Invoke-Python`, `Invoke-Poetry`): they run the underlying tool without deciding what to run
or interpreting output. The caller controls the command.

- [Why this matters](#why-this-matters)

### Rule ADR-PWSH-VERBS-CONVERTVERBS

Use `ConvertTo-`/`ConvertFrom-` for format transformations — not `Parse-`, `Serialize-`, `Transform-`, or `Format-` (which means "arranges
for display").

- [Common mistakes](#common-mistakes)

### Rule ADR-PWSH-VERBS-PLURALCOLLECTIONNOUNS

Use a **plural** noun for a function that returns a collection (`Get-AdoYamlFiles`, `Get-BicepTemplates`) and a singular noun for one that
returns exactly one object (`Get-BicepTemplate`), so the cardinality is visible from the name.

- [Plural nouns](#plural-nouns)

### Rule ADR-PWSH-VERBS-GATESARETEST

The repository quality gates — `Test-Automation` and the `Test-*` gates it aggregates (`Test-Spelling`, `Test-ScriptAnalyzer`,
`Test-Markdownlint`, `Test-Formatting`) — are the sanctioned exception to ADR-PWSH-VERBS-SEMANTICCONTRACT/ADR-PWSH-VERBS-TESTANDASSERT: each
throws on failure so it can fail the build, and returns a result object under `-PassThru`. Their noun names a body of work to verify and
enforce, not a boolean condition; a plain predicate (`Test-Path`, `Test-Command`) returns `[bool]` and never throws.

- [The quality-gate exception](#the-quality-gate-exception)

## Context

PowerShell has a curated list of approved verbs (`Get-Verb`), organized into groups (Common, Communications, Data, Diagnostic, Lifecycle,
Security) with precise definitions for each; it is a deliberate design decision of the language, and one of its strengths.

### Why this matters

**Verbs are a shared vocabulary.** When a user sees `Get-`, they know it reads without modifying. When they see `Set-`, they know it writes.
When they see `Test-`, they know it either answers a value or state question with a boolean, or is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../test-automation.md#rule-adr-auto-test-qualitygate), ADR-PWSH-VERBS-GATESARETEST) that reports every issue
and throws. When they see `Assert-`, they know it throws on failure. The contract is universal across every PowerShell module, so a user who
has never seen the code predicts what `Get-Config` does from the verb alone.

**Verbs encode behavior guarantees:**

- **`Get-`**
  - Guarantee: Safe to call, read-only
  - Will not: Change state
- **`Test-`**
  - Guarantee: Returns `[bool]` — or, as a quality gate (`ADR-AUTO-TEST-QUALITYGATE`), reports every issue and throws once
  - Will not: Throw on the negative case (a value/state test)
- **`Assert-`**
  - Guarantee: Throws on failure
  - Will not: Return false
- **`New-`**
  - Guarantee: Creates a resource
  - Will not: Update existing resources
- **`Set-`**
  - Guarantee: Replaces data on existing, or creates if missing
- **`Remove-`**
  - Guarantee: Deletes a resource
  - Will not: Archive or soft-delete
- **`Install-`**
  - Guarantee: Places a resource and initializes it
- **`Invoke-`**
  - Guarantee: Runs a command or method, transparent pass-through
- **`Update-`**
  - Guarantee: Brings an existing resource up-to-date
  - Will not: Create new resources
- **`Build-`**
  - Guarantee: Creates an artifact from input files
- **`Convert-` / `ConvertTo-` / `ConvertFrom-`**
  - Guarantee: Transforms data between representations

When every function respects these guarantees, a user reasons about behavior from the function name without reading the implementation.

**Discovery works.** `Get-Command -Verb Install` shows every install function, and `Get-Command -Noun Poetry` every poetry function, only
when verbs are consistent: a function named `Setup-Poetry` appears in neither search.

**Tab completion works.** `Get-` then tab walks every getter, `Install-` every installable tool; a non-standard verb hides its function from
both.

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

### Plural nouns

`Cardinality: plural nouns for collections`

The verb carries the action; the **noun carries the cardinality**. A function that returns a set or list takes a plural noun, and one that
returns a single object takes the singular — so a caller knows from the name alone whether to expect a collection:

- `Get-BicepTemplates`, `Get-AdoYamlFiles` — return collections.
- `Get-BicepTemplate`, `Get-Config` — return one object.

This is a deliberate clarity choice over PowerShell's default lean toward singular nouns; the number of the noun is part of the contract.

### The quality-gate exception

`The sanctioned quality-gate exception`

Most `Test-` functions are predicates (`Test-IsRunningInPipeline`) and obey ADR-PWSH-VERBS-SEMANTICCONTRACT. A quality gate runs a body of
checks and exists to **fail the build** when they fail, so throwing is its job, not a broken contract; its `-PassThru` result object (issue
counts, report path) serves a caller that wants to branch rather than break. Naming the gates `Assert-` would be defensible, but
`Test-<Area>` reads as the CI gate it is and keeps the gate family under one discoverable verb. A genuine predicate that throws is a bug.

## Decision

Every function uses an approved PowerShell verb, with no exceptions.

### How this is enforced

- **PSScriptAnalyzer rule `PSUseApprovedVerbs`** (built-in, enabled) — warns on any function that uses a verb not in the `Get-Verb` list.
  Runs as one of the L2 tests via `Test-ScriptAnalyzer.Tests.ps1`.

## Consequences

- Every function is discoverable via `Get-Command -Verb` and `Get-Command -Noun`.
- Users can predict function behavior from the name without reading code.
- Code reads as natural language: `Assert-Command python`, `Install-Poetry`, `Get-Config azure`, `Test-IsAdministrator`.
- PSScriptAnalyzer warns on unapproved verbs, catching mistakes before code review.
- A newcomer who knows any PowerShell module navigates the codebase at once, because the vocabulary is shared.
