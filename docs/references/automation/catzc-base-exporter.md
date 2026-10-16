---
catzc:
  immutable:
    with_body_sha: "2bc4f4d07db0"
    path: docs/references/automation/catzc-base-exporter.md
    folder: docs/references/automation
    name: catzc-base-exporter
    filetype: md
    kind: reference
    language: markdown
    track: docs
  edges:
    links:
      - docs/adr/automation/platform-bundle.md
      - docs/adr/design/run-modes.md
      - docs/adr/design/self-service.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/adr/flow/durable-sha-globs.md
      - docs/adr/github/github-release.md
      - docs/references/automation/catzc-base-asserts.md
      - docs/references/automation/catzc-base-config.md
      - docs/references/automation/catzc-base-files.md
      - docs/references/automation/catzc-base-globs.md
      - docs/references/automation/catzc-base-modulesystem.md
      - docs/references/automation/catzc-base-repository.md
      - docs/references/automation/catzc-base-writers.md
---

# Catzc.Base.Exporter

The module that builds the catzc platform into one installable, versioned, content-addressed `Catzc` module — build mode's code root
([run-modes](../../adr/design/run-modes.md)) — and delivers it: beside a working root outside the mono repo, into the user's module path, or
as a package for a local-path `Install-PSResource`. The build carries every selected module merged into one file per module, the vendored
dependencies, and the combined-types assembly, so it loads in a bare pwsh 7 with no git repo and no Roslyn. It is the platform-level
expression of a reproducible, content-addressed, self-service artifact (see [self-service](../../adr/design/self-service.md)) and of
build-once / deploy-many (see [cd-discipline-and-promotion-flow](../../adr/flow/cd-discipline-and-promotion-flow.md)); the identity it
computes reuses the durable-SHA recipe of [durable-sha-globs](../../adr/flow/durable-sha-globs.md). The rules it implements are
[platform-bundle](../../adr/automation/platform-bundle.md). It is a member of the `Base` group and depends on
[Catzc.Base.ModuleSystem](catzc-base-modulesystem.md), [Catzc.Base.Config](catzc-base-config.md), [Catzc.Base.Globs](catzc-base-globs.md),
[Catzc.Base.Files](catzc-base-files.md), [Catzc.Base.Repository](catzc-base-repository.md), [Catzc.Base.Writers](catzc-base-writers.md), and
[Catzc.Base.Asserts](catzc-base-asserts.md).

## Responsibilities

| Responsibility   | Area     | Name                                                                                      |
| ---------------- | -------- | ----------------------------------------------------------------------------------------- |
| responsibility:1 | build    | [Build](#responsibility1--build)                                                          |
| responsibility:2 | deliver  | [Install, export and package](#responsibility2--install-export-and-package)               |
| responsibility:3 | identity | [Version, identity and verification](#responsibility3--version-identity-and-verification) |

### responsibility:1 — Build

Turning the selected modules into the build of one named bundle under `out/automation/built/<bundle>/Catzc/<version>/`. A bundle is an
`exporter.yml` `bundles` entry — a release identity with its own profile, version line and vendor policy, so two bundles never share a
folder or a version. `Build-Modules` settles the inputs — the bundle (`default_bundle` when none is named), its modules (the bundle's
profile, or explicit names and/or a profile for an experiment), the vendor policy, the destination, the version, and the package identity —
and hands them to the build engine in the `.internal` builder, which closure-expands the selection, merges each module's function files into
one `<Module>.ps1` beside a generated manifest, copies the side folders, the loader and the vendored modules, ships the types assembly, and
writes `Catzc.psd1`, `Catzc.psm1`, `Import-Catzc.ps1`, and the `build.json` provenance record. It then verifies what was written with
`Assert-CatzcBundle`. `-DryRun` returns the plan and writes nothing.

### responsibility:2 — Install, export and package

Delivering a build to where it is used. `Install-Catzc -Root <dir>` is the two-part install: the build goes to
`<dir>/.vendor/Catzc/<version>/` and a root `importer.ps1` at `<dir>` dot-sources the installed `Import-Catzc.ps1` with `<dir>` as the
working root, so `out/` and repo-relative paths resolve there while the installed build is the code root. `Install-Catzc -Scope CurrentUser`
copies the build into the user's module path instead, after which `Import-Module Catzc` works from any shell. Both verify the build first
and are idempotent — a re-install of the same content hash leaves the module in place. `Export-Catzc` is the one-call entry: it builds, then
installs (`-To disk`) or packs the build folder itself into `out/automation/packages/` (`-To nuget`), the package a client installs with
`Install-PSResource Catzc` from a local repository and the artifact the release workflow publishes
([github-release](../../adr/github/github-release.md)).

### responsibility:3 — Version, identity and verification

The build's version, identity, and integrity guard. `Resolve-CatzcBuildVersion` decides the version: on a devbox `-Version auto` is the
fixed `6.6.666` placeholder, announced by a yellow notice; in a pipeline it is calculated — the bundle's own `MAJOR.MINOR` from
`exporter.yml` and the first-parent commit count of the built commit as `PATCH` — so the same commit always gets the same version; an
explicit `MAJOR.MINOR.PATCH` is honoured, except the placeholder in a pipeline. `Get-CatzcContentHash` applies the durable-SHA recipe to a
tree (CR-stripped per file, folded in ordinal path order) for a reproducible, EOL-insensitive identity. `Assert-CatzcBundle` is the guard:
the layout files, no `tests/`, exactly one types DLL named for the recorded `typesHash` and built from the recorded type sources, every
module's manifest and merged file, every manifest export resolving to a function in its merged file, and the recorded content hash —
throwing with every violation.

## What the module does

The module turns the running repository into an artifact that other places can install and trust. Build assembles the artifact
(responsibility 1), install/export places it (responsibility 2), and version/identity/verification make the result addressable and checkable
(responsibility 3). The load-bearing design choice is the split between the two roots — the working `RepositoryRoot` (where the user runs,
where `out/` goes) and `CatzcModulesRoot` (where the catzc code lives). In the mono repo they coincide; an install makes them differ, which
is what lets the build be carried out of the repo and still resolve its own config, types, and vendored dependencies. Every module in the
build stays its own PowerShell module of the same name, so a build behaves as the same modules in a different on-disk form.

Everything routes through the platform's own seams — the defaults and package identity through `Get-Config` (validated on load, swappable in
tests), the build through the one engine, the hash through the native durable-SHA type, the load through the one importer — so the exporter
adds an artifact lifecycle on top of the platform rather than a parallel one.

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                        | Function                    |
| ----------------------------------------------------- | --------------------------- |
| responsibility:1 — Build                              | `Build-Modules`             |
| config                                                | `exporter.yml`              |
| responsibility:2 — Install, export and package        | `Export-Catzc`              |
|                                                       | `Install-Catzc`             |
| responsibility:3 — Version, identity and verification | `Resolve-CatzcBuildVersion` |
|                                                       | `Get-CatzcContentHash`      |
|                                                       | `Assert-CatzcBundle`        |
