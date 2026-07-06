# The contracts surface

This folder is the repository's **only public API**: the binding, versioned interface definitions an outside consumer is allowed to depend
on. Everything else in the repository is internal and follows [one living version](../adr/principles/one-living-version.md) — changed in
place, atomically with every in-tree caller, owing no backwards compatibility. This is the one deliberate exception, because here external
consumers genuinely exist and upgrade on their own schedule.

The layout is the contract: a named boundary per contract (`contracts/<contract-name>/`), and inside it one self-contained folder per
version (`v1`, `v2`, … — integers, no leading zeros; `v0` is the mutable pre-publication draft). A published version is frozen — evolving an
interface incompatibly means adding `v<N+1>` beside it, never editing what a consumer already pins. Coexisting versions are equally live and
equally owned, kept as long as a consumer pins them and retired deliberately — not legacy.

What makes the promise real is **contract testing**: the provider side of this repository carries tests that verify it still honours every
declared version, so a change that would break a published contract fails CI here instead of a consumer in production.

The governing decisions are [api-contracts](../adr/repository/api-contracts.md) (the surface, immutability, and testing discipline) and
[conventional-folders](../adr/repository/conventional-folders.md) (the `contracts/<name>/v<N>/` layout and its `.gitkeep` markers).
