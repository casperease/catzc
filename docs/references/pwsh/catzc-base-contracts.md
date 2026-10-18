# Catzc.Base.Contracts

The contracts module. It **makes the repository's contracts binding**: every contract asset under `contracts/` is checked against the real
files it constrains, and every released version folder is held to the `.frozen` record written when it was released, so a change that breaks
a contract fails here and not at a consumer or a platform ([api-contracts](../../adr/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)).
It owns the mechanism — listing the assets, checking them, freezing a release, and writing the contract reference — but **not** the assets
themselves: each asset sits in the folder of the module that talks to the outside party, such as
[Catzc.Tooling.Github](catzc-tooling-github.md) for the workflow files GitHub reads. The layout and the rules are the subject of
[api-contracts](../../adr/repository/api-contracts.md); the folder itself is described in [the contracts surface](../contracts.md).

## Responsibilities

| Responsibility   | Area      | Name                                                                   |
| ---------------- | --------- | ---------------------------------------------------------------------- |
| responsibility:1 | binding   | [Contract quality gate](#responsibility1--contract-quality-gate)       |
| responsibility:2 | check     | [Per-asset checking](#responsibility2--per-asset-checking)             |
| responsibility:3 | list      | [Asset listing](#responsibility3--asset-listing)                       |
| responsibility:4 | release   | [Release freezing](#responsibility4--release-freezing)                 |
| responsibility:5 | reference | [Contract reference pages](#responsibility5--contract-reference-pages) |

### responsibility:1 — Contract quality gate

The quality gate that proves the repository honours its contracts. It checks every asset, in both directions, of each unit's current version
folder — the draft `0.0.0` on a devbox, the released version in a release build — and the provided assets of every older released folder
still in the tree, which is the pin record. It also compares every released folder with its `.frozen` record, so a file changed, added, or
removed since the release is an issue, and it reports every dot-prefixed folder under `contracts/`. Every finding is one issue, reported
through the shared quality-gate report.

### responsibility:2 — Per-asset checking

Checking one contract asset by its kind and returning a record of the result, never an exception for a failed check. A presence asset
requires its target to exist with the exact case of its path; a fragment requires the target to contain it (a key subset for YAML and JSON,
the non-blank lines in order for any other text); a schema validates its target in a bounded JSON Schema subset; a sample payload must parse
and validate against the schema beside it. The quality gate reads these records, and so can any caller that wants the findings without the
verdict.

### responsibility:3 — Asset listing

Enumerating `contracts/<unit>/<version>/<module>/<path>` and deriving every fact about an asset from its name alone: the unit, version, and
owning module from the folders, the kind from the file name, the target from the path under the module placed under the module's target
root, and the direction from the convention, which a version's `contract.yml` overrides for one asset. Nothing is registered per asset: a
module's target root is one configured setting, the repository root by default. How one asset addresses many files is a configured setting
with a sensible default; only the full-path mode is built, and selecting a declared mode that is not built throws. A command contract, the
asset that states a command's call interface, is listed the same way and read by the one reader of the contract language
([command-contracts](../../adr/repository/command-contracts.md)): its parameters, output and one-line signature as a typed record.

### responsibility:4 — Release freezing

Turning a unit's draft into a released version folder: a byte-for-byte copy of `contracts/<unit>/0.0.0/` under the released version, with
the `.frozen` record that holds the SHA-256 of each file. It refuses the draft itself, the devbox build version that names no release, a
folder that already exists, and a draft that does not list. It writes files only; the release build commits them.

### responsibility:5 — Contract reference pages

Generating one committed page per unit, `docs/references/contracts/<unit>.md`, with a table per version folder listing each asset's module,
path, target, direction, and kind, and the notes each asset carries in its own header comment. The pages are derived artifacts: the assets
are what is reviewed, and a page is rewritten only when its content changes. A page this writer did not write is never touched.

## What the module does

The module is the one mechanism behind every contract, whichever module owns the asset. Responsibility 3 is its foundation: all the other
responsibilities start from the list it derives, and because every fact comes from an asset's path and name, adding a contract is adding a
file — there is no registry to keep in step. Responsibility 2 turns that list into findings, one record per asset, and responsibility 1 is
the quality gate built on those records, adding the freeze comparison and the verdict. Keeping the per-asset check a separate, record-only
step is what lets an owning module test its own assets in its own tests while the quality gate covers them all.

Two rules from [api-contracts](../../adr/repository/api-contracts.md) shape the release half. A released provided contract is kept while a
consumer pins it — the one sanctioned backwards compatibility in the repository
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../adr/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)) — so the quality gate keeps checking the provided
assets of older released folders, but not their depended-on assets, which follow their platform. And a released folder is immutable
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../adr/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)): responsibility 4 writes the `.frozen` record once,
and responsibility 1 holds the folder to it on every run. The release version itself comes from
[Catzc.Base.Exporter](catzc-base-exporter.md) (`Resolve-CatzcBuildVersion`).

Responsibility 5 keeps what an asset is for in one place, the asset's header comment
([ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS](../../adr/repository/api-contracts.md#rule-adr-repo-contract-headersayswhatitpins)): `contracts/` holds only assets, and the reference
pages project their notes. The module reads its one setting through [Catzc.Base.Config](catzc-base-config.md) and ends its quality gate
through [Catzc.Base.Reports](catzc-base-reports.md).

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                              | Function                   |
| ------------------------------------------- | -------------------------- |
| responsibility:1 — Contract quality gate    | `Test-Contracts`           |
| responsibility:2 — Per-asset checking       | `Get-ContractCheckResults` |
| responsibility:3 — Asset listing            | `Get-Contract`             |
|                                             | `Get-CommandContract`      |
| config                                      | `contracts.yml`            |
| responsibility:4 — Release freezing         | `Publish-ContractRelease`  |
| responsibility:5 — Contract reference pages | `Build-ContractReference`  |
