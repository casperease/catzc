# docs/adr/automation/never-depend-on-pwd.md

ADR: Never depend on `$PWD`

## Rules: ADR-AUTO-NOPWD

### Rule ADR-AUTO-NOPWD:1

Never use relative paths that depend on the process working directory. Resolve every path from a known anchor — in PowerShell, the code root
(`Get-CatzcModuleRoot`, `Get-CatzcModulesRoot`) for content that ships with the code ([rule 5](#rule-adr-auto-nopwd5)) and
`$env:RepositoryRoot` for the working tree, joined with `Join-Path` (the anchor idioms are the language layer,
[working-directory-mechanics](powershell/working-directory-mechanics.md), `ADR-AUTO-PSPWD`).

- [Rejected alternatives](#rejected-alternatives)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD:4

Tests must not assume `$PWD`: test setup uses absolute paths derived from `$env:RepositoryRoot` or `$PSScriptRoot`.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD:5

Module code locates its own content — its `configs/`, its `assets/`, another module's, and the dot-prefixed infrastructure (`.internal/`,
`.vendor/`, `.compiled/`) — only through `Get-CatzcModuleRoot` (or `Get-CatzcModulesRoot` for the infrastructure). `$PSScriptRoot` is banned
in module function files (a module's root and `private/` `.ps1` files); tests, `assets/`, and `.internal` keep it. The analyzer rule
`Measure-NoScriptRootAnchor` enforces the ban.

- [The code root, not the script's folder](#the-code-root-not-the-scripts-folder)
- [How this is enforced](#how-this-is-enforced)

## Context

PowerShell scripts often assume they are run from a specific directory — typically the repository root. This works when the author runs the
script manually but breaks the moment someone calls the function from a different working directory, a scheduled task, a CI pipeline, or a
nested script that changed location earlier.

Functions that use relative paths like `./automation/Catzc.Azure/configs/azure.yml`, or shell out to tools sensitive to the current
directory (git, dotnet, poetry), will silently operate on the wrong files or fail with confusing errors when `$PWD` is not what the author
expected.

### Rejected alternatives

1. **Documenting "run from repo root"** — insufficient: people forget, CI configs drift, and nested calls break the assumption silently.

2. **A global `Set-Location` at the top of scripts** — unsafe: it changes `$PWD` for every function called afterward and does not compose in
   concurrent or nested scenarios.

### The code root, not the script's folder

`$PSScriptRoot` is the folder of the file that is executing, which makes it an anchor for the file's location rather than for the module.
The toolset runs in two modes ([run-modes](../design/run-modes.md)): in source mode a function file sits in `automation/<Module>/` or its
`private/` folder, and in build mode the same function sits inside one merged `<Module>.functions.ps1` in the build. A
`$PSScriptRoot`-relative lookup gives a different answer in each mode — and even within source mode it differs between a root file and a
`private/` file, which is why such lookups carry `../` fragments. `Get-CatzcModuleRoot` answers with the module's folder under the active
code root (`CatzcModulesRoot`) in both modes, so `Get-CatzcModuleRoot -ChildPath 'configs/tools.yml'` names the same file from any function
of the module, in source and in build alike. Because every such lookup passes a literal child path, the lookups are also an inventory the
build and its tests check ([internal-asset-dependencies](internal-asset-dependencies.md)).

Tests, a module's `assets/` scripts, and the `.internal` loader keep `$PSScriptRoot`: tests run from the source tree by definition, an asset
script is a standalone file that travels unmerged, and the loader is what sets the code root in the first place.

## Decision

All functions must work correctly regardless of the caller's `$PWD`, and module code finds its own content through the code root, never
through the folder its file happens to sit in.

### How this is enforced

- **Custom PSScriptAnalyzer rule `Measure-NeverDependOnPwd`** (`automation/.scriptanalyzer/NeverDependOnPwd.psm1`) — warns on `$PWD`
  dependence. Runs as one of the L2 tests via `Test-ScriptAnalyzer.Tests.ps1`.
- **Custom PSScriptAnalyzer rule `Measure-NoScriptRootAnchor`** (`automation/.scriptanalyzer/NoScriptRootAnchor.psm1`) — flags
  `$PSScriptRoot` in any module function file (root or `private/`), exempting tests, `assets/`, and `.internal`
  ([rule 5](#rule-adr-auto-nopwd5)). Runs in the same analyzer gate, in the L2 tests.
- **The language layer** — the anchor idioms and the one safe way to change directory (`Push-Location`/`Pop-Location` in `try`/`finally`)
  are [working-directory-mechanics](powershell/working-directory-mechanics.md) (`ADR-AUTO-PSPWD`), which the same analyzer rule enforces.

## Consequences

- Functions can be composed freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is
  sitting.
- CI pipelines and scheduled tasks work without a `cd` preamble.
- Every path resolves from a stable anchor, so a function behaves identically wherever it is called from — the anchor idioms live in
  [working-directory-mechanics](powershell/working-directory-mechanics.md).
- A module's own content resolves identically in source mode and in the installed build, because both answer through the one code-root
  helper.
