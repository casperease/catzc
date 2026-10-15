---
catzc:
  derived:
    path: docs/adr/automation/never-depend-on-pwd.md
    kind: adr
    body_sha: "0a928ba0ca1e"
    defines:
      - ADR-AUTO-NOPWD#1
      - ADR-AUTO-NOPWD#4
      - ADR-AUTO-NOPWD#6
    adrs:
      - ADR-PWSH-PWD#1
      - ADR-PWSH-PWD#4
      - ADR-PWSH-PWD#5
      - ADR-PWSH-PWD#6
    links:
      - docs/adr/automation/internal-asset-dependencies.md
      - docs/adr/design/run-modes.md
      - docs/adr/pwsh/working-directory-mechanics.md
      - docs/adr/pwsh/working-directory-mechanics.md#the-code-root
---

# ADR: Never depend on $PWD

## Rules: ADR-AUTO-NOPWD

### Rule ADR-AUTO-NOPWD:1

Never use relative paths that depend on the process working directory. Resolve every path from a known anchor — the code root for content
that ships with the code, and the working root for the working tree ([rule 6](#rule-adr-auto-nopwd6)) — and join it with the engine's
path-joining primitive. Module code reaches the code root through its one accessor, never through the folder its own file sits in.

- [Rejected alternatives](#rejected-alternatives)
- [The code root](#the-code-root)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD:4

Tests must not assume the working directory: test setup builds absolute paths from the working root or from the test file's own location.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD:6

Module code reads the working-tree anchor only through its one accessor, `Get-RepositoryRoot`, never the bootstrap variable directly — the
variable is the importer's hand-off, the accessor is the one reader, so a change to where the root comes from lands in one place. A function
whose job is the variable itself carries a justified exception, and tests and the internal loader keep the variable (rule 4).

- [How this is enforced](#how-this-is-enforced)

## Context

Scripts often assume they are run from a specific directory — typically the repository root. This works when the author runs the script
manually but breaks the moment someone calls the function from a different working directory, a scheduled task, a CI pipeline, or a nested
script that changed location earlier.

Functions that use relative paths like `./automation/Catzc.Azure/configs/azure.yml`, or shell out to tools sensitive to the current
directory (git, dotnet, poetry), will silently operate on the wrong files or fail with confusing errors when the working directory is not
what the author expected.

### Rejected alternatives

1. **Documenting "run from repo root"** — insufficient: people forget, CI configs drift, and nested calls break the assumption silently.

2. **A global change of directory at the top of scripts** — unsafe: it changes the working directory for every function called afterward and
   does not compose in concurrent or nested scenarios.

### The code root

`The code root, not the script's folder`

The toolset runs in two modes ([run-modes](../design/run-modes.md)): in source mode a function sits in its own file under its module folder,
and in build mode the same function sits inside one merged file in the build. An anchor taken from the folder of the executing file
therefore gives a different answer in each mode. The code root — the module's folder under the active code root — gives the same answer in
both, so a module's own configs and assets resolve identically from source and from the installed build. Because every such lookup passes a
literal child path, the lookups are also an inventory the build and its tests check
([internal-asset-dependencies](internal-asset-dependencies.md)). How PowerShell code reaches the code root, and which files keep the
file-folder anchor, is [working-directory-mechanics](../pwsh/working-directory-mechanics.md#the-code-root).

## Decision

All functions must work correctly regardless of the caller's working directory, and module code finds its own content through the code root,
never through the folder its file happens to sit in.

### How this is enforced

- **Custom PSScriptAnalyzer rule `Measure-NeverDependOnPwd`** (`automation/.scriptanalyzer/NeverDependOnPwd.psm1`) — warns on `$PWD`
  dependence. Runs as one of the L2 tests via `Test-ScriptAnalyzer.Tests.ps1`.
- **The language layer** — the anchor idioms, the code-root and working-root analyzer rules, and the one safe way to change directory
  (`Push-Location`/`Pop-Location` in `try`/`finally`) are [working-directory-mechanics](../pwsh/working-directory-mechanics.md)
  (`ADR-PWSH-PWD`): the anchors of rule 1 in ADR-PWSH-PWD#1 and ADR-PWSH-PWD#4, the test paths of rule 4 in ADR-PWSH-PWD#5, and the
  working-root accessor of rule 6 in ADR-PWSH-PWD#6.

## Consequences

- Functions can be composed freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is
  sitting.
- CI pipelines and scheduled tasks work without a `cd` preamble.
- Every path resolves from a stable anchor, so a function behaves identically wherever it is called from — the anchor idioms live in
  [working-directory-mechanics](../pwsh/working-directory-mechanics.md).
- A module's own content resolves identically in source mode and in the installed build, because both answer through the one code-root
  helper.
