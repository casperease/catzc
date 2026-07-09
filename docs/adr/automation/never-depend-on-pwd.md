# ADR: Never depend on `$PWD`

## Rules: ADR-AUTO-NOPWD

### Rule ADR-AUTO-NOPWD:1

Never use relative paths that depend on the process working directory. Resolve every path from a known anchor — in PowerShell,
`$PSScriptRoot` or `$env:RepositoryRoot` joined with `Join-Path` (the anchor idioms are the language layer,
[working-directory-mechanics](powershell/working-directory-mechanics.md), `ADR-AUTO-PSPWD`).

- [Rejected alternatives](#rejected-alternatives)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD:4

Tests must not assume `$PWD`: test setup uses absolute paths derived from `$env:RepositoryRoot` or `$PSScriptRoot`.

- [How this is enforced](#how-this-is-enforced)

## Context

PowerShell scripts often assume they are run from a specific directory — typically the repository root. This works when the author runs the
script manually but breaks the moment someone calls the function from a different working directory, a scheduled task, a CI pipeline, or a
nested script that changed location earlier.

Functions that use relative paths like `./automation/Catzc.Azure.Templates/configs/azure.yml`, or shell out to tools sensitive to the
current directory (git, dotnet, poetry), will silently operate on the wrong files or fail with confusing errors when `$PWD` is not what the
author expected.

### Rejected alternatives

1. **Documenting "run from repo root"** — insufficient: people forget, CI configs drift, and nested calls break the assumption silently.

2. **A global `Set-Location` at the top of scripts** — unsafe: it changes `$PWD` for every function called afterward and does not compose in
   concurrent or nested scenarios.

## Decision

All functions must work correctly regardless of the caller's `$PWD`.

### How this is enforced

- **Custom PSScriptAnalyzer rule `Measure-NeverDependOnPwd`** (`automation/.scriptanalyzer/NeverDependOnPwd.psm1`) — warns on `$PWD`
  dependence. Runs as part of the L2 test suite via `Test-ScriptAnalyzer.Tests.ps1`.
- **The language layer** — the anchor idioms and the one safe way to change directory (`Push-Location`/`Pop-Location` in `try`/`finally`)
  are [working-directory-mechanics](powershell/working-directory-mechanics.md) (`ADR-AUTO-PSPWD`), which the same analyzer rule enforces.

## Consequences

- Functions can be composed freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is
  sitting.
- CI pipelines and scheduled tasks work without a `cd` preamble.
- Every path resolves from a stable anchor, so a function behaves identically wherever it is called from — the anchor idioms live in
  [working-directory-mechanics](powershell/working-directory-mechanics.md).

## Dora explains

Absolute path resolution is essential to making functions composable and reproducible across environments. This discipline enables
consistent behavior in CI pipelines, scheduled tasks, and nested function calls—all prerequisites for reliable automation.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — scripts work in pipelines without working-directory
  preambles.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — functions behave identically in automated contexts
  regardless of caller location.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — predictable path resolution makes functions easier to reason
  about and compose.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
