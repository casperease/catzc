# ADR: Platform bundle — the merged, versioned, installable Catzc build

## Rules: ADR-AUTO-BUNDLE

### Rule ADR-AUTO-BUNDLE:1

A **bundle** is the toolset's build: one installable, versioned `Catzc` module under `out/automation/build/Catzc/<version>/`, built by
`Build-Modules` from a selected set of modules (explicit names and/or a profile, closure-expanded over `dependencies.yml`), that loads in a
bare PowerShell 7 session **outside the mono repo** — with no git work tree, no Roslyn compile at load, and no working-tree writes. It is
build mode's code root ([run-modes](../design/run-modes.md)). `Catzc.Base.Exporter` owns its lifecycle: `Build-Modules` builds it (through
the `Invoke-ModuleBuild` engine in `Catzc.Internal.Builder`), `Install-Catzc`/`Export-Catzc` place it, `Assert-CatzcBundle` verifies it.
This is the platform-level form of the build-once artifact ([cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md))
and of a reproducible, content-addressed, self-service artifact ([self-service](../design/self-service.md)).

- [What a bundle is](#what-a-bundle-is)

### Rule ADR-AUTO-BUNDLE:2

The platform anchors on **two roots, not one**: `$env:RepositoryRoot` — the **working root** (where `out/` goes and what repo-relative paths
and git resolve against) — and `$env:CatzcModulesRoot` — where the **loaded catzc code** lives. Config, type, and vendor discovery follow
the code root (`Get-CatzcModulesRoot`), never `RepositoryRoot`. In the mono repo the importer sets them equal, so the split is a no-op; an
install makes them differ, which is exactly what lets the code be carried out of the repo. `CatzcModulesRoot` is a well-known bootstrap
anchor set once ([environment-variables](environment-variables.md#rule-adr-auto-envvar5)).

- [The two roots](#the-two-roots)

### Rule ADR-AUTO-BUNDLE:3

A bundle loads by running the **one living importer** in a `-Bundle` mode, never a forked bootstrap
([one-living-version](../principles/one-living-version.md)). The bundle's `Import-Catzc.ps1` sets the two roots and calls the same
`Invoke-Importer -Bundle` the mono shim's importer is built on; `-Bundle` honours the pre-set `CatzcModulesRoot`, forces the janitors off,
reads each module's prebuilt manifest, and loads the prebuilt combined-types assembly without invoking Roslyn. Reusing the importer
reproduces the exact tested load sequence — the C# types and their accelerators register **before** any module loads
([native-csharp-types](BCL/native-csharp-types.md#rule-adr-auto-types10)) — which a single declarative module manifest cannot guarantee.

- [The bundle boots through the importer](#the-bundle-boots-through-the-importer)

### Rule ADR-AUTO-BUNDLE:4

A bundle carries the **runtime payload in merged form**. Every selected module is its own folder holding a generated `<Module>.psd1`
(`NestedModules` = the one merged file, `FunctionsToExport` = the module's public functions only), a generated `<Module>.functions.ps1` that
merges the module's `private/` and root function files — named apart from the module, so the nested script module never shares the manifest
module's name — and the module's side folders (`configs/`, `assets/`, and the `types/` sources) copied verbatim — never its `tests/`. Beside
the modules sit the `.internal` loader, the vendored dependencies per policy under `.vendor/`, the **full** combined-types DLL under
`.compiled/` with the unselected modules' type sources under `.compiled/types/<Module>/`, the top-level `Catzc.psd1`, `Catzc.psm1`, and
`Import-Catzc.ps1`, and `build.json`. The payload is deliberately **broader** than the protection `live` aspect
([module-aspects](../design/module-aspects.md)) — that aspect excludes `assets/` for marker isolation, but a running module needs its
`assets/`. Shipping is default-deny: the `tests/` surface never travels.

- [The runtime payload](#the-runtime-payload)

### Rule ADR-AUTO-BUNDLE:5

A build is **immutable and content-addressed**: the same commit yields a byte-identical build — merged files, manifests, and the types DLL —
and an identical durable-SHA content hash ([durable-sha-globs](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)) over all of it. Every
build ships the **full** type set whatever its module selection, so its `typesHash` (the combined hash of every `types/*.cs` source, which
names the DLL) equals the source tree's, and the build copies the source tree's `Catzc.Types.<typesHash>.dll` instead of compiling — it
compiles only when that DLL is missing. Each bundle carries a `build.json` provenance record (version, content hash, `typesHash`, the
type-source list, source commit, modules). `Assert-CatzcBundle` is the integrity gate: it re-verifies the recorded hash, that no `tests/`
leaked in, that exactly one types DLL is present and its name matches `typesHash`, that every module has its manifest and merged
`.functions.ps1`, that every manifest export resolves to a function in its merged file, and that every inventoried internal asset is present
([internal-asset-dependencies](internal-asset-dependencies.md#rule-adr-auto-assetdep4)) — collecting every violation. `Build-Modules` runs
it as a self-check on its own output.

- [The immutable, verified artifact](#the-immutable-verified-artifact)

### Rule ADR-AUTO-BUNDLE:6

An install is **two artifacts in two places**. `Export-Catzc -Root <dir>` copies the build to `<dir>/.vendor/Catzc/<version>/` and writes a
root `importer.ps1` at the **destination root** that dot-sources the installed `Import-Catzc.ps1` with `-RepositoryRoot <dir>`, so the
working root is the destination (where `out/` resolves and is writable) and the code root is the installed module.
`Install-Catzc -Scope CurrentUser` copies the build into the user's module path instead, so `Import-Module Catzc` works from any shell;
`Export-Catzc -To nuget` packs it into `out/automation/packages/` for a local-path `Install-PSResource`, with the vendored dependencies
riding inside its `.vendor/` rather than as `RequiredModules`. Every install is idempotent
([idempotent-state-functions](idempotent-state-functions.md)) — a re-install with a matching content hash refreshes only the root importer —
and the source build is verified before the destination is touched.

- [The two-part install](#the-two-part-install)

### Rule ADR-AUTO-BUNDLE:7

`Build-Modules -Version` defaults to `auto`, resolved by `Resolve-CatzcBuildVersion`. A devbox (source-mode) build is the fixed **`6.6.666`
placeholder** (`exporter.yml`'s `direct_install_version`), announced by a yellow `Write-Message` notice that real versions come only from
the pipeline. A pipeline export gets a **calculated, reproducible version**: `MAJOR.MINOR` from `exporter.yml`'s `version`, and `PATCH` the
first-parent commit count of the built commit — so the same commit always gets the same version and versions rise along `main`. An explicit
`-Version` is honoured when it is `MAJOR.MINOR.PATCH`, and a pipeline build that names `6.6.666` is rejected. Every version is numeric so
the `Catzc/<version>/` folder is a valid module version. Export options — profile, vendor policy, versions — are configuration read through
`Get-Config` ([sensible-defaults](sensible-defaults.md)), so a build's shape is a reviewed edit to one file and a test can substitute a
fixture config through the same seam.

- [Versions: a local placeholder, a calculated pipeline version](#versions-a-local-placeholder-a-calculated-pipeline-version)

### Rule ADR-AUTO-BUNDLE:8

A bundle is a **session, not a passive library**. Loading it establishes the catzc session — it sets the global error/warning preferences
exactly as the mono importer does ([error-handling](powershell/error-handling.md)), because catzc functions assume terminating semantics —
and it writes only under the working root's `out/`, never the code it was built from. Publishing a package beyond the local disk is the
release workflow's act ([github-release](../github/github-release.md)), not something loading or building a bundle does.

- [A session, not a library](#a-session-not-a-library)

## Context

The catzc platform is developed in source mode: dot-sourcing `importer.ps1` at the repository root reads the automation tree in place, one
function per file, and everything anchors on a repository that is both the working root and the location of the code. That form is right for
the people who edit the code and wrong for the machines that only run it. A machine that runs the toolset wants it **installed** — carried
to another folder (another repository's `.vendor`, a work directory, the user's module path) and run there as a reusable tool rather than a
repository you are inside — and it wants the install to load fast, including on a cold import behind real-time antivirus that scans every
file on first open ([effective-in-enterprises](effective-in-enterprises.md)).

The repository holds most of the pieces: a typed module model with a dependency closure, the durable-SHA identity primitives, the
combined-types compile, a manifest emitter, and the one importer. The concept that ties them together is the **bundle** — the build — plus
the two mechanisms that make the platform relocatable without disturbing source mode: the anchor split, and a bundle mode on the one living
importer.

## Decision

Build catzc as a **bundle**: a versioned, content-addressed, self-contained `Catzc` module, each inner module merged into one file, that
installs to another root and loads there with no git and no Roslyn, owned by `Catzc.Base.Exporter`.

### What a bundle is

A bundle is the platform, made portable. `Build-Modules` takes the selected modules — named explicitly, by profile, or both, then
closure-expanded so every dependency comes along — and writes one installable module root, `out/automation/build/Catzc/<version>/` by
default. Inside it every selected module is **its own PowerShell module of the same name**: same public functions, same private functions,
same configs and assets, its own `$script:` scope ([run-modes](../design/run-modes.md)). Only its on-disk form differs: one manifest and one
merged function file instead of a folder of function files. It is small (the `tests/` surface is dropped), fast (a few dozen files to open,
no compile, no discovery drift), and sharable (one versioned folder). It is distinct from the repository it is built from: an install is not
a repository, has no `.git`, and ships no `infrastructure/`, `pipelines/`, or `.cspell/` — the functions that operate on the source tree
assert that they run there (`Assert-SourceTree`) and say so in a build, and a trimmed profile can exclude them.

### The two roots

The platform separates the **working root** from the **code root**. `RepositoryRoot` is where the user runs — the anchor for `out/`,
repo-relative paths, and git. `CatzcModulesRoot` is where the loaded catzc code lives — the anchor every config, type, and vendor scan
follows, through `Get-CatzcModulesRoot`, and the root `Get-CatzcModuleRoot` resolves a module's own content under. In the mono repo the
importer derives `CatzcModulesRoot` as `<RepositoryRoot>/automation`, so the two coincide. In an install they diverge: the working root is
the destination folder, and the code root is the installed module, which may sit anywhere. This split is the whole reason the platform can
be relocated — a scan that anchored on `RepositoryRoot` would look in the wrong place the moment the code and the work were not the same
tree.

### The bundle boots through the importer

A bundle does not carry its own loader. Its `Import-Catzc.ps1` — a checked-in, authored file under `automation/.internal/assets/`, copied
verbatim into the build — sets the two anchors and calls the same `Invoke-Importer` the mono shim calls, in a `-Bundle` mode; the build's
`Catzc.psm1` dot-sources the same file, so `Import-Module Catzc` and dot-sourcing `Import-Catzc.ps1` set up the same session. This is not
merely to avoid a second copy of the load logic — it is load-order-correct. The C# type accelerators the platform uses
(`[Catzc.Module.Depm]`) are registered by catzc's own code before any module loads, and any module that names an accelerator in a type
constraint at load time needs it registered first. The importer sequences this — types and accelerators, then the module loop — and a single
declarative manifest that listed every module as a nested module could not, besides collapsing every module's private state into one shared
scope. So the bundle reuses the importer, and `-Bundle` only changes what it does to the filesystem: janitors off, each module's prebuilt
manifest read rather than generated, the prebuilt DLL loaded rather than compiled, the pre-set code root honoured.

### The runtime payload

What ships is what a module needs to **run**. For each selected module, `Build-Modules` merges the function files into one
`<Module>.functions.ps1` — `private/*.ps1` in ordinal order, then the root `*.ps1` in ordinal order, the same order the source manifest's
`NestedModules` uses, so load semantics are identical — each file verbatim behind a `# source: automation/<Module>/<path>` marker line, so
an error line in the merged file maps back to its source file. The module's manifest is generated by the same canonical emitter source mode
uses, listing that one file and exporting only the public functions; privates stay internal. The side folders travel verbatim, including
`assets/` (install scripts, hook starters, packaged data) and the `types/` sources the load-time types guard re-verifies. Before merging,
the build asserts its preconditions on every source file — exactly one function named for the file, no top-level statements — and fails with
the full list.

The infrastructure is built or copied, never fetched. The combined-types DLL always covers the **full** type set, whatever the module
selection: the selected modules' `types/*.cs` travel in their folders and the rest under `.compiled/types/<Module>/`, so the load-time types
guard re-verifies the same hash in every build, and a session that switches between modes always finds the same type identities loaded. The
DLL is copied from the source tree's `.compiled/` when its hash matches, and compiled only when it is missing. The vendored modules are
copied verbatim from `.vendor/` per `vendor_policy` — `runtime` ships `powershell-yaml` only; `full` also ships Pester and PSScriptAnalyzer,
which the build run needs — and are never re-downloaded or republished. Default-deny keeps the verification surface out: no `tests/` tree
travels.

### The immutable, verified artifact

A bundle is content-addressed. `Build-Modules` writes its output canonically — UTF-8 without BOM, LF, one trailing newline, through
`Write-FileIfChanged` — so rebuilding a commit rewrites nothing, the DLL included, because it is the same copied file — and computes a
durable SHA over the whole payload with the same recipe the globsets use. The DLL's own name carries the `typesHash`, so which sources it
was compiled from is proven by hash. The content hash, `typesHash`, type-source list, source commit, version, and module list travel in
`build.json`, which is excluded from the hash it carries. `Assert-CatzcBundle` closes the loop: given any bundle, it recomputes the hash and
checks it against `build.json`, confirms no test file leaked in, confirms exactly one types DLL whose name matches `typesHash`, confirms
every module's manifest and merged file, confirms every manifest export resolves to a function in its merged file, and confirms every
internal asset the code depends on is present — throwing with the full list of what is wrong. A build verifies itself with it, and an
install verifies its source with it.

### The two-part install

An install answers two questions that are usually one: **where do I run**, and **where does the code live**. So `Export-Catzc -Root <dir>`
writes two artifacts. The module — the build and its `build.json` — goes to a modules location under the destination root
(`<dir>/.vendor/Catzc/<version>/`). A root `importer.ps1` goes to the destination root itself and dot-sources the installed
`Import-Catzc.ps1` with `-RepositoryRoot <dir>`: the destination becomes `RepositoryRoot` (so `out/` is the user's writable working
directory, never a read-only module store), and the installed module becomes `CatzcModulesRoot`. Dot-sourcing it loads the whole platform.
Re-installing the same content is a no-op on the module and only rewrites the root importer, and the source is verified before the
destination is changed.

Two other placements use the same build. `Install-Catzc -Scope CurrentUser` copies it into the user's module path
(`…/Modules/Catzc/<version>/`), after which `Import-Module Catzc` loads it from any shell. `Export-Catzc -To nuget` packs the build folder
into `out/automation/packages/`; a client registers that folder as a PSResource repository and runs `Install-PSResource Catzc`. The vendored
dependencies ride inside the package's own `.vendor/`, so nothing is republished or fetched at install.

### Versions: a local placeholder, a calculated pipeline version

A build on a devbox is a local convenience, not a release, so it carries the fixed `6.6.666` placeholder and overwrites in place — an
obviously-unreal number that reads as "built locally" — and `Build-Modules` says so with a yellow `Write-Message` line. It is never a
`Write-Warning`, which terminates under the catzc session's preferences ([error-handling](powershell/error-handling.md)). A pipeline export
gets a real version, and that version is **calculated, not chosen**: `MAJOR.MINOR` is the reviewed `version` in `exporter.yml`, and `PATCH`
is the first-parent commit count of the built commit (`git rev-list --first-parent --count HEAD`, which needs the full history the pipelines
fetch, [durable-sha-globs](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)). The same commit therefore always gets the same version —
build once, version once ([cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)) — and versions
increase monotonically along `main` without a counter to store. The placeholder never leaves a devbox: a pipeline build that names it
explicitly is rejected. Every version, along with the profile and vendor policy, is declared in one `exporter.yml` read through `Get-Config`
— the single place the repository states how it wants to export itself, validated on load and substitutable by a fixture in tests.

### A session, not a library

Loading a bundle establishes a catzc session, matching the mono importer: it sets the global error and warning preferences to terminating,
because the platform's functions are written to fail fast and assume that environment. A bundle is therefore a way to run catzc, not a
passive library imported beside other code. It confines its writes to the working root's `out/`, so an install never mutates the tree it was
built from. The one direction beyond disk — publishing the NuGet package to GitHub or the PowerShell Gallery — is a deliberate, manual
release act governed by its own workflow ([github-release](../github/github-release.md)), never a side effect of building or loading.

### How this is enforced

- **`Catzc.Base.Repository`** exposes `Get-CatzcModulesRoot` (the code-root accessor) and `Get-CatzcModuleRoot` (a module's folder under it)
  beside `Get-RepositoryRoot` (the working root); the importer sets `$env:CatzcModulesRoot`, and `Catzc.Base.Config`'s discovery scan reads
  it.
- **`Catzc.Internal.Importer`** carries the `-Bundle` mode (honour the pre-set code root, force the janitors off, read prebuilt manifests,
  load the prebuilt DLL) that the build's `Import-Catzc.ps1` calls.
- **`Catzc.Internal.Builder`** is the engine (`Invoke-ModuleBuild`): closure, merge, manifests, types compile, vendor and `.internal` copy,
  `build.json`.
- **`Catzc.Base.Exporter`** owns the artifact: `Build-Modules`, `Resolve-CatzcBuildVersion`, `Install-Catzc`, `Export-Catzc`,
  `Assert-CatzcBundle`, `Get-CatzcContentHash`, and the `exporter.yml` config. `Build-Modules` self-checks with `Assert-CatzcBundle`; the
  walking-skeleton integrity test builds the full profile, loads it in a child `pwsh`, and calls into every module.
- **The build run** (`Test-CatzcBuild`, [test-automation](test-automation.md)) runs the same tests against the build that the source run
  runs against source.
- **Code review** keeps the split honest: a scan of catzc's own code anchored on `RepositoryRoot` rather than `CatzcModulesRoot`, or a
  bundle loader that forks the importer, is rejected against this ADR.

## Consequences

- The platform is installable: `Build-Modules` builds it, `Export-Catzc -Root <dir>` installs it beside a working root, and `Install-Catzc`
  or a local-path `Install-PSResource` installs it as an ordinary module.
- Source mode is unaffected: the two anchors coincide there, `-Bundle` is off, and developers keep one function per file.
- A cold import of an installed build opens one function file per module, not one per function, so the per-file antivirus cost shrinks with
  it.
- A bundle is reproducible and self-describing: the content hash, `typesHash`, version, and `build.json` make "which build is installed" a
  single verifiable answer, and `Assert-CatzcBundle` catches a corrupt or drifted install.
- Error line numbers inside a built module point into the merged file; the `# source:` markers map them back, and debugging happens against
  source.
- The cost is one more concept (the bundle), one more anchor (`CatzcModulesRoot`), and the discipline that catzc's own code finds its
  content through the code root — bounded, and enforced by an analyzer rule and the build run.

## Related

- [run-modes](../design/run-modes.md) — source mode and build mode; the bundle is build mode's code root.
- [one-living-version](../principles/one-living-version.md) — why the bundle reuses the one importer instead of forking a loader.
- [self-service](../design/self-service.md), [cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md) — the
  content-addressed artifact and build-once/deploy-many this specialises.
- [internal-asset-dependencies](internal-asset-dependencies.md) — the asset inventory the build gate checks.
- [module-aspects](../design/module-aspects.md) — the live/tests aspect the runtime payload is deliberately broader than.
- [durable-sha-globs](../flow/durable-sha-globs.md) — the durable-SHA identity the content hash reuses.
- [native-csharp-types](BCL/native-csharp-types.md) — the combined assembly and the accelerator load order the bundle mode preserves.
- [use-ps1-not-psm1](powershell/use-ps1-not-psm1.md), [one-function-per-file](powershell/one-function-per-file.md) — the source rules the
  merged `<Module>.functions.ps1` is generated from.
- [environment-variables](environment-variables.md) — the well-known-anchor rule `CatzcModulesRoot` follows.
- [github-release](../github/github-release.md) — the release workflow that publishes the build under its calculated version.
- [conventional-folders](../repository/conventional-folders.md), [dedicated-output-directory](../repository/dedicated-output-directory.md) —
  the `out/` and `.vendor/` conventions the artifact uses.
