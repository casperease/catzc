# docs/references/contracts.md

`The contracts surface`

This folder holds the repository's binding interfaces at its boundary, in both directions: the **only public API** an outside consumer is
allowed to depend on, and the file shapes and calls an outside platform (GitHub, Azure DevOps, Azure) expects of us. Everything else in the
repository is internal and follows [one living version](../adr/principles/one-living-version.md) — changed in place, atomically with every
in-tree caller, owing no backwards compatibility. This is the one deliberate exception, because here external consumers genuinely exist and
upgrade on their own schedule.

The layout is the contract: one folder per catzc release (`contracts/<release>/`, where `0.0.0` is the mutable draft and every other release
folder is frozen), one folder per owning catzc module inside it, and under that each contract asset at the repository-relative path of the
real file it constrains. A frozen release is kept as long as a consumer pins its provided contracts; a depended-on contract follows its
outside platform.

What makes the promise real is **contract testing**: the provider side of this repository carries tests that verify it still honours every
declared version, so a change that would break a published contract fails CI here instead of a consumer in production.

The governing decisions are [api-contracts](../adr/repository/api-contracts.md) (the surface, immutability, and testing discipline) and
[conventional-folders](../adr/repository/conventional-folders.md) (the `contracts/<release>/<module>/` layout and its `.gitkeep` marker).
