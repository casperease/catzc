# ADR: Never depend on $PWD

## Rules: ADR-AUTO-NOPWD

### Rule ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS

Never use relative paths that depend on the process working directory. Resolve every path from a known anchor — the code root for content
that ships with the code, and the working root for the working tree ([rule 6](#rule-adr-auto-nopwd-onerootaccessor)) — and join it with the
engine's path-joining primitive. Module code reaches the code root through its one accessor, never through the folder its own file sits in.

- [Rejected alternatives](#rejected-alternatives)
- [The code root](#the-code-root)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD-TESTSBUILDABSOLUTEPATHS

Tests must not assume the working directory: test setup builds absolute paths from the working root or from the test file's own location.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-NOPWD-ONEROOTACCESSOR

Module code reads the working-tree anchor only through its one accessor, `Get-RepositoryRoot`, never the bootstrap variable directly — the
variable is the importer's hand-off, the accessor is the one reader, so a change to where the root comes from lands in one place. A function
whose job is the variable itself carries a justified exception, and tests and the internal loader keep the variable (rule 4).

- [How this is enforced](#how-this-is-enforced)

## Context

A script that assumes it runs from the repository root works when its author runs it by hand and breaks when called from another working
directory, a scheduled task, a CI pipeline, or a nested script that moved earlier. A function that uses a relative path like
`pwsh/Azure/configs/azure.yml`, or shells out to a tool sensitive to the current directory (git, dotnet, poetry), then silently works on the
wrong files or fails with a confusing error.

### Rejected alternatives

1. **Documenting "run from repo root"** — insufficient: people forget, CI configs drift, and nested calls break the assumption silently.

2. **A global change of directory at the top of scripts** — unsafe: it changes the working directory for every function called afterward and
   does not compose in concurrent or nested scenarios.

### The code root

`The code root, not the script's folder`

The toolset runs in two modes ([run-modes](../design/run-modes.md)): in source mode a function sits in its own file under its module folder,
and in build mode inside one merged file, so the executing file's folder differs between modes. The module's folder under the active code
root does not, so its configs and assets resolve identically from source and from the installed build; and since every such lookup passes a
literal child path, the lookups are an inventory the build and its tests check
([internal-asset-dependencies](internal-asset-dependencies.md)). How engine code reaches the code root, and which files keep the file-folder
anchor, is the engine twin's to say.

## Decision

All functions must work correctly regardless of the caller's working directory, and module code finds its own content through the code root,
never through the folder its file happens to sit in.

### How this is enforced

- **Custom analyzer rule `Measure-NeverDependOnPwd`** (`pwsh/.scriptanalyzer/NeverDependOnPwd.psm1`) — warns on dependence on the current
  directory. Runs as one of the L2 tests via `Test-ScriptAnalyzer.Tests.ps1`.
- **The language layer** — the anchor idioms, the code-root and working-root analyzer rules, and the one safe way to change directory (a
  change restored in a `finally`) are the pwsh twin's: the anchors of rule 1, the test paths of rule 4, and the working-root accessor of
  rule 6.

## Consequences

- Functions can be composed freely — calling `Invoke-Poetry` from inside `Install-Poetry` works regardless of where the user's shell is
  sitting.
- CI pipelines and scheduled tasks work without a `cd` preamble.
- Every path resolves from a stable anchor, so a function behaves identically wherever it is called from — the anchor idioms live in the
  pwsh twin.
- A module's own content resolves identically in source mode and in the installed build, because both answer through the one code-root
  helper.
