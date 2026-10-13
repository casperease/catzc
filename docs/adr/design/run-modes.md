# ADR: Run modes — source mode and build mode

## Rules: ADR-DSGN-RUNMODE

### Rule ADR-DSGN-RUNMODE:1

The toolset runs in exactly two modes. **Source mode** loads every module from `automation/<Module>/` in a repository root, entered by
`importer.ps1`. **Build mode** loads the same modules from a built, installable `Catzc` package — each module's functions merged into one
`<Module>.functions.ps1` — entered by the package's `Import-Catzc.ps1` (or `build-catzc.ps1` at the repository root, which builds and then
enters build mode).

- [Two modes, two entry points](#two-modes-two-entry-points)

### Rule ADR-DSGN-RUNMODE:2

Every module works in both modes and is the same module in both: the same name, public functions, private functions, configs, and assets.
Only its on-disk form differs.

- [The same module in both modes](#the-same-module-in-both-modes)

### Rule ADR-DSGN-RUNMODE:3

Each module keeps its own script scope in both modes. Built modules are separate PowerShell modules inside the one package, so no module
ever shares `$script:` state with another.

- [One scope per module, never shared](#one-scope-per-module-never-shared)

### Rule ADR-DSGN-RUNMODE:4

The mode is derived, never stored: `Get-CatzcRunMode` answers `source` when the code root (`CatzcModulesRoot`) is
`<RepositoryRoot>/automation`, and `build` otherwise.

- [The mode is derived from the code root](#the-mode-is-derived-from-the-code-root)

### Rule ADR-DSGN-RUNMODE:5

The two modes never coexist in one session. Entering either mode first removes every module loaded from the other mode's root, then asserts
that every loaded catzc module comes from the active root. Switching works in any order and any number of times; the one thing that cannot
be swapped is the loaded C# types assembly, which is reused when both modes' type sources are identical.

- [Switching modes in one session](#switching-modes-in-one-session)

### Rule ADR-DSGN-RUNMODE:6

Both modes are tested by the same tests: the source run (`Test-Automation`) and the build run (`Test-CatzcBuild`) execute the same test
files up to L2, and a test opts out of the build run only with the `source-only` tag.

- [One body of tests proves both modes](#one-body-of-tests-proves-both-modes)

## Context

Source mode is how the toolset is developed: one function per file
([one-function-per-file](../automation/powershell/one-function-per-file.md)), read in place from the repository, with every module's
manifest generated from its folder on import. That form serves the people who edit the code — a directory listing is the module's API, a
diff touches one function, blame has one history per function.

An installable, versioned package is how the toolset is shipped to other machines: carried out of the repository, loaded with no git and no
compile, and opened as few files as possible because real-time antivirus scans every file on a cold import
([effective-in-enterprises](../automation/effective-in-enterprises.md)). Those needs pull the on-disk form the other way.

Treating the package as a separate product would let the two drift: a fix in source that the package lacks, a package-only loader with its
own bugs, a second set of tests that proves something about a copy. Treating it as a **second run mode of the same modules** keeps one body
of code, one importer, and one body of tests behind both forms.

## Decision

The toolset has two run modes over one set of modules. Modules are identical in both, never share script state, cannot coexist across modes
in one session, and are proven in both by running the same tests.

### Two modes, two entry points

| Mode   | Code root (`CatzcModulesRoot`)            | Entered by                                                   | A module on disk                          |
| ------ | ----------------------------------------- | ------------------------------------------------------------ | ----------------------------------------- |
| source | `<RepositoryRoot>/automation`             | `importer.ps1`                                               | a folder of one-function `.ps1` files     |
| build  | a build's or install's `Catzc/<version>/` | `Import-Catzc.ps1`, `Import-Module Catzc`, `build-catzc.ps1` | a generated `.psd1` and one merged `.ps1` |

Both entry scripts at the repository root are dot-sourced and run in the caller's scope. `importer.ps1` loads source mode. `build-catzc.ps1`
builds the selected modules in a child `pwsh` — building needs source mode loaded, and doing it in a child process keeps the caller's
session and its loaded assemblies out of it — and then dot-sources the build's `Import-Catzc.ps1` in the caller's session with
`-RepositoryRoot` set to the repository, so `out/` and repo-relative paths keep resolving there while the code root moves to the build. An
installed build is entered the same way, through its own `Import-Catzc.ps1` or through `Import-Module Catzc`, whose root module dot-sources
that file. Every entry point ends in the one living importer ([platform-bundle](../automation/platform-bundle.md#rule-adr-auto-bundle3)), so
the load sequence — preferences, vendored modules, types and accelerators, then modules — is the same in both modes.

Both modes end with the same load banner (`Write-CatzcLoadBanner`): the mode and version as the session's identity line, then where the code
was loaded from, the working root, the commit it was built from, and the loaded module and assembly set. It is read from what actually
loaded, so it is also how a reader confirms which mode a session is in.

### The same module in both modes

A built module has the same name as its source folder, exports the same public functions, carries the same private functions, and ships the
same `configs/` and `assets/`. `Build-Modules` merges the function files in the same order the source manifest lists them, so load semantics
are identical; the built manifest exports the module's public functions only. Everything that names a module — `Get-Config` running a
validator in its owning module's scope ([module-config-loading](../configuration/module-config-loading.md)), `Get-Module`, a test's
`Mock -ModuleName` or `InModuleScope` — resolves the same way in both modes.

What makes this hold for content as well as code is that a module locates its own files only through the code root (`Get-CatzcModuleRoot`,
[never-depend-on-pwd](../automation/never-depend-on-pwd.md#rule-adr-auto-nopwd5)), never through the folder its source file sits in, and
that every such lookup is inventoried and tested in both modes
([internal-asset-dependencies](../automation/internal-asset-dependencies.md)). Tools whose job is the source tree itself — formatters,
dependency tooling, README and dictionary generators — operate on per-function files and git by definition; they assert that they run in
source mode (`Assert-SourceTree`) and fail fast in a build rather than reading the wrong tree.

### One scope per module, never shared

Merging every module into one flat scope would be the simplest build and the wrong one. Module scope is a contract: each module's `$script:`
caches belong to it alone ([script-scope-caching](../automation/powershell/script-scope-caching.md)), and config validation, mocks, and
module queries all name a module. So the package `Catzc` is a container, not a scope: inside it every source module is its own PowerShell
module with its own session state, exactly as in source mode. Two modules that hold a `$script:` slot of the same name never see each
other's value, in either mode, and a scope-isolation test proves it.

### The mode is derived from the code root

There is no run-mode variable. `CatzcModulesRoot` is set once per load by the entry point
([environment-variables](../automation/environment-variables.md#rule-adr-auto-envvar5)), and the mode follows from it: when the code root is
the repository's own `automation/` folder, the session is in source mode; anywhere else, it is in build mode. A stored mode flag could
disagree with the code actually loaded; a derived one cannot.

### Switching modes in one session

A developer moves between the modes in one shell — `importer.ps1`, then `build-catzc.ps1`, then `importer.ps1` again, in any order and as
often as needed. Two copies of one module from different roots in the same session would make every call ambiguous, so the importer enforces
mutual exclusion:

- **Evict before loading.** Before it loads a root, the importer removes every loaded catzc module (a `Catzc.*` module or the `Catzc`
  package) whose base lies outside that root, together with the root's own stale modules. The `.internal` loader modules are reloaded from
  the new root, so the loader itself always belongs to the active mode.
- **Assert after loading.** `Assert-CatzcRunModeExclusive` runs at the importer tail in both modes and throws, naming the offending modules
  and both roots, when any loaded catzc module lies outside the active code root.
- **Caches reset by construction.** An evicted module takes its script scope with it, so a switched session never sees a cache from the
  other mode. Vendored modules are reloaded from the active mode's `.vendor/`.
- **Types are the exception.** A loaded .NET assembly cannot be unloaded. Every build ships the full type set — the same `types/*.cs`
  sources and the same hash-named DLL as the source tree, whatever its module selection — so when the sources are unchanged the type
  identities are the same and the loaded assembly is reused in any switch order. The types guard compares the per-file digests of the loaded
  type set with the sources the new root needs; when a source differs (a `types/*.cs` edited between the two loads), the native-types
  contract applies: a devbox keeps the loaded types and asks for a fresh PowerShell, and a pipeline throws
  ([native-csharp-types](../automation/BCL/native-csharp-types.md)).

### One body of tests proves both modes

"Every module works in both modes" is a checked property, not a hope. The source run and the build run execute the **same** test files — no
copy, no second set to drift — through the same harness, differing only in the entry script each worker loads
([test-automation](../automation/test-automation.md#rule-adr-auto-test30)). Tests whose answer cannot depend on the mode, because they read
only the repository's files, carry `source-only` and run once, in the source run
([test-automation](../automation/test-automation.md#rule-adr-auto-test31)); everything that exercises loaded code runs in both. Switching
itself is tested by child-process sequences — source to build, build to source, each mode twice in a row, and a longer alternation — each
asserting the derived mode, the exclusivity check, a call into each module, and a fresh script cache.

### How this is enforced

- **`Catzc.Base.Repository`** — `Get-CatzcRunMode` derives the mode; `Get-CatzcModuleRoot` resolves a module's content under the active code
  root; `Assert-SourceTree` makes source-tree tools fail fast in build mode.
- **`Catzc.Internal.Bootstrap` / `Catzc.Internal.Importer`** — the eviction sweep before a load, `Assert-CatzcRunModeExclusive` after it,
  and the cross-root types guard.
- **`Build-Modules`** — builds same-named modules with their own manifests and merged files, and self-checks the result
  ([platform-bundle](../automation/platform-bundle.md#rule-adr-auto-bundle5)).
- **`Test-Automation` and `Test-CatzcBuild`** — the two test runs over one body of tests; the scope-isolation test, the parity test (each
  built module's public and private function sets equal its source folder's), and the switch-sequence tests.
- **`Measure-NoScriptRootAnchor`** — the analyzer rule that keeps module code from anchoring on its own file's folder.

## Consequences

- One body of modules, one importer, and one body of tests stand behind both the developed form and the shipped form; a defect that shows
  only in the build turns the build run red before anything merges.
- Developers keep one function per file; machines that run the installed package open one function file per module.
- A session is always in exactly one mode, readable from the code root and printed by the load banner; switching is safe in any order.
- A built module's errors point into its merged file; the source markers there map each line back to a source file, and debugging happens
  against source.
- The cost is discipline in module code — content located only through the code root, source-tree tools guarded — enforced by an analyzer
  rule, the asset-dependency gates, and the build run.

## Related

- [platform-bundle](../automation/platform-bundle.md) — the build itself: layout, merge, versioning, install.
- [internal-asset-dependencies](../automation/internal-asset-dependencies.md) — how a module's content is located and tested in both modes.
- [test-automation](../automation/test-automation.md) — the source and build runs and the `source-only` tag.
- [never-depend-on-pwd](../automation/never-depend-on-pwd.md) — the code-root anchor and the `$PSScriptRoot` ban in module function files.
- [script-scope-caching](../automation/powershell/script-scope-caching.md) — the per-module `$script:` caches the modes keep isolated.
- [native-csharp-types](../automation/BCL/native-csharp-types.md) — the one combined types assembly both modes share.
- [one-living-version](../principles/one-living-version.md) — why the build is a mode of the same modules, not a second product.
