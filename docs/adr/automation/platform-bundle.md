# ADR: Platform bundle — an installable, relocatable copy of catzc

## Rules: ADR-AUTO-BUNDLE

### Rule ADR-AUTO-BUNDLE:1

A **bundle** is an installable, versioned, content-addressed copy of the whole catzc platform that loads in a bare PowerShell 7 session
**outside the mono repo** — with no git work tree, no Roslyn compile, and no working-tree writes. `Catzc.Base.Exporter` owns its lifecycle:
`Build-Catzc` assembles it, `Install-Catzc`/`Export-Catzc` place it, `Assert-CatzcBundle` verifies it. This is the platform-level form of
the build-once artifact ([cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md)) and of a reproducible,
content-addressed, self-service artifact ([self-service](../design/self-service.md)).

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
([one-living-version](../principles/one-living-version.md)). `-Bundle` honours the pre-set `CatzcModulesRoot`, forces the janitors off, and
loads the prebuilt combined-types assembly without invoking Roslyn. Reusing the importer reproduces the exact tested load sequence — the C#
types and their accelerators register **before** any module loads ([native-csharp-types](BCL/native-csharp-types.md#rule-adr-auto-types10))
— which a single declarative module manifest cannot guarantee.

- [The bundle boots through the importer](#the-bundle-boots-through-the-importer)

### Rule ADR-AUTO-BUNDLE:4

A bundle carries the **runtime payload**: each selected module's tracked files **minus its `tests/`** verification surface, plus the
`.internal` loader/bootstrap, the vendored dependencies per policy, and the single committed combined-types DLL. This payload is
deliberately **broader** than the protection `live` aspect ([module-aspects](../design/module-aspects.md)) — that aspect excludes `assets/`
for marker isolation, but a running module needs its `assets/`. Shipping is default-deny: the `tests/` surface never travels, and only
tracked files do, so generated/gitignored files (the per-module `.psd1`, the linked README) are never carried.

- [The runtime payload](#the-runtime-payload)

### Rule ADR-AUTO-BUNDLE:5

A build is **immutable and content-addressed**: the same commit yields a byte-identical payload and an identical durable-SHA content hash
([durable-sha-globs](../flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)), and each bundle carries a `build.json` provenance record
(content hash, source commit, profile, version, counts). `Assert-CatzcBundle` is the integrity gate: it re-verifies that the recorded hash
still matches the tree, that no `tests/` leaked in, that exactly one prebuilt types DLL is present, and that the bundle importer exists —
collecting every violation. `Build-Catzc` runs it as a self-check on its own output.

- [The immutable, verified artifact](#the-immutable-verified-artifact)

### Rule ADR-AUTO-BUNDLE:6

An install is **two artifacts in two places**: the module — the payload and `build.json` — copied to `<Root>/<subfolder>/Catzc/<version>/`
(default subfolder `.vendor`), and a root `importer.ps1` written at the **destination root**. At load time the root importer sets
`RepositoryRoot` to its own location (the working root, so `out/` resolves there and is writable) and `CatzcModulesRoot` to the installed
module. The install is idempotent ([idempotent-state-functions](idempotent-state-functions.md)) — a re-install with a matching content hash
refreshes only the root importer — and the source bundle is verified before the destination is touched.

- [The two-part install](#the-two-part-install)

### Rule ADR-AUTO-BUNDLE:7

There are **two versions**, both declared in `exporter.yml`: the fixed `6.6.666` **direct-install sentinel** every on-disk install carries
(overwritten in place — an obviously-not-published dev convenience), and the real **published version** the NuGet/PSGallery artifact ships
under. Both are numeric `MAJOR.MINOR.PATCH` so the `Catzc/<version>/` folder is a valid module version. Export options — profile, aspect,
vendor policy, versions — are configuration read through `Get-Config` ([sensible-defaults](sensible-defaults.md)), so a build's shape is a
reviewed edit to one file and a test can substitute a fixture config through the same seam.

- [Two versions, one config](#two-versions-one-config)

### Rule ADR-AUTO-BUNDLE:8

A bundle is a **session, not a passive library**. Loading it establishes the catzc session — it sets the global error/warning preferences
exactly as the mono importer does ([error-handling](powershell/error-handling.md)), because catzc functions assume terminating semantics —
and it writes only under the working root's `out/`, never the code it was built from. The NuGet/PSGallery publish is a designed seam,
disabled until its pipeline exists (the publish targets in `artifacts.yml`); direct on-disk install is the built path.

- [A session, not a library](#a-session-not-a-library)

## Context

The catzc platform is normally used by dot-sourcing `importer.ps1` at the repository root: the session it establishes reads the automation
tree in place, and everything anchors on `$env:RepositoryRoot`, which is both the working root and the location of the code. That single
anchor is fine while the code and the work are the same tree, but it is the one thing standing between the platform and being **installed**
— carried to another folder on disk (another repository's `.vendor`, a work directory, a machine modules folder) and run there as a reusable
tool rather than a repository you are inside.

Making the platform installable is a small, fast, sharable artifact problem, and the repository already has most of the pieces: a
deterministic tree copy, a typed module model, the live/tests aspect convention, the durable-SHA identity primitives, the committed
combined-types assembly, and a placeholder publish config reserved for exactly this. What was missing is the concept that ties them together
— the **bundle** — and the two changes that make the platform relocatable without disturbing its in-repo use: the anchor split, and a bundle
mode on the one living importer.

## Decision

Build catzc as a **bundle**: a versioned, content-addressed, self-contained copy that installs to another root and loads there with no git
and no Roslyn, owned by `Catzc.Base.Exporter`.

### What a bundle is

A bundle is the platform, made portable. It contains a root-mirrored copy of the automation tree (so every path-resolution seam works
unchanged), the vendored dependencies, and the prebuilt combined-types assembly, plus a generated `importer.ps1` and a `build.json`
provenance record. It is small (the `tests/` surface is dropped), fast (no compile, no discovery drift), and sharable (one versioned
folder). It is distinct from the repository it is built from: an install is not a repository, has no `.git`, and ships no `infrastructure/`,
`pipelines/`, or `.cspell/` — the functions that depend on those are inert in a bundle, which is expected, and a trimmed profile can exclude
them.

### The two roots

The platform separates the **working root** from the **code root**. `RepositoryRoot` is where the user runs — the anchor for `out/`,
repo-relative paths, and git. `CatzcModulesRoot` is where the loaded catzc code lives — the anchor every config, type, and vendor scan
follows, through `Get-CatzcModulesRoot`. In the mono repo the importer derives `CatzcModulesRoot` as `<RepositoryRoot>/automation`, so the
two coincide and nothing changes. In an install they diverge: the working root is the destination folder, and the code root is the installed
module, which may sit anywhere. This split is the whole reason the platform can be relocated — a scan that anchored on `RepositoryRoot`
would look in the wrong place the moment the code and the work were not the same tree.

### The bundle boots through the importer

A bundle does not carry its own loader. Its `importer.ps1` sets the two anchors and calls the same `Invoke-Importer` the mono shim calls, in
a `-Bundle` mode. This is not merely to avoid a second copy of the load logic — it is load-order-correct. The C# type accelerators the
platform uses (`[Catzc.Module.Type]`) are registered by catzc's own code before any module loads, and any module that names an accelerator
in a type constraint at load time needs it registered first. The existing importer sequences this — types and accelerators, then the module
loop — and a single declarative manifest that listed every module's files as nested modules could not, besides collapsing every module's
private state into one shared scope. So the bundle reuses the importer, and `-Bundle` only changes what it does to the filesystem: janitors
off, the prebuilt DLL loaded rather than compiled, the pre-set code root honoured.

### The runtime payload

What ships is what a module needs to **run**, which is its tracked files minus the `tests/` it is verified by. That is broader than the
protection `live` aspect, and deliberately so: the `live` aspect exists to isolate a module's marker identity and excludes `assets/`, but a
running module reads its `assets/` (install scripts, hook starters, packaged data), so a bundle carries them. Selecting from tracked files
makes the exclusion of generated and gitignored files automatic — the per-module `.psd1` (regenerated on load) and the linked README never
travel — and default-deny keeps the verification surface out: the `tests/` tree is dropped wholesale.

### The immutable, verified artifact

A bundle is content-addressed. `Build-Catzc` computes a durable SHA over the payload with the same recipe the globsets use, and two builds
of one commit produce the same hash — the reproducibility an auditor needs. The hash, the source commit, the profile, and the version travel
in `build.json`, which is excluded from the hash it carries. `Assert-CatzcBundle` closes the loop: given any bundle, it recomputes the hash
and checks it against `build.json`, confirms no test file leaked in, confirms exactly one prebuilt types DLL is present, and confirms the
bundle importer exists — throwing with the full list of what is wrong. A build verifies itself with it, and an install verifies its source
with it.

### The two-part install

An install answers two questions that are usually one: **where do I run**, and **where does the code live**. So it writes two artifacts. The
module — the payload and `build.json` — goes to a modules location under the destination root (`<Root>/.vendor/Catzc/<version>/`). A root
`importer.ps1` goes to the destination root itself, and at load time it is the sole source of the runtime answers: its own location becomes
`RepositoryRoot` (so `out/` is the user's writable working directory, never a read-only module store), and it points `CatzcModulesRoot` at
the installed module. Dot-sourcing it loads the whole platform. Re-installing the same content is a no-op on the module and only rewrites
the root importer, and the source is verified before the destination is changed.

### Two versions, one config

Direct on-disk installs are a dev convenience, not a published release, so they all carry the fixed `6.6.666` sentinel and overwrite in
place — an obviously-unreal number that reads as "installed directly." A published artifact carries a real version. Both are numeric so the
`Catzc/<version>/` folder is a legal module version, and both, along with the profile, aspect, and vendor policy, are declared in one
`exporter.yml` read through `Get-Config` — the single place the repository states how it wants to export itself, validated on load and
substitutable by a fixture in tests.

### A session, not a library

Loading a bundle establishes a catzc session, matching the mono importer: it sets the global error and warning preferences to terminating,
because the platform's functions are written to fail fast and assume that environment. A bundle is therefore a way to run catzc, not a
passive library imported beside other code. It confines its writes to the working root's `out/`, so an install never mutates the tree it was
built from. The one publish direction beyond disk — a NuGet/PSGallery package — is designed as a seam and left disabled until the pipeline
that governs it exists, so the built path is the direct on-disk install.

### How this is enforced

- **`Catzc.Base.Repository`** exposes `Get-CatzcModulesRoot` (the code-root accessor) beside `Get-RepositoryRoot` (the working root); the
  importer sets `$env:CatzcModulesRoot`, and `Catzc.Base.Config`'s discovery scan reads it.
- **`Catzc.Internal.Importer`** carries the `-Bundle` mode (honour the pre-set code root, force the janitors off) reused by the bundle's
  generated `importer.ps1`.
- **`Catzc.Base.Exporter`** owns the artifact: `Build-Catzc`, `Install-Catzc`, `Export-Catzc`, `Assert-CatzcBundle`, `Get-CatzcVersion`,
  `Get-CatzcContentHash`, and the `exporter.yml` config. The walking-skeleton integrity test builds, installs, and loads a bundle from a
  destination root with no git.
- **Code review** keeps the split honest: a scan of catzc's own code anchored on `RepositoryRoot` rather than `CatzcModulesRoot`, or a
  bundle loader that forks the importer, is rejected against this ADR.

## Consequences

- The platform is installable: a single `Export-Catzc -Root <dir>` builds and installs it, and dot-sourcing the installed `importer.ps1`
  runs the whole toolset from a folder that is not the repository.
- The mono repo is unaffected: the two anchors coincide there, and `-Bundle` is off, so the relocatable machinery is a no-op in place.
- A bundle is reproducible and self-describing: the content hash and `build.json` make "which version is installed" a single verifiable
  answer, and `Assert-CatzcBundle` catches a corrupt or drifted install.
- Bundles stay small and fast: the `tests/` surface never ships, the types load from a committed DLL rather than Roslyn, and the load is the
  tested sequence with the maintenance janitors off.
- The cost is one more concept (the bundle) and one more anchor (`CatzcModulesRoot`), plus the discipline that catzc's own scans follow the
  code root — bounded, and a no-op wherever the two roots are the same.

## Related

- [one-living-version](../principles/one-living-version.md) — why the bundle reuses the one importer instead of forking a loader.
- [self-service](../design/self-service.md), [cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md) — the
  content-addressed artifact and build-once/deploy-many this specialises.
- [module-aspects](../design/module-aspects.md) — the live/tests aspect the runtime payload is deliberately broader than.
- [durable-sha-globs](../flow/durable-sha-globs.md) — the durable-SHA identity the content hash reuses.
- [native-csharp-types](BCL/native-csharp-types.md) — the prebuilt combined assembly and the accelerator load order the bundle mode
  preserves.
- [environment-variables](environment-variables.md) — the well-known-anchor rule `CatzcModulesRoot` follows.
- [conventional-folders](../repository/conventional-folders.md) — the `out/` and `.vendor/` conventions the artifact uses.
