# ADR: Pipeline variable interface — setting ADO output variables from PowerShell

## Rules: ADR-PIPE-VAR

### Rule ADR-PIPE-VAR:1

Never write raw `##vso[task.setvariable]` strings. Use `Set-AdoPipelineVariable`, which handles name validation, flags, and logging.

- [Why this needs a function](#why-this-needs-a-function)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PIPE-VAR:2

Variable names must not contain `.`, `-`, or `'` — ADO rewrites them during downstream resolution, so they are rejected by default. Use
underscores directly; pass `-SanitizeName` only when such characters are unavoidable.

- [Functions](#functions)

### Rule ADR-PIPE-VAR:3

Always use `-IsOutput` when the variable must cross job boundaries; without it the variable is step-local and downstream jobs see an empty
string.

- [Functions](#functions)

### Rule ADR-PIPE-VAR:4

Always use `-IsSecret` for sensitive values to mask them in ADO logs; the function replaces the value with `***` in its own output when the
flag is set.

- [Functions](#functions)

### Rule ADR-PIPE-VAR:5

Variable names use PascalCase: ADO names are case-insensitive, but PascalCase matches the parameter convention and reads clearly in YAML
output references.

- [Functions](#functions)

### Rule ADR-PIPE-VAR:6

Rely on the no-op-outside-pipelines behavior: `Set-AdoPipelineVariable` checks `Test-IsRunningInPipeline` and skips emission locally, so no
`if (Test-IsRunningInPipeline)` guards are needed at call sites.

- [Functions](#functions)

## Context

Azure DevOps pipelines communicate between steps and jobs through pipeline variables. The mechanism is a logging command written to stdout:

```text
##vso[task.setvariable variable=MyVar;isOutput=true]MyValue
```

This syntax is awkward, error-prone, and has several sharp edges:

- **Variable name characters.** ADO silently rewrites `.`, `-`, and `'` when resolving variable references, but the `##vso` command accepts
  the original characters. A variable set as `my.var` must be referenced as `my_var` downstream. If the setter and consumer use different
  conventions, the variable silently resolves to empty.

- **Output vs. local scope.** Without `isOutput=true`, the variable is local to the current step. To pass it to another job, it must be an
  output variable — but the syntax is easy to forget.

- **Secret masking.** `issecret=true` tells ADO to mask the value in logs. Forgetting this for sensitive values leaks them to the build log.

- **No validation.** The `##vso` command never fails — if you misspell a flag or omit a value, the variable is silently not set and
  downstream steps see an empty string.

### Why this needs a function

A function that validates names, handles output flags, and secret marking eliminates these sharp edges structurally. The function also makes
pipeline variable usage visible to PSScriptAnalyzer, testable in Pester, and greppable in the codebase — none of which is true for raw
`##vso` strings scattered through scripts.

## Decision

Pipeline variable manipulation is done through dedicated PowerShell functions, never through raw `##vso` logging commands.

### Functions

**`Set-AdoPipelineVariable`** — sets a pipeline variable with name validation and flags.

```powershell
function Set-AdoPipelineVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Name,
        [Parameter(Mandatory, Position = 1)] [AllowEmptyString()] [string] $Value,
        [switch] $IsOutput,
        [switch] $IsSecret,
        [switch] $SanitizeName
    )
    # ...
}
```

Behavior:

- Throws if `$Name` is null or whitespace.
- **Validates the variable name and rejects it by default.** If `$Name` contains a character ADO silently rewrites (`.`, `-`, or `'`), the
  function throws and tells the caller to use underscores directly or to pass `-SanitizeName`. This is explicit-over-silent: a name that
  would resolve differently downstream is an error, not an automatic rewrite.
- **`-SanitizeName` opts into rewriting** instead of throwing: `.` and `-` become `_`, and `'` is removed.
- Emits the `##vso[task.setvariable]` command with correct flags.
- Logs the variable name and value via `Write-Message` (when `$IsSecret`, the value is shown as `***`).
- Accepts an empty `$Value` (via `[AllowEmptyString()]`) so a caller can clear a variable or signal "no value".

**`Test-IsRunningInPipeline`** — gates pipeline-specific behavior (see [pipeline-detection ADR](pipeline-detection.md)).
`Set-AdoPipelineVariable` uses this internally — calling it outside a pipeline is a no-op with a verbose message, not an error. This keeps
automation code portable: the same function runs locally (silently skipping the `##vso` command) and in a pipeline (emitting it).

### How this is enforced

- **Convention and grep-ability.** Routing all pipeline variable writes through `Set-AdoPipelineVariable` keeps raw
  `##vso[task.setvariable]` strings out of automation code: search for `Set-AdoPipelineVariable` to find every variable the automation sets,
  and for `##vso` to confirm no raw command bypasses the function.

## Consequences

- Variable names are validated up front: a name that would resolve differently downstream (a `.` vs `_` mismatch) fails loudly at the call
  site instead of being silently rewritten to an empty variable.
- Secret masking is a flag, not a syntax detail to remember. Sensitive values cannot be accidentally logged.
- Pipeline variable usage is greppable: search for `Set-AdoPipelineVariable` to find every variable the automation sets.
- The same code runs locally and in pipelines without conditional guards. Local runs silently skip the ADO commands.
- Output variable semantics are explicit in the function call, not hidden in a `##vso` flag string.

## Dora explains

DORA's research links explicit validation and observability to reduced defects and faster incident resolution. This ADR's discipline of
centralizing pipeline variable manipulation in a validated function makes variable usage greppable and testable, prevents silent failures
from name-character rewrites and missing output flags, and enables secret masking to protect sensitive data in logs.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — centralized function makes variable usage greppable and
  testable.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — validation and logging make variable
  behavior auditable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — proper variable scoping enables reliable step/job
  communication.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
