# ADR: Platform bundle — the merged, versioned, installable Catzc build

## Rules: ADR-AUTO-BUNDLE

### Rule ADR-AUTO-BUNDLE:1

A **bundle** is the toolset's build: one installable, versioned `Catzc` package of one **named bundle** — an `exporter.yml` `bundles` entry
with its own profile, version line, and vendor policy — under `out/pwsh/built/<bundle>/Catzc/<version>/`, built by `Build-Modules` from the
bundle's profile (or, for an experiment or a test, explicit names and/or a profile), closure-expanded over `dependencies.yml`, that loads in
a fresh session of its engine **outside the mono repo** — with no git work tree, no compile at load, and no working-tree writes. It is build
mode's code root ([run-modes](../design/run-modes.md)). `Catzc.Base.Exporter` owns its lifecycle: `Build-Modules` builds it (through the
`Invoke-ModuleBuild` engine in `Catzc.Internal.Builder`), `Install-Catzc`/`Export-Catzc` place it, `Assert-CatzcBundle` verifies it. This is
the platform-level form of a reproducible, content-addressed, self-service artifact ([self-service](../design/self-service.md)), built once.

- [What a bundle is](#what-a-bundle-is)

### Rule ADR-AUTO-BUNDLE:2

The platform anchors on **two roots, not one**: `RepositoryRoot` — the **working root** (where `out/` goes and what repo-relative paths and
git resolve against) — and `CatzcModulesRoot` — where the **loaded catzc code** lives, both environment variables. Config, type, and vendor
discovery follow the code root (`Get-CatzcModulesRoot`), never `RepositoryRoot`. In the mono repo the importer sets them equal, so the split
is a no-op; an install makes them differ, which is exactly what lets the code be carried out of the repo. `CatzcModulesRoot` is a well-known
bootstrap anchor set once ([environment-variables](environment-variables.md#rule-adr-auto-envvar5)).

- [The two roots](#the-two-roots)

### Rule ADR-AUTO-BUNDLE:3

A bundle loads by running the **one living importer** in its bundle mode, never a forked bootstrap
([one-living-version](../principles/one-living-version.md)). The bundle's entry sets the two roots and runs the same importer the mono
repo's entry runs; the bundle mode honours the pre-set `CatzcModulesRoot`, forces the janitors off, reads each module's prebuilt manifest,
and loads the prebuilt combined-types assembly without compiling. Reusing the importer reproduces the exact tested load sequence — the C#
types register **before** any module loads ([native-csharp-types](BCL/native-csharp-types.md)) — which a single declarative package
description cannot guarantee.

- [Booting through the importer](#booting-through-the-importer)

### Rule ADR-AUTO-BUNDLE:5

A build is **immutable and content-addressed**: the same commit yields a byte-identical build on any machine — merged files, manifests, and
the types DLL — and an identical durable-SHA content hash over all of it. A build ships **the files git tracks** — and, on a devbox, the
untracked files git does not ignore — never an ignored one, and writes each as git stores it: a file git holds with LF-only line endings is
written LF-only, whatever line endings the checkout wrote; every other file is a byte copy. Every build ships the **full** type set whatever
its module selection, so its `typesHash` (the combined hash of every `types/*.cs` source, which names the DLL) equals the source tree's; the
type sources follow that set, as the DLL does, and the build copies the source tree's `Catzc.Types.<typesHash>.dll` instead of compiling —
it compiles only when that DLL is missing. Before it writes anything the build proves its selection closed against the code itself, not only
against `dependencies.yml`: every call a selected module makes to a catzc function, and every config it reads by a literal name, lands in a
selected module (an owner-scoped read, which reads only the owners present, is exempt), and every inventoried internal asset is present
([internal-asset-dependencies](internal-asset-dependencies.md#rule-adr-auto-assetdep4)). Each bundle carries a `build.json` provenance
record (bundle, version, content hash, `typesHash`, the type-source list, source commit, whether the tree differed from that commit,
modules); a pipeline refuses to build a tree that differs from its commit. `Assert-CatzcBundle` is the integrity guard: it re-verifies the
recorded hash, that no `tests/` leaked in, that exactly one types DLL is present and its name matches `typesHash`, that every module has its
manifest and its one merged function file, and that every manifest export resolves to a function in its merged file — collecting every
violation. `Build-Modules` runs it as a self-check on its own output.

- [The verified artifact](#the-verified-artifact)

### Rule ADR-AUTO-BUNDLE:6

An install is **two artifacts in two places**. `Export-Catzc -Root <dir>` copies the build to `<dir>/.vendor/Catzc/<version>/` and writes a
root importer entry at the **destination root** that loads the installed build's entry with `<dir>` as the working root, so the working root
is the destination (where `out/` resolves and is writable) and the code root is the installed build. The other placements — the user's own
module location, and a local package — carry the same build with its vendored dependencies inside it, never as dependencies fetched at
install. Every install is idempotent ([idempotent-state-functions](idempotent-state-functions.md)) — a re-install with a matching content
hash refreshes only the root importer entry — and the source build is verified before the destination is touched.

- [The two-part install](#the-two-part-install)

### Rule ADR-AUTO-BUNDLE:7

`Build-Modules -Version` defaults to `auto`, resolved by `Resolve-CatzcBuildVersion`. A devbox (source-mode) build is the fixed **`6.6.666`
placeholder** (`exporter.yml`'s `direct_install_version`), announced by a yellow `Write-Message` notice that real versions come only from
the pipeline. A pipeline export gets a **calculated, reproducible version**: `MAJOR.MINOR` from the bundle's own `version` in
`exporter.yml`, and `PATCH` the first-parent commit count of the built commit — so the same commit always gets the same version and versions
rise along `main`. Each bundle has its own version line, and no bundle's version moves another's. An explicit `-Version` is honoured when it
is `MAJOR.MINOR.PATCH`, and a pipeline build that names `6.6.666` is rejected. Every version is numeric so the `Catzc/<version>/` folder is
a valid package version. Export options — the bundles, each with its profile, vendor policy, and version line, and the default bundle — are
configuration read through `Get-Config` ([sensible-defaults](sensible-defaults.md)), so a build's shape is a reviewed edit to one file and a
test can substitute a fixture config through the same seam.

- [Versions](#versions)

### Rule ADR-AUTO-BUNDLE:8

A bundle is a **session, not a passive library**. Loading it establishes the catzc session — the same session settings the mono importer
sets, under which every error and every warning terminates, because catzc functions assume terminating semantics — and it writes only under
the working root's `out/`, never the code it was built from. Publishing a package beyond the local disk is the release workflow's act, not
something loading or building a bundle does.

- [A session, not a library](#a-session-not-a-library)

## Context

The catzc platform is developed in source mode: loading the importer at the repository root reads the automation tree in place, one function
per file, and everything anchors on a repository that is both the working root and the location of the code. That form is right for the
people who edit the code and wrong for the machines that only run it. A machine that runs the toolset wants it **installed** — carried to
another folder (another repository's `.vendor`, a work directory, the user's module location) and run there as a reusable tool rather than a
repository you are inside — and it wants the install to load fast, including on a cold import behind real-time antivirus that scans every
file on first open ([effective-in-enterprises](effective-in-enterprises.md)).

The repository holds most of the pieces: a typed module model with a dependency closure, the durable-SHA identity primitives, the
combined-types compile, a manifest emitter, and the one importer. The concept that ties them together is the **bundle** — the build — plus
the two mechanisms that make the platform relocatable without disturbing the source mode: the anchor split, and a bundle mode on the one
living importer.

This ADR is the bundle in words that hold for any engine. How it is realised in pwsh — the merged module form, the package module, and the
build's entry script — is [dynamic-module-manifests](../pwsh/dynamic-module-manifests.md) and [pwsh-engine](../pwsh/pwsh-engine.md).

## Decision

Build catzc as a **bundle**: a versioned, content-addressed, self-contained `Catzc` package, each inner module merged into one file, that
installs to another root and loads there with no git and no compile, owned by `Catzc.Base.Exporter`.

### What a bundle is

A bundle is the platform, made portable. The repository declares its bundles by name in `exporter.yml` — `full`, and smaller ones such as
`azure` or `minimal` — each a release identity of its own. `Build-Modules` takes a bundle's modules — its profile, or for an experiment
modules named explicitly, by profile, or both — closure-expands them so every dependency comes along, and writes one installable package
root, `out/pwsh/built/<bundle>/Catzc/<version>/` by default, so two bundles never share a folder. Inside it every selected module is **its
own module of the same name**: same public functions, same private functions, same configs and assets, its own module state
([run-modes](../design/run-modes.md)). Only its on-disk form differs: one manifest and one merged function file instead of a folder of
function files. It is small (the `tests/` surface is dropped), fast (a few dozen files to open, no compile, no discovery drift), and
sharable (one versioned folder). It is the platform-level form of the build-once artifact; the related flow decision is
[cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md). It is distinct from the repository it is built from: an
install is not a repository, has no `.git`, and ships no `infrastructure/`, `pipelines/`, or `.cspell/` — the functions that operate on the
source tree assert that they run there (`Assert-SourceTree`) and say so in a build, and a trimmed profile can exclude them.

### The two roots

The platform separates the **working root** from the **code root**. `RepositoryRoot` is where the user runs — the anchor for `out/`,
repo-relative paths, and git. `CatzcModulesRoot` is where the loaded catzc code lives — the anchor every config, type, and vendor scan
follows, through `Get-CatzcModulesRoot`, and the root `Get-CatzcModuleRoot` resolves a module's own content under. In the mono repo the
importer derives `CatzcModulesRoot` as `<RepositoryRoot>/automation`, so the two coincide. In an install they diverge: the working root is
the destination folder, and the code root is the installed build, which may sit anywhere. This split is the whole reason the platform can be
relocated — a scan that anchored on `RepositoryRoot` would look in the wrong place the moment the code and the work were not the same tree.

### Booting through the importer

`The bundle boots through the importer`

A bundle does not carry its own loader. Its entry — a checked-in, authored file under `pwsh/.internal/assets/`, copied verbatim into the
build — sets the two anchors and runs the same importer the mono repo's entry runs, in its bundle mode. This is not merely to avoid a second
copy of the load logic — it is load-order-correct. The C# types the platform uses are registered by catzc's own code before any module
loads, and a module that names one of them at load time needs it registered first. The importer sequences this — types, then the module loop
— and a single declarative package description that listed every module as part of one package could not, besides collapsing every module's
private state into one shared scope. So the bundle reuses the importer, and the bundle mode only changes what it does to the filesystem:
janitors off, each module's prebuilt manifest read rather than generated, the prebuilt DLL loaded rather than compiled, the pre-set code
root honoured.

### The runtime payload

What ships is what a module needs to **run**. For each selected module, `Build-Modules` merges the function files into one file, in the
order the source tree loads them, each source file verbatim behind a marker line that names it, so an error line in the merged file maps
back to its source file; the module's manifest is generated by the same emitter the source mode uses, and exports only the public functions.
The side folders travel verbatim, including `assets/` (install scripts, hook starters, packaged data) and the `types/` sources the load-time
types guard re-verifies. Before merging, the build asserts its preconditions on every source file — exactly one function named for the file,
no top-level statements — and fails with the full list.

The infrastructure is built or copied, never fetched. The combined-types DLL always covers the **full** type set, whatever the module
selection: the selected modules' `types/*.cs` travel in their folders and the rest under `.compiled/types/<Module>/`, so the load-time types
guard re-verifies the same hash in every build, and a session that switches between modes always finds the same type identities loaded. The
DLL is copied from the source tree's `.compiled/` when its hash matches, and compiled only when it is missing. The vendored dependencies are
copied verbatim from `.vendor/` per `vendor_policy`, and are never re-downloaded or republished. Default-deny keeps the verification surface
out: no `tests/` tree travels. The exact form of the payload in pwsh is
[dynamic-module-manifests](../pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5).

### The verified artifact

`The immutable, verified artifact`

A bundle is content-addressed. Its input is a commit, not a checkout: the build takes the files git tracks and writes each as git stores it,
so an ignored `bin/` or `obj/`, or a Windows checkout's CRLF line endings, never change what ships — a file git holds LF-only is written
LF-only, and every other file (CRLF-stored, binary, a vendored script whose signature covers its bytes) is a byte copy. On a devbox the
untracked files git does not ignore ship too, because they are the work in progress a developer builds to try; they make the tree dirty, and
a pipeline refuses a dirty tree, so a released bundle is always exactly its commit. The type sources and the DLL follow the type set the
DLL's name proves, which on a clean tree is the commit's. `Build-Modules` writes its generated output canonically — UTF-8 without BOM, LF,
one trailing newline, through `Write-FileIfChanged` — so rebuilding a commit rewrites nothing, the DLL included, because it is the same
copied file — and computes a durable SHA over the whole payload with the same recipe the globsets use (the related flow rule is
[ADR-FLOW-CD-GLOBS#5](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)). The same commit therefore hashes the same on every OS, which
the CI pipeline proves by building on each and comparing.

A partial bundle is only as good as its closure. `dependencies.yml` leaves a module it does not list unconstrained, so the build does not
take the declared closure on trust: before it writes anything it walks the code of the selected modules and fails, with the full list, on a
call to a catzc function or a literal config read that lands in a module the bundle leaves out. The fix is to declare the dependency, so the
closure brings the owner in, or to move what is read to where it belongs. The same pre-write pass checks every inventoried internal asset.

The DLL's own name carries the `typesHash`, so which sources it was compiled from is proven by hash. The bundle, content hash, `typesHash`,
type-source list, source commit, whether the tree differed from that commit, version, and module list travel in `build.json`, which is
excluded from the hash it carries. A devbox may build a tree with uncommitted changes, and `build.json` says so; a pipeline refuses, so a
released bundle is always exactly its commit. `Assert-CatzcBundle` closes the loop: given any bundle, it recomputes the hash and checks it
against `build.json`, confirms no test file leaked in, confirms exactly one types DLL whose name matches `typesHash` and that the shipped
type sources hash to it, confirms every module's manifest and merged file, and confirms every manifest export resolves to a function in its
merged file — throwing with the full list of what is wrong. A build verifies itself with it, and an install verifies its source with it.

A bundle is an engine carried to other environments, so its size is checked, not hoped for. A bundle may state footprint limits, `max_files`
and `max_bytes`, in its `exporter.yml` entry; `Build-Modules` measures every build and fails one that holds more, naming the heaviest
top-level folders so the message says where the weight is. A limit a bundle does not state is not checked, and raising one is a reviewed
edit.

### The two-part install

An install answers two questions that are usually one: **where do I run**, and **where does the code live**. So `Export-Catzc -Root <dir>`
writes two artifacts. The build and its `build.json` go to a modules location under the destination root (`<dir>/.vendor/Catzc/<version>/`).
A root importer entry goes to the destination root itself and loads the installed build's entry with `<dir>` as the working root: the
destination becomes `RepositoryRoot` (so `out/` is the user's writable working directory, never a read-only module store), and the installed
build becomes `CatzcModulesRoot`. Loading that entry loads the whole platform. Re-installing the same content is a no-op on the build and
only rewrites the root importer entry, and the source is verified before the destination is changed.

Two other placements use the same build: `Install-Catzc` copies it into the user's own module location, and `Export-Catzc -To nuget` packs
it as a local package. The vendored dependencies ride inside the build's own `.vendor/`, so nothing is republished or fetched at install.

### Versions

`Versions: a local placeholder, a calculated pipeline version`

A build on a devbox is a local convenience, not a release, so it carries the fixed `6.6.666` placeholder and overwrites in place — an
obviously-unreal number that reads as "built locally" — and `Build-Modules` says so with a yellow `Write-Message` line. It is never a
warning, which terminates in a catzc session (ADR-AUTO-BUNDLE#8). A pipeline export gets a real version, and that version is **calculated,
not chosen**: `MAJOR.MINOR` is the bundle's own reviewed `version` in `exporter.yml` — the repository is a mono repo, so each bundle has its
own version line and no bundle's version moves another's — and `PATCH` is the first-parent commit count of the built commit
(`git rev-list --first-parent --count HEAD`, which needs the full history the pipelines fetch,
[durable-sha-globs](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)). The same commit therefore always gets the same version — build
once, version once ([cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)) — and versions
increase monotonically along `main` without a counter to store. The placeholder never leaves a devbox: a pipeline build that names it
explicitly is rejected. Every bundle, with its profile, vendor policy, and version line, is declared in one `exporter.yml` read through
`Get-Config` — the single place the repository states how it wants to export itself, validated on load and substitutable by a fixture in
tests.

### A session, not a library

Loading a bundle establishes a catzc session, matching the mono importer: errors and warnings terminate, because the platform's functions
are written to fail fast and assume that environment. A bundle is therefore a way to run catzc, not a passive library imported beside other
code. It confines its writes to the working root's `out/`, so an install never mutates the tree it was built from. The one direction beyond
disk — publishing the package to GitHub or a public feed — is a deliberate, manual release act governed by its own workflow
([github-release](../github/github-release.md)), never a side effect of building or loading.

### How this is enforced

- **`Catzc.Base.Repository`** exposes `Get-CatzcModulesRoot` (the code-root accessor) and `Get-CatzcModuleRoot` (a module's folder under it)
  beside `Get-RepositoryRoot` (the working root); the importer sets `CatzcModulesRoot`, and `Catzc.Base.Config`'s discovery scan reads it.
- **`Catzc.Internal.Importer`** carries the bundle mode (honour the pre-set code root, force the janitors off, read prebuilt manifests, load
  the prebuilt DLL) that the build's entry calls.
- **`Catzc.Internal.Builder`** is the engine (`Invoke-ModuleBuild`): the tracked source and its line-ending rule, closure (declared and
  proven against the code), merge, manifests, types compile, vendor and `.internal` copy, `build.json`. Its integrity tests build a fixture
  repository checked out with CRLF and with LF and prove the same hash.
- **The CI pipeline** builds the `full` bundle on Windows, Linux, and macOS and fails when the content hashes differ.
- **`Catzc.Base.Exporter`** owns the artifact: `Build-Modules`, `Resolve-CatzcBuildVersion`, `Install-Catzc`, `Export-Catzc`,
  `Assert-CatzcBundle`, `Get-CatzcContentHash`, and the `exporter.yml` config with its named bundles (`ExporterConfig`, `ExporterBundle`,
  which validate it on load). `Build-Modules` self-checks with `Assert-CatzcBundle`; the walking-skeleton integrity test builds the full
  profile, loads it in a fresh session, and calls into every module.
- **The build run** (`Test-CatzcBuild`, [test-automation](test-automation.md)) runs the same tests against the build that the source run
  runs against source.
- **Code review** keeps the split honest: a scan of catzc's own code anchored on `RepositoryRoot` rather than `CatzcModulesRoot`, or a
  bundle loader that forks the importer, is rejected against this ADR.

## Consequences

- The platform is installable: `Build-Modules` builds it, `Export-Catzc -Root <dir>` installs it beside a working root, and `Install-Catzc`
  or a local package installs it as an ordinary module.
- Source mode is unaffected: the two anchors coincide there, the bundle mode is off, and developers keep one function per file.
- A cold import of an installed build opens one function file per module, not one per function, so the per-file antivirus cost shrinks with
  it.
- A bundle is reproducible and self-describing: the content hash, `typesHash`, version, and `build.json` make "which build is installed" a
  single verifiable answer, and `Assert-CatzcBundle` catches a corrupt or drifted install.
- Error line numbers inside a built module point into the merged file; the source markers map them back, and debugging happens against
  source.
- The cost is one more concept (the bundle), one more anchor (`CatzcModulesRoot`), and the discipline that catzc's own code finds its
  content through the code root — bounded, and enforced by an analyzer rule and the build run.

## Related

- [run-modes](../design/run-modes.md) — source mode and build mode; the bundle is build mode's code root.
- [one-living-version](../principles/one-living-version.md) — why the bundle reuses the one importer instead of forking a loader.
- [self-service](../design/self-service.md), [cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md) — the
  content-addressed artifact and build-once/deploy-many this specialises.
- [internal-asset-dependencies](internal-asset-dependencies.md) — the asset inventory the build's presence check verifies.
- [module-aspects](../design/module-aspects.md) — the live/tests aspect the runtime payload is deliberately broader than.
- [durable-sha-globs](../flow/durable-sha-globs.md) — the durable-SHA identity the content hash reuses.
- [native-csharp-types](BCL/native-csharp-types.md) — the combined assembly and the type load order the bundle mode preserves.
- [dynamic-module-manifests](../pwsh/dynamic-module-manifests.md), [pwsh-engine](../pwsh/pwsh-engine.md) — the bundle in pwsh: the merged
  module form, the package module, and the build's entry.
- [use-ps1-not-psm1](../pwsh/use-ps1-not-psm1.md), [one-function-per-file](../pwsh/one-function-per-file.md) — the source rules the merged
  function file is generated from.
- [environment-variables](environment-variables.md) — the well-known-anchor rule `CatzcModulesRoot` follows.
- [github-release](../github/github-release.md) — the release workflow that publishes the build under its calculated version.
- [conventional-folders](../repository/conventional-folders.md), [dedicated-output-directory](../repository/dedicated-output-directory.md) —
  the `out/` and `.vendor/` conventions the artifact uses.
