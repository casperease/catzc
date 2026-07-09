# Catzc.Base.Exporter

The module that packages the catzc platform into an installable, versioned, content-addressed bundle and installs it onto a destination
outside the mono repo. It owns the whole export path: build a self-contained copy of the platform into `out/`, then place it — as a module
plus a root `importer.ps1` — where it is consumed. The bundle carries a runtime payload, the vendored dependencies, and the prebuilt
combined-types assembly, so it loads in a bare pwsh 7 with no git repo and no Roslyn. It is the platform-level expression of a reproducible,
content-addressed, self-service artifact (see [self-service](../../adr/design/self-service.md)) and of build-once / deploy-many (see
[cd-discipline-and-promotion-flow](../../adr/flow/cd-discipline-and-promotion-flow.md)); the identity it computes reuses the durable-SHA
recipe of [durable-sha-globs](../../adr/flow/durable-sha-globs.md). It is a member of the `Base` group and depends on
[Catzc.Base.ModuleSystem](catzc-base-modulesystem.md), [Catzc.Base.Config](catzc-base-config.md), [Catzc.Base.Globs](catzc-base-globs.md),
[Catzc.Base.Files](catzc-base-files.md), [Catzc.Base.Repository](catzc-base-repository.md), [Catzc.Base.Writers](catzc-base-writers.md), and
[Catzc.Base.Asserts](catzc-base-asserts.md).

## Domains

| Domain   | Area     | Name                                                               |
| -------- | -------- | ------------------------------------------------------------------ |
| domain:1 | build    | [Bundle build](#domain1--bundle-build)                             |
| domain:2 | deliver  | [On-disk export and install](#domain2--on-disk-export-and-install) |
| domain:3 | identity | [Identity and verification](#domain3--identity-and-verification)   |

### domain:1 — Bundle build

Assembling the immutable bundle into `out/`. `Build-Catzc` resolves a module profile, copies each module's runtime surface — its tracked
files minus the `tests/` verification surface, so a running module keeps its `assets/` and `configs/` but ships no tests — together with the
`.internal` loader, the vendored dependencies (per policy), and the single committed combined-types DLL, mirroring the repository layout so
the same path-resolution seams work unchanged. It generates a bundle `importer.ps1` and a `build.json` provenance record carrying the
content hash, source commit, profile, and file counts. What the bundle contains is the tracked runtime payload, which is deliberately
broader than the protection `live` aspect (that aspect excludes `assets/` for marker isolation; a runnable bundle needs them). Build
defaults — profile, vendor policy, version — come from `exporter.yml`.

### domain:2 — On-disk export and install

Delivering a built bundle to where it is used, as two artifacts in two places (the working root need not be the mono repo). `Install-Catzc`
copies the module to `<Root>/.vendor/Catzc/<version>/` and writes a root `importer.ps1` whose location becomes the working `RepositoryRoot`
(so `out/` and repo-relative paths resolve there) and which points `CatzcModulesRoot` at the installed module. Dot-sourcing that importer
loads the whole platform from the install. It is idempotent — a re-install with the same content hash refreshes only the root importer — and
verifies the source bundle before touching the destination. `Export-Catzc` is the top-level entry: `-To disk` builds and then installs in
one call; `-To nuget` builds and packs a `.nupkg` with a PSGallery-compatible module manifest (`Catzc.psd1` + a `Catzc.psm1` RootModule)
into `out/catzc-nuget/`, the artifact the GitHub release workflow publishes ([github-release](../../adr/github/github-release.md)).

### domain:3 — Identity and verification

The artifact's identity and its integrity gate. `Get-CatzcVersion` reads the two versions in `exporter.yml` — the fixed `6.6.666`
direct-install sentinel every on-disk install carries, and the published version number under `-Published`. `Get-CatzcContentHash` applies
the durable-SHA recipe to a built tree (CR-stripped per file, folded in ordinal path order) for a reproducible, EOL-insensitive,
64-character identity that changes on any content, rename, or removal. `Assert-CatzcBundle` is the gate: it verifies a bundle's recorded
hash still matches the tree, that no tests leaked in, that exactly one prebuilt types DLL is present, and that the bundle importer exists —
throwing with every violation. `Build-Catzc` runs it as a self-check on what it produces.

## What the module does

The module turns the running repository into an artifact that other places can install and trust. The three domains are the pipeline from
source to install: build assembles the payload (domain 1), export/install places it (domain 2), and identity/verification make the result
addressable and checkable (domain 3). The load-bearing design choice is the split between the two roots — the working `RepositoryRoot`
(where the user runs, where `out/` goes) and `CatzcModulesRoot` (where the catzc code lives). In the mono repo they coincide; an install
makes them differ, which is what lets the module be carried out of the repo and still resolve its own config, types, and vendored deps. The
bundle is deliberately a session-establishing install, not a passive library: its `importer.ps1` reproduces the tested load sequence in a
read-only `-Bundle` mode (janitors off, the prebuilt DLL loaded without Roslyn), so what runs from an install is byte-for-byte the platform
the commit built.

Everything routes through the platform's own seams — the version and options through `Get-Config` (validated on load, swappable in tests),
the module selection through the profile/dependency-closure machinery, the hash through the native durable-SHA type — so the exporter adds
an artifact lifecycle on top of the existing platform rather than a parallel one. Two delivery shapes share the one bundle: a direct on-disk
install from the mono repo, and a NuGet package (the `.nupkg` + a `Catzc.psd1` manifest) that the manually-triggered release workflow
publishes GitHub-first on the built-in token, with the PowerShell Gallery an opt-in target
([github-release](../../adr/github/github-release.md)).

## Division

The module's public functions and configuration, sorted into the domains above.

| Domain                                | Function               |
| ------------------------------------- | ---------------------- |
| domain:1 — Bundle build               | `Build-Catzc`          |
| config                                | `exporter.yml`         |
| domain:2 — On-disk export and install | `Export-Catzc`         |
|                                       | `Install-Catzc`        |
| domain:3 — Identity and verification  | `Get-CatzcVersion`     |
|                                       | `Get-CatzcContentHash` |
|                                       | `Assert-CatzcBundle`   |
