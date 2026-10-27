# ADR: Run modes in PowerShell — entry scripts, module files, and build roots

## Rules: ADR-PWSH-RUNMODE

### Rule ADR-PWSH-RUNMODE-ENTRYSCRIPTS

Source mode is entered by dot-sourcing `importer.ps1` at the repository root, which loads every module from `pwsh/<Module>/`. Build mode is
entered by dot-sourcing the package's `Import-Catzc.ps1`, or by `Import-Module Catzc` for an installed package, whose root module
dot-sources that file. A built module is a generated `.psd1` and one merged `<Module>.functions.ps1`.

- [Entry scripts and module files](#entry-scripts-and-module-files)

### Rule ADR-PWSH-RUNMODE-MODULEPERSCOPE

The `Catzc` package is a container: every source module inside it is its own PowerShell module with its own session state, so no module
reads another's `$script:` value.

- [One session state per module](#one-session-state-per-module)

### Rule ADR-PWSH-RUNMODE-BUILDROOTPATHS

`Get-CatzcRunMode` answers `source` when `CatzcModulesRoot` is `<RepositoryRoot>/pwsh`, and `build` otherwise. The three build roots are
`<RepositoryRoot>/out/pwsh/built/<bundle>/Catzc/<v>/` (temporary, by `Build-Modules`), `<PSModulePath entry>/Catzc/<v>/` (installed, by
`Install-Catzc -Scope`), and `<root>/.vendor/Catzc/<v>/` (saved, by `Install-Catzc -Root`, which `Export-Catzc -Root` calls).

- [Build roots](#build-roots)

## Context

The design record [run-modes](../../design/run-modes.md) (DDR-RUNMODE) states the two run modes for any engine: one set of modules, a
derived mode, no coexistence, the same tests, and three kinds of build root. This record is how pwsh spells them.

### Entry scripts and module files

| Mode   | Code root (`CatzcModulesRoot`) | Entered by                                | A module on disk                          |
| ------ | ------------------------------ | ----------------------------------------- | ----------------------------------------- |
| source | `<RepositoryRoot>/pwsh`        | `importer.ps1`                            | a folder of one-function `.ps1` files     |
| build  | one of the build roots below   | `Import-Catzc.ps1`, `Import-Module Catzc` | a generated `.psd1` and one merged `.ps1` |

Both entries are dot-sourced, so they run in the caller's scope. A temporary build, written by `Build-Modules` in a source-mode session, is
entered by dot-sourcing its `Import-Catzc.ps1` with `-RepositoryRoot` set to the repository. A build's `build.json` names the version and
the commit it was built from. `Build-Modules` merges the function files in the order the source manifest lists them.

### One session state per module

Config validation (`Get-Config` running a validator in its owning module's scope), `Get-Module`, and a test's `Mock -ModuleName` or
`InModuleScope` all name a module, so each built module stays a PowerShell module of its own. Two modules that hold a `$script:` cache entry
of the same name never see each other's value, and the scope-isolation test proves it. An evicted module takes its script scope with it, and
`Assert-CatzcRunModeExclusive` at the importer tail throws when a loaded `Catzc.*` module or the `Catzc` package lies outside the active
code root.

### Build roots

| Kind      | Code root                                             | Made by                     |
| --------- | ----------------------------------------------------- | --------------------------- |
| temporary | `<RepositoryRoot>/out/pwsh/built/<bundle>/Catzc/<v>/` | `Build-Modules` on a devbox |
| installed | `<PSModulePath entry>/Catzc/<v>/`                     | `Install-Catzc -Scope`      |
| saved     | `<root>/.vendor/Catzc/<v>/`                           | `Install-Catzc -Root`       |

`<v>` is the package version. A NuGet package from `Export-Catzc -To nuget` is a distribution file, not a code root. A module locates its
own files through `Get-CatzcModuleRoot`, and a source-tree tool asserts with `Assert-SourceTree` that it runs in source mode.

## Decision

In pwsh, a session runs in source mode through `importer.ps1` and in build mode through `Import-Catzc.ps1` or `Import-Module Catzc`, keeps
every built module a PowerShell module of its own, and derives the mode from `CatzcModulesRoot` with `Get-CatzcRunMode`.

## Consequences

- A reviewer finds every pwsh spelling of the run modes here; the design record carries none.
- A new entry script or build root is a change to this record and to the importer, never to the design record.
