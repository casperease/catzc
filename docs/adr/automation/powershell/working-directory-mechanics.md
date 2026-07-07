# ADR: Working-directory mechanics — the PowerShell layer over never-depend-on-pwd

## Rules: ADR-PSPWD

### Rule ADR-PSPWD:1

PowerShell code applies [never-depend-on-pwd](../never-depend-on-pwd.md) (`ADR-NOPWD`) with two anchors: `$PSScriptRoot` (the directory of
the current script file) and `$env:RepositoryRoot` (the repository root set by `importer.ps1`), combined with `Join-Path` — never a path
resolved against `$PWD`.

- [The anchors](#the-anchors)

### Rule ADR-PSPWD:2

Never call `Set-Location` (or `cd`) without restoring it; bare calls change `$PWD` for the rest of the session. If you must change
directory, use `Push-Location` / `Pop-Location`.

- [Changing directory safely](#changing-directory-safely)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PSPWD:3

When a tool requires a specific working directory, use `Push-Location` / `Pop-Location` in a `try`/`finally` block to change directory and
guarantee restoration.

- [Changing directory safely](#changing-directory-safely)

## Context

[never-depend-on-pwd](../never-depend-on-pwd.md) fixes the doctrine: every function works correctly regardless of the caller's working
directory. This ADR is the PowerShell layer under it — the anchor idioms that make paths location-independent, and the one safe way to
change directory when an external tool insists on one.

### The anchors

- **`$PSScriptRoot`** gives the directory of the current script file — the anchor for a module's own assets and configs
  (`Join-Path $PSScriptRoot 'configs/tools.yml'`).
- **`$env:RepositoryRoot`** gives the repository root, set once by `importer.ps1` at bootstrap and treated as a constant
  ([environment-variables](../environment-variables.md)) — the anchor for repository-level paths, via the binding helpers of
  [path-representation](../path-representation.md) (`Resolve-RepoPath`, `Get-RepositoryFile`).

Every path is built from one of these with `Join-Path` ([cross-platform-powershell](cross-platform-powershell.md)); a relative path in a
cmdlet argument resolves against `$PWD` and is exactly the dependence the doctrine forbids.

### Changing directory safely

Some tools are sensitive to the current directory (git, dotnet, poetry). The working directory they need is set locally and always restored:

```powershell
Push-Location $repoRoot
try {
    Invoke-Executable 'git status --porcelain'
}
finally {
    Pop-Location
}
```

A bare `Set-Location` (or `cd`) mutates `$PWD` for everything that runs afterwards — the caller, sibling functions, the interactive session
— and does not compose in nested or concurrent scenarios. `Push-Location`/`Pop-Location` in `try`/`finally` guarantees the directory is
restored on every path out, including a throw.

## Decision

Paths resolve from `$PSScriptRoot` or `$env:RepositoryRoot` with `Join-Path`; a required working directory is set with
`Push-Location`/`Pop-Location` in `try`/`finally`; a bare `Set-Location`/`cd` never appears.

### How this is enforced

- **Custom PSScriptAnalyzer rule `Measure-NeverDependOnPwd`** (`automation/.scriptanalyzer/NeverDependOnPwd.psm1`) — flags bare
  `Set-Location`/`cd` calls (`ADR-PSPWD:2`) and `$PWD` references (`ADR-NOPWD:1`). Runs as part of the L2 test suite via
  `Test-ScriptAnalyzer.Tests.ps1`.

## Consequences

- Functions compose freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is sitting,
  because nothing reads or leaves state in `$PWD`.
- Tools that need a working directory get it scoped and restored, so a throw mid-operation never strands the session in a foreign directory.
- The anchor idioms are uniform: module-local paths hang off `$PSScriptRoot`, repository paths off `$env:RepositoryRoot` — one convention to
  read, one for the analyzer to check.

## Dora explains

DORA research shows that eliminating implicit dependencies on environmental state improves code reliability and team velocity. Anchoring
paths to fixed locations and restoring working directory in try/finally guarantees functions compose correctly and never pollute session
state.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit anchors eliminate hidden state pollution and
  failures.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — location-independent functions compose and work
  everywhere.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
