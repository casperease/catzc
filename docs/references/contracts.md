---
catzc:
  derived:
    path: docs/references/contracts.md
    kind: reference
    language: markdown
    filetype: md
    track: docs
    body_sha: b5678246da49
    links:
      - docs/adr/principles/one-living-version.md
      - docs/adr/repository/api-contracts.md
      - docs/adr/repository/conventional-folders.md
      - docs/references/contracts/catzc.md
---

# The contracts surface

This folder holds the repository's binding interfaces at its boundary, in both directions: the **only public API** an outside consumer is
allowed to depend on, and the file shapes and calls an outside platform (GitHub, Azure DevOps, Azure) expects of us. Everything else in the
repository is internal and follows [one living version](../adr/principles/one-living-version.md) — changed in place, atomically with every
in-tree caller, owing no backwards compatibility. This is the one deliberate exception, because here external consumers genuinely exist and
upgrade on their own schedule.

The layout is the contract: `contracts/<unit>/<version>/<module>/<path>`. The first level is the deployable-unit that carries the contracts
— today only `catzc`, the bundle, the one unit a consumer pins. The second is that unit's version, where `0.0.0` is the unit's mutable
draft, frozen only when that unit is released, and every other version folder is frozen. There is no repository-wide version: another unit
that carries contracts gets its own folder here, with its own versions. Inside a version folder there is one folder per owning catzc module,
and under that each contract asset at the path of the real file it constrains, relative to the module's target root: the repository root
unless `contracts.yml` declares another folder, such as `.github` for `Catzc.Tooling.Github`. No folder under `contracts/` is dot-prefixed.
Provided and depended-on contracts both version with their unit. A frozen version is kept as long as a consumer pins its provided contracts;
a depended-on contract follows its outside platform.

What makes the promise real is **contract testing**: the provider side of this repository carries tests that verify it still honours every
declared version, so a change that would break a published contract fails CI here instead of a consumer in production.

The governing decisions are [api-contracts](../adr/repository/api-contracts.md) (the surface, immutability, and testing discipline) and
[conventional-folders](../adr/repository/conventional-folders.md) (the `contracts/<unit>/<version>/<module>/` layout and its `.gitkeep`
marker).

Each unit's assets, with what each pins, are listed on a generated page per unit: [catzc](contracts/catzc.md).
