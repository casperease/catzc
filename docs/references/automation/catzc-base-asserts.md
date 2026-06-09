# Catzc.Base.Asserts

The assertion library. It is the vocabulary every other module uses to state a precondition and stop the moment it is violated. It owns no
I/O of its own and depends on nothing else — it is the bottom of the stack, the concrete embodiment of
[fail-fast-with-asserts](../../adr/automation/fail-fast-with-asserts.md) and
[error-handling](../../adr/automation/powershell/error-handling.md).

## Domains

| Domain   | Area        | Name                                                                                       |
| -------- | ----------- | ------------------------------------------------------------------------------------------ |
| domain:1 | value       | [Value, nullness, and type checks](#domain1--value-nullness-and-type-checks)               |
| domain:2 | environment | [Resource and environment preconditions](#domain2--resource-and-environment-preconditions) |
| domain:3 | pipeline    | [Pipeline-shape checks](#domain3--pipeline-shape-checks)                                   |
| domain:4 | config      | [Configuration-shape checks](#domain4--configuration-shape-checks)                         |

### domain:1 — Value, nullness, and type checks

Validating an in-memory value: that it is (or is not) null, empty, or whitespace; that it is exactly true or false; that it is of an
expected .NET type; that it is a well-formed identifier; that an object carries an expected member. This is the most-used domain — the guard
clauses at the top of almost every function.

### domain:2 — Resource and environment preconditions

Validating the world outside the value: that a filesystem path exists, that an external command is on `PATH`, that a PowerShell module is
available, that the session is elevated, and that the last external process exited cleanly. These assert that the function's _environment_
is fit before it does work.

### domain:3 — Pipeline-shape checks

Validating the _shape of a stream_ as it flows through a pipeline: that a pipeline produced exactly, at least, or at most a given number of
objects, or that it produced none. These pass their input through, so they assert mid-pipeline without breaking the flow.

### domain:4 — Configuration-shape checks

Validating the structural conventions a configuration file must obey before it is trusted — chiefly that every key in a parsed config uses
the project's `snake_case` naming. This is the assertion the config layer leans on.

## What the module does

Every entry in this module is a precondition expressed as a verb. The library exists so that a violated assumption fails at the exact line
that made it, with a message that names the assumption — never as a vague error three frames later, and never silently.

The defining design choice is the **throw-or-ask duality**, and it runs through domains 1, 2, and 3. The same check is offered in two moods:
an _affirming_ form that throws on failure (the precondition the caller demands be true), and a _querying_ form that returns a boolean (the
condition the caller wants to branch on). The affirming form is for "this must hold or stop"; the querying form is for "if this holds, do
X." Picking the right mood is how a function says whether a condition is a contract or a choice — the same distinction the approved-verb
rules draw between an affirming verb and a testing verb (see
[respect-pwsh-verb-rules](../../adr/automation/powershell/respect-pwsh-verb-rules.md)).

The module is deliberately leaf-like: it has no private helpers and reads no configuration. That keeps it loadable and trustworthy before
anything else in the system has initialised, which is exactly what a fail-fast foundation needs. The higher layers — the utilities, the
tooling, the Azure modules — all phrase their guard clauses in this vocabulary, so a failure anywhere in the system reads in one consistent
voice.

## Division

The module's public functions, sorted into the domains above.

| Domain                                            | Function                     |
| ------------------------------------------------- | ---------------------------- |
| domain:1 — Value, nullness, and type checks       | `Assert-True`                |
|                                                   | `Assert-False`               |
|                                                   | `Assert-Null`                |
|                                                   | `Assert-NotNull`             |
|                                                   | `Assert-NotNullOrWhitespace` |
|                                                   | `Test-NotNullOrWhitespace`   |
|                                                   | `Assert-TypeIs`              |
|                                                   | `Assert-IsGuid`              |
|                                                   | `Test-IsGuid`                |
|                                                   | `Assert-HaveProperty`        |
|                                                   | `Test-HaveProperty`          |
| domain:2 — Resource and environment preconditions | `Assert-PathExist`           |
|                                                   | `Assert-Command`             |
|                                                   | `Test-Command`               |
|                                                   | `Assert-PsModule`            |
|                                                   | `Assert-IsAdministrator`     |
|                                                   | `Test-IsAdministrator`       |
|                                                   | `Assert-LastExitCodeWasZero` |
| domain:3 — Pipeline-shape checks                  | `Assert-PipelineCount`       |
|                                                   | `Assert-PipelineEmpty`       |
| domain:4 — Configuration-shape checks             | `Assert-YmlNaming`           |
