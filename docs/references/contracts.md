# The contracts surface

This folder holds the repository's binding interfaces at its boundary, in both directions: the **only public API** an outside consumer is
allowed to depend on, and the file shapes and calls an outside platform (GitHub, Azure DevOps, Azure) expects of us. Everything else in the
repository is internal and follows [one living version](../drs/principles/one-living-version.md) — changed in place, atomically with every
in-tree caller, owing no backwards compatibility. This is the one deliberate exception, because here external consumers genuinely exist and
upgrade on their own schedule.

The layout is the contract: `contracts/<root>/<version>/[<group>/]<asset>`. The first level is the root, the party that makes the promise:
today only `catzc`, since every shape we hold is one we wrote, including our schemas of the files Azure DevOps, GitHub and Azure read. A
vendor root is added only when a vendor ships a shape we copy verbatim. The second is the version: `0.1.0` is the one current version every
internal binding points at, edited in place; `1.0.0` and up are frozen `catzc` releases. Inside a version folder an asset sits directly or
in one group folder, and no group holds a folder. The files a fragment or file schema binds are named only in its version's `contract.yml`
`applies_to`, as repository-relative globs. No folder under `contracts/` is dot-prefixed. A frozen release is kept as long as a consumer
pins it.

What makes the promise real is **contract testing**: the provider side of this repository carries tests that verify it still honours every
declared version, so a change that would break a published contract fails CI here instead of a consumer in production.

The governing decisions are [api-contracts](../drs/repository/api-contracts.md) (the surface, immutability, and testing discipline) and
[conventional-folders](../drs/repository/conventional-folders.md) (the `contracts/<root>/<version>/[<group>/]` layout and its `.gitkeep`
marker).

Each root's assets, with what each pins, are listed on a generated page per root: [catzc](contracts/catzc.md).
