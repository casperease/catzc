---
catzc:
  derived:
    path: docs/adr/pwsh/working-directory-mechanics.md
    kind: adr
    body_sha: "215b77f1e4d2"
    defines:
      - ADR-PWSH-PWD#{1-7}
    adrs:
      - ADR-AUTO-ASSETDEP#{1,2}
      - ADR-AUTO-NOPWD
    links:
      - docs/adr/automation/environment-variables.md
      - docs/adr/automation/internal-asset-dependencies.md
      - docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1
      - docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2
      - docs/adr/automation/never-depend-on-pwd.md
      - docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1
      - docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd4
      - docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6
      - docs/adr/automation/path-representation.md
      - docs/adr/design/run-modes.md
      - docs/adr/pwsh/cross-platform-powershell.md
---

# ADR: Working-directory mechanics — the PowerShell layer over never-depend-on-pwd

## Rules: ADR-PWSH-PWD

### Rule ADR-PWSH-PWD:1

PowerShell code applies [never-depend-on-pwd](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1) (`ADR-AUTO-NOPWD#1`) with two
anchors: the code root (`Get-CatzcModuleRoot` for a module's own content, `Get-CatzcModulesRoot` for the dot-prefixed infrastructure,
ADR-PWSH-PWD#4) and the working root (`Get-RepositoryRoot`, ADR-PWSH-PWD#6), combined with `Join-Path` — never a path resolved against
`$PWD`. `$PSScriptRoot` is the anchor only for files that are not module function files: tests, standalone asset scripts, and the
`.internal` loader.

- [The anchors](#the-anchors)

### Rule ADR-PWSH-PWD:2

Never call `Set-Location` (or `cd`) without restoring it; bare calls change `$PWD` for the rest of the session. If you must change
directory, use `Push-Location` / `Pop-Location`.

- [Changing directory safely](#changing-directory-safely)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-PWD:3

When a tool requires a specific working directory, use `Push-Location` / `Pop-Location` in a `try`/`finally` block to change directory and
guarantee restoration.

- [Changing directory safely](#changing-directory-safely)

### Rule ADR-PWSH-PWD:4

Module code locates its own content — its `configs/`, its `assets/`, another module's, and the dot-prefixed infrastructure (`.internal/`,
`.vendor/`, `.compiled/`), the internal asset dependencies of
[ADR-AUTO-ASSETDEP#1](../automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1) — only through
`Get-CatzcModuleRoot -ChildPath '<literal>'` (or `Get-CatzcModulesRoot` for the infrastructure), never through `$PSScriptRoot`,
`Get-RepositoryRoot`, or a `Join-Path` over a hand-built `automation/...` path. `$PSScriptRoot` is banned in module function files (a
module's root and `private/` `.ps1` files); tests, `assets/`, and `.internal` keep it. The analyzer rule `Measure-NoScriptRootAnchor`
enforces the ban.

- [The code root](#the-code-root)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-PWD:5

A test file builds its absolute paths from `$env:RepositoryRoot`, or from `$PSScriptRoot` for its own fixtures (`tests/assets/`), never from
`$PWD` or a relative path ([ADR-AUTO-NOPWD#4](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd4)).

- [The anchors](#the-anchors)

### Rule ADR-PWSH-PWD:6

A module function file reads the working root through `Get-RepositoryRoot`, never `$env:RepositoryRoot`
([ADR-AUTO-NOPWD#6](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6)). A function whose job is the variable itself
(`Test-InIsolation` swaps it for a sandbox and restores it) carries a justified suppression; tests and `.internal` keep the variable. The
analyzer rule `Measure-NoEnvRepositoryRoot` enforces it.

- [The anchors](#the-anchors)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-PWD:7

The child path of [ADR-AUTO-ASSETDEP#2](../automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2) is the `-ChildPath` argument
of `Get-CatzcModuleRoot`, written as one string literal at the call site — never a variable, an expression, or a `Join-Path` around the
call. `Get-InternalAssetDependency` reads that literal from the syntax trees of the module function files, so a computed child path is a
dependency the inventory cannot see.

- [The code root](#the-code-root)

## Context

[never-depend-on-pwd](../automation/never-depend-on-pwd.md) fixes the doctrine: every function works correctly regardless of the caller's
working directory, and module code finds its own content through the code root. This ADR is the PowerShell layer under it — the anchor
idioms that make paths location-independent, and the one safe way to change directory when an external tool insists on one.

### The anchors

- **`Get-CatzcModuleRoot`** gives the calling module's folder under the active code root — the anchor for a module's own assets and configs
  (`Get-CatzcModuleRoot -ChildPath 'configs/tools.yml'`), correct in source mode and in the installed build alike
  ([the code root](#the-code-root)).
- **`Get-RepositoryRoot`** gives the repository root, which `importer.ps1` sets once at bootstrap as `$env:RepositoryRoot` and treats as a
  constant ([environment-variables](../automation/environment-variables.md)) — the anchor for repository-level paths, via the binding
  helpers of [path-representation](../automation/path-representation.md) (`Resolve-RepoPath`, `Get-RepositoryFile`). Module code calls the
  accessor; tests and `.internal` read the variable.
- **`$PSScriptRoot`** gives the directory of the current script file — the anchor for a test's own fixtures (`tests/assets/`), for a
  standalone asset script, and for the `.internal` loader, none of which is a module function file.

Every path is built from one of these with `Join-Path` ([cross-platform-powershell](cross-platform-powershell.md)); a relative path in a
cmdlet argument resolves against `$PWD` and is exactly the dependence the doctrine forbids.

### The code root

`The code root, not the script's folder`

`$PSScriptRoot` is the folder of the file that is executing, which makes it an anchor for the file's location rather than for the module.
The toolset runs in two modes ([run-modes](../design/run-modes.md)): in source mode a function file sits in `automation/<Module>/` or its
`private/` folder, and in build mode the same function sits inside one merged `<Module>.functions.ps1` in the build. A
`$PSScriptRoot`-relative lookup gives a different answer in each mode — and even within source mode it differs between a root file and a
`private/` file, which is why such lookups carry `../` fragments. `Get-CatzcModuleRoot` answers with the module's folder under the active
code root (`CatzcModulesRoot`) in both modes, so `Get-CatzcModuleRoot -ChildPath 'configs/tools.yml'` names the same file from any function
of the module, in source and in build alike. Because every such lookup passes a literal child path, the lookups are also an inventory the
build and its tests check ([internal-asset-dependencies](../automation/internal-asset-dependencies.md)).

Tests, a module's `assets/` scripts, and the `.internal` loader keep `$PSScriptRoot`: tests run from the source tree by definition, an asset
script is a standalone file that travels unmerged, and the loader is what sets the code root in the first place.

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

Paths resolve from the code root (`Get-CatzcModuleRoot`, with a literal `-ChildPath`) or the working root (`Get-RepositoryRoot`) with
`Join-Path`; module function files use neither `$PSScriptRoot` nor `$env:RepositoryRoot`; a required working directory is set with
`Push-Location`/`Pop-Location` in `try`/`finally`; a bare `Set-Location`/`cd` never appears.

### How this is enforced

- **Custom PSScriptAnalyzer rule `Measure-NeverDependOnPwd`** (`automation/.scriptanalyzer/NeverDependOnPwd.psm1`) — flags bare
  `Set-Location`/`cd` calls (ADR-PWSH-PWD#2) and `$PWD` references (ADR-AUTO-NOPWD#1). Runs as one of the L2 tests via
  `Test-ScriptAnalyzer.Tests.ps1`.
- **Custom PSScriptAnalyzer rule `Measure-NoScriptRootAnchor`** (`automation/.scriptanalyzer/NoScriptRootAnchor.psm1`) — flags
  `$PSScriptRoot` in module function files (ADR-PWSH-PWD#4), exempting tests, `assets/`, and `.internal`.
- **Custom PSScriptAnalyzer rule `Measure-NoEnvRepositoryRoot`** (`automation/.scriptanalyzer/NoEnvRepositoryRoot.psm1`) — flags a
  `$env:RepositoryRoot` read in a module function file (ADR-PWSH-PWD#6).

## Consequences

- Functions compose freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is sitting,
  because nothing reads or leaves state in `$PWD`.
- Tools that need a working directory get it scoped and restored, so a throw mid-operation never strands the session in a foreign directory.
- The anchor idioms are uniform: module-local paths hang off `Get-CatzcModuleRoot`, repository paths off `Get-RepositoryRoot` — one
  convention to read, one for the analyzer to check.
- A module's own content resolves identically in source mode and in the installed build, because both answer through the one code-root
  helper.
