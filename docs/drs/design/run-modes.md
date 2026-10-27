# Design: Run modes — source mode and build mode

## Rules: DDR-RUNMODE

### Rule DDR-RUNMODE-TWORUNMODES

A **run mode** is how the toolset is loaded, and there are exactly two. **Source mode** loads every module from its folder in a repository
root's code track, entered by the repository's importer. **Build mode** loads the same modules from a built, installable package — each
module's functions merged into one file — entered by the package's own entry.

- [Two modes, two entry points](#two-modes-two-entry-points)

### Rule DDR-RUNMODE-SAMEMODULEINBOTH

Every module works in both modes and is the same module in both: the same name, public functions, private functions, configs, and assets.
Only its on-disk form differs.

- [The same module in both modes](#the-same-module-in-both-modes)

### Rule DDR-RUNMODE-OWNSCRIPTSCOPE

Each module keeps its own module state in both modes. Built modules are separate modules inside the one package, so no module ever shares
module-level state with another.

- [One scope per module](#one-scope-per-module)

### Rule DDR-RUNMODE-MODEISDERIVED

The mode is derived, never stored: it is `source` when the code root is the repository's own code track, and `build` otherwise.

- [Deriving the mode](#deriving-the-mode)

### Rule DDR-RUNMODE-NEVERCOEXIST

The two modes never coexist in one session. Entering either mode first removes every module loaded from the other mode's root, then asserts
that every loaded catzc module comes from the active root. Switching works in any order and any number of times; the one thing that cannot
be swapped is the loaded C# types assembly, which is reused when both modes' type sources are identical.

- [Switching modes in one session](#switching-modes-in-one-session)

### Rule DDR-RUNMODE-SAMETESTSBOTHMODES

Both modes are tested by the same tests: the source run and the build run execute the same test files up to L2, and a test opts out of the
build run only with the `source-only` tag.

- [One body of tests](#one-body-of-tests)

### Rule DDR-RUNMODE-THREEBUILDKINDS

Build mode has three kinds, told apart by where the code root lives: **temporary** (a devbox build under the output folder, overwritten in
place), **installed** (a package in the engine's per-user or machine module location), and **saved** (a package copied into another root's
vendor folder, versioned with that root). The kind is never stored, and every kind loads through the same importer.

- [Three kinds of build root](#three-kinds-of-build-root)

## Context

Source mode is how the toolset is developed: one function per file, read in place from the repository, with every module's manifest
generated from its folder on import. That form serves the people who edit the code — a directory listing is the module's API, a diff touches
one function, blame has one history per function.

An installable, versioned package is how the toolset is shipped to other machines: carried out of the repository, loaded with no git and no
compile, and opened as few files as possible because real-time antivirus scans every file on a cold import, as it does on an enterprise
machine. Those needs pull the on-disk form the other way.

Treating the package as a separate product would let the two drift: a fix in source that the package lacks, a package-only loader with its
own bugs, a second set of tests that proves something about a copy. Treating it as a **second run mode of the same modules** keeps one body
of code, one importer, and one body of tests behind both forms.

## Decision

The toolset has two run modes over one set of modules. Modules are identical in both, never share script state, cannot coexist across modes
in one session, and are proven in both by running the same tests.

### Two modes, two entry points

In source mode a module is a folder of one-function files in the repository's code track, entered by the repository's importer. In build
mode it is a generated manifest and one merged function file in a build root, entered by the package's own entry. Both entries run in the
caller's scope. A temporary build is entered with the repository still named as the repository root, so the output folder and
repository-relative paths keep resolving there while the code root moves to the build. Every entry ends in the one living importer, so the
load sequence — preferences, vendored modules, types, then modules — is the same in both modes. The engine's entry scripts and file forms are
its own twin's.

Which mode a session is in is read from what actually loaded, never from a flag: it is derived from the code root
([Deriving the mode](#deriving-the-mode)), and a build's manifest file names the version and the commit it was built from.

### Three kinds of build root

`Temporary, installed, saved`

"Build mode" says only that the modules come from a package and not from the source tree. Where that package sits says how long it lives and
who owns it, and the three kinds name those places: a temporary build lives until the next devbox build overwrites it, an installed package
until it is uninstalled or replaced, and a saved package is versioned with the root that vendors it.

The kind is read from where the code root lives, so it cannot disagree with what loaded; the mode is reported and the kind is not, since
nothing has needed it. All three enter through the package's entry, end in the same importer, and are the same modules; a distribution file
such as a package-feed artifact is not a code root until it is installed or saved.

### The same module in both modes

A built module has the same name as its source folder, exports the same public functions, carries the same private functions, and ships the
same `configs/` and `assets/`. The build merges the function files in the same order the source manifest lists them, so load semantics are
identical; the built manifest exports the module's public functions only. Everything that names a module — a config validator run in its
owning module's scope, a module query, a test's mock of one module's call — resolves the same way in both modes.

What makes this hold for content as well as code is that a module locates its own files only through the code root, never through the
folder its source file sits in, and that every such lookup is inventoried and tested in both modes. Tools whose job is the source tree
itself — formatters, dependency tooling, README and dictionary generators — operate on per-function files and git by definition; they assert
that they run in source mode and fail fast in a build rather than reading the wrong tree.

### One scope per module

`One scope per module, never shared`

Merging every module into one scope, flattened, would be the simplest build and the wrong one. Module scope is a contract: each module's
module-level caches belong to it alone, and config validation, mocks, and module queries all name a module. So the package is a container,
not a scope: inside it every source module is its own module with its own state, exactly as in source mode. Two modules that hold a cache
entry of the same name never see each other's value, in either mode, and a scope-isolation test proves it.

### Deriving the mode

`The mode is derived from the code root`

The code root is set once per load by the entry point. A stored mode flag could disagree with the code actually loaded; a derived one
cannot.

### Switching modes in one session

A developer moves between the modes in one shell — the repository's importer, then a build's entry, then the importer again, in any order
and as often as needed. Two copies of one module from different roots in the same session would make every call ambiguous, so the
importer enforces mutual exclusion:

- **Evict before loading.** Before it loads a root, the importer removes every loaded catzc module whose base lies outside that root,
  together with the root's own stale modules. The internal loader modules are reloaded from the new root, so the loader itself always
  belongs to the active mode.
- **Assert after loading.** An exclusivity check runs at the importer tail in both modes and throws, naming the offending modules and both
  roots, when any loaded catzc module lies outside the active code root.
- **Caches reset by construction.** An evicted module takes its state with it, so a switched session never sees a cache from the other
  mode. Vendored modules are reloaded from the active mode's vendor folder.
- **Types are the exception.** A loaded assembly cannot be unloaded. Every build ships the full type set — the same type sources and the
  same hash-named assembly as the source tree, whatever its module selection — so when the sources are unchanged the type identities are the
  same and the loaded assembly is reused in any switch order. The types guard compares the per-file digests of the loaded type set with the
  sources the new root needs; when a source differs, the native-types contract applies: a devbox keeps the loaded types and asks for a fresh
  session, and a pipeline throws.

### One body of tests

`One body of tests proves both modes`

"Every module works in both modes" is a checked property, not a hope. The source run and the build run execute the **same** test files — no
copy, no second set to drift — through the same harness, differing only in the entry script each worker loads. Tests whose answer cannot
depend on the mode, because they read only the repository's files, carry `source-only` and run once, in the source run; everything that
exercises loaded code runs in both. Switching itself is tested by child-process sequences — source to build, build to source, each mode
twice in a row, and a longer alternation — each asserting the derived mode, the exclusivity check, a call into each module, and a fresh
script cache.

### How this is enforced

- **`Catzc.Base.Repository`** — `Get-CatzcRunMode` derives the mode; `Get-CatzcModuleRoot` resolves a module's content under the active code
  root; `Assert-SourceTree` makes source-tree tools fail fast in build mode.
- **`Catzc.Internal.Bootstrap` / `Catzc.Internal.Importer`** — the eviction sweep before a load, `Assert-CatzcRunModeExclusive` after it,
  and the cross-root types guard.
- **`Build-Modules`** — builds same-named modules with their own manifests and merged files, and self-checks the result.
- **`Test-Automation` and `Test-CatzcBuild`** — the two test runs over one body of tests; the scope-isolation test, the parity test (each
  built module's public and private function sets equal its source folder's), and the switch-sequence tests.
- **`Measure-NoScriptRootAnchor`** — the analyzer rule that keeps module code from anchoring on its own file's folder.

## Consequences

- One body of modules, one importer, and one body of tests stand behind both the developed form and the shipped form; a defect that shows
  only in the build turns the build run red before anything merges.
- Developers keep one function per file; machines that run the installed package open one function file per module.
- A session is always in exactly one mode, readable from the code root and reported by `Get-CatzcRunMode`; switching is safe in any order.
- A built module's errors point into its merged file; the source markers there map each line back to a source file, and debugging happens
  against source.
- The cost is discipline in module code — content located only through the code root, source-tree tools guarded — enforced by an analyzer
  rule, the asset-dependency checks, and the build run.

## Related

- [one-living-version](../principles/one-living-version.md) — why the build is a mode of the same modules, not a second product.
