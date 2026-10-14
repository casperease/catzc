# docs/adr/repository/api-contracts.md

`ADR: Contracts at the repository boundary — both directions, one folder per release, proven by tests`

## Rules: ADR-REPO-CONTRACT

### Rule ADR-REPO-CONTRACT:1

A **contract** is a binding interface at the repository boundary, held under `contracts/`, and `contracts/` holds every one of them, in both
directions. A **provided contract** is what an outside consumer may rely on: the only public API of the repository. A **depended-on
contract** is what an outside platform expects of our files and calls — GitHub reading a workflow file, Azure DevOps reading a pipeline's
trigger. Everything else in the repository is internal and governed by [one living version](../principles/one-living-version.md) (changed in
place, no back-compat).

- [Both directions](#both-directions)
- [The only public API](#the-only-public-api)

### Rule ADR-REPO-CONTRACT:2

Contracts are laid out as `contracts/<release>/<module>/<path>`. `<release>` is the catzc bundle version that `Resolve-CatzcBuildVersion`
resolves ([ADR-AUTO-BUNDLE#7](../automation/platform-bundle.md#rule-adr-auto-bundle7)); `<module>` is the owning catzc module, the one that
talks to the outside party and holds the tests that prove the contract, with its dependencies governed by `dependencies.yml`; and `<path>`
is the repository-relative path of the real file the asset constrains
([conventional-folders](conventional-folders.md#rule-adr-repo-folders11)).

- [One folder per release, one per owning module](#one-folder-per-release-one-per-owning-module)

### Rule ADR-REPO-CONTRACT:3

A released provided contract is kept while a consumer pins its release. This is the one sanctioned backwards-compatibility in the
repository: external consumers genuinely exist at this boundary and cannot change in lockstep
([ADR-PRIN-ONELIVE#7](../principles/one-living-version.md#rule-adr-prin-onelive7)), and a release folder is retired only when no consumer
pins it — a deliberate, contract-driven deprecation, not a hedge. A depended-on contract follows its outside platform instead: a platform
change is a new draft in `0.0.0`, never an old version kept beside the new one.

- [Where back-compat is owed](#where-back-compat-is-owed)

### Rule ADR-REPO-CONTRACT:4

Contracts are **binding**, proven by tests: the owning module verifies that the repository honours every asset of the current release
folder, and every provided asset of a release a consumer pins. A change that breaks a contract fails CI here, not a consumer or a platform
in production. This is what makes "kept for back-compat" a guarantee rather than a hope.

- [Binding, by contract testing](#binding-by-contract-testing)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT:5

A released folder is immutable. Evolving a contract means editing the draft, `contracts/0.0.0/`, which is the only mutable folder; a release
freezes the draft as `contracts/<release>/`, and that folder is never edited again. The devbox build version `6.6.666` names no release, so
it never freezes a folder.

- [A released folder is frozen](#a-released-folder-is-frozen)

### Rule ADR-REPO-CONTRACT:6

A **contract asset** is one file under `contracts/<release>/<module>/`, and its name alone picks its kind. With no suffix it is a fragment:
the real file at the same path must exist and contain it — a key subset for YAML and JSON, the non-blank lines in order for any other text —
and an empty fragment requires presence only. `<path>.schema.json` is a schema the real file at `<path>` validates against.
`<name>.sample.<ext>` is a sample payload the owning module's tests produce or parse.

- [The name picks the kind](#the-name-picks-the-kind)

### Rule ADR-REPO-CONTRACT:7

A contract asset's direction comes by convention: an asset that constrains a real repository file is depended-on, and a sample payload is
provided. A per-release `contract.yml`, at `contracts/<release>/contract.yml`, overrides the direction of a single asset.

- [Direction by convention](#direction-by-convention)

### Rule ADR-REPO-CONTRACT:8

How one asset addresses many files is a configured setting with a sensible default, declared once on the contracts config type
([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)). A mode that is not built throws `NotImplemented` when
configured; a mode is switched on only once it is proven from both pwsh and bash. The scan for matching files runs only when the configured
mode says what to match — nothing is enumerated speculatively.

- [Addressing many files](#addressing-many-files)

## Context

The [one-living-version](../principles/one-living-version.md) principle holds for the **inside** of the repository: every internal caller is
in the tree and moves with a change, so there is no external consumer to keep a back-compat shim alive for. But the repository has an
outside, and it meets that outside in two directions. Outside consumers build against what it provides, on their own upgrade schedule. And
outside platforms read what it holds — GitHub reads the workflow files and renders the READMEs, Azure DevOps reads the pipeline triggers —
and break the delivery when a file stops matching what they expect.

`contracts/` is the structure for both. It makes the boundary explicit (so it is obvious what is a promise or an obligation to the outside
versus an internal implementation detail), versioned by release (so a frozen release is never mutated under a consumer), and testable (so
the boundary is verified mechanically, not asserted in a README).

### Both directions

`One tree, two directions`

A provided contract is a promise the repository makes; a depended-on contract is an obligation it accepts. They differ in who moves first: a
consumer upgrades when it chooses, so a provided contract must not move; a platform changes when it chooses, so a depended-on contract must
follow it. They share everything else — a binding shape, an owning module, and a test that turns red when the shape breaks — so they share
one tree, one layout, and one mechanism rather than two.

### The only public API

`Provided contracts are the only public API`

Everything outside `contracts/` is internal. A consumer that reaches past the provided contracts — into a module function, an internal
config schema, a data record — gets no compatibility promise and may break on any change, exactly as internal code does. This keeps the
public commitment small and deliberate: the repository promises what it puts in `contracts/`, and nothing else. A depended-on contract
promises nothing to a consumer; it records what a platform requires, so the repository cannot break that platform unnoticed.

### One folder per release, one per owning module

`contracts/<release>/<module>/<path>`

The version segment is the catzc release itself, so one number tells a consumer which bundle and which contracts belong together, and the
release folder is a self-contained snapshot of every contract at that release. Inside it, each owning module has its own folder: the module
that talks to the outside party — `Catzc.Tooling.Github` for GitHub, `Catzc.Azure.DevOps` for Azure DevOps — is the one that holds the
tests, and the module dependency graph governs it like any other code. Under the module, the path repeats the real file's
repository-relative path, so the asset and the file it constrains are found from each other without a mapping.

```text
contracts/
  0.0.0/                                            # the mutable draft: the next release
    Catzc.Tooling.Github/
      .github/workflows/ci-automation.yml           # fragment: the keys GitHub reads
      .github/workflows/ci-automation.yml.schema.json   # schema: the real file validates against it
      README.md                                     # fragment: the heading GitHub renders
    Catzc.Azure.DevOps/
      rest/build-queue.sample.json                  # sample payload: the module produces or parses it
  1.0.0/                                            # frozen at release 1.0.0
```

### Where back-compat is owed

`Why this is the one place back-compat is owed`

Backwards compatibility buys a grace period for consumers who cannot change in lockstep with the producer. Internally there are none, so
internally it is rejected. At the provided boundary there genuinely are, so a released provided contract stays live while a consumer pins
its release. The cost (a maintained old release) buys something real: it is the difference between an external consumer that keeps working
and one that breaks. Retirement is deliberate and evidence-based — a release folder goes away when no consumer pins it — not on a guessed-at
calendar.

A depended-on contract owes no grace period, because its outside party does not pin our releases; it reads the files as they are. When the
platform changes what it expects, the only useful contract is the new expectation, so the change is made in the draft and released with the
next release. An old expectation the platform has dropped protects nothing.

### Binding, by contract testing

A contract is only a promise if breaking it is caught. The owning module carries the tests that assert the repository satisfies its assets:
every asset of the current release folder (`0.0.0` on a devbox, the resolved release in a release build), and the provided assets of every
release a consumer pins. The check follows the asset's kind (ADR-REPO-CONTRACT#6), so a change that violates a contract turns the test run
red before it ships. Without the test, "we keep this working" is a hope; with it, it is enforced.

### A released folder is frozen

Once a release is cut, its folder is not edited — a consumer builds against exactly those bytes. A fix or an evolution that changes a
contract lands in `0.0.0/`, the draft, and reaches the outside with the next release. The draft exists precisely so a contract can be shaped
before it becomes a binding promise. A devbox build carries the `6.6.666` placeholder
([ADR-AUTO-BUNDLE#7](../automation/platform-bundle.md#rule-adr-auto-bundle7)), which is a local convenience and not a release, so no
`contracts/6.6.666/` folder ever exists. This immutability is what lets a consumer pin a release and trust it does not move underneath them.

### The name picks the kind

`Sensible defaults from the asset's own path`

An asset declares nothing: its kind, its target, and its owning module all come from where it sits and what it is called
([zero-ceremony-poka-yoke](../automation/zero-ceremony-poka-yoke.md)). The four kinds are the four things a boundary can require:

- **Presence** — an empty fragment: the real file at the same path must exist.
- **Fragment** — no suffix: the real file must exist and contain the fragment. YAML and JSON compare by key subset, so the real file may
  carry more keys than the fragment names; any other text compares by its non-blank lines, which must appear in the real file in the same
  order.
- **Schema** — `<path>.schema.json`: the real file at `<path>` validates against the JSON Schema, applied to YAML after parsing. A schema
  that shares its `<name>` with a sample payload beside it applies to that sample instead of a real file.
- **Sample payload** — `<name>.sample.<ext>`: a payload the owning module's tests must produce or parse, validated against the schema beside
  it when one exists.

A fragment pins only what the outside party reads, so the rest of the file stays free to change under one living version.

### Direction by convention

`The convention decides, contract.yml overrides`

An asset that constrains a real repository file — a fragment, presence, or a schema on that file's path — is depended-on, because an outside
platform is what reads the file. A sample payload is provided, because it is a shape the repository hands to a consumer. The convention is
right for most assets, so most release folders carry no `contract.yml`; the one at `contracts/<release>/contract.yml` overrides a single
asset's direction where the convention is wrong, such as a sample payload an outside platform requires of a call. It is part of the release
folder, so it freezes with it.

### Addressing many files

`Do the scan once the mode is known`

By default an asset addresses exactly one real file: the one at its own path (ADR-REPO-CONTRACT#6). Constraining many files with one asset —
by a manifest glob, by a per-folder file — is a configured mode, resolved like any setting
([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)). A mode that is not built throws `NotImplemented` rather
than half-working, and it is switched on by configuration only after it is proven from both pwsh and bash, the two shells the mechanism runs
under. The match set is computed only once the configured mode says what to match, so no tree walk runs on speculation.

### Rejected alternatives

1. **One unversioned contract set, evolved in place** — rejected: every change becomes a potential break for some consumer, and there is no
   way to support an old and a new shape at once. Release folders let the two coexist and be tested independently.

2. **A version per contract (`contracts/<contract-name>/v<N>/`)** — rejected: a consumer upgrades the catzc bundle, not individual
   contracts, so a separate number per contract forces a mapping from bundle to contract versions that the release folder makes unnecessary.

3. **Separate trees for provided and depended-on contracts** — rejected: both directions share the layout, the asset kinds, and the test
   mechanism; two trees would duplicate all three and split one owning module's boundary in two.

4. **Documenting the boundary in a README and trusting both sides** — rejected: a prose promise is not verified, so it drifts from the code
   and breaks consumers and platforms silently. A binding, tested contract catches the break in CI.

5. **A back-compat shim in internal code** (dual-read the old and new shape inside the implementation) — rejected: it smears the public
   boundary through internal code, which then can never reach [one living version](../principles/one-living-version.md). The compatibility
   belongs at the boundary, as a frozen release folder, not inside.

## Decision

`contracts/` holds every binding interface at the repository boundary: provided contracts, the only public API, and depended-on contracts,
what outside platforms require of our files and calls. It is laid out as `contracts/<release>/<module>/<path>`, where the release is the
catzc bundle version, the module owns and tests the contract, and the path is the real file's. The draft `0.0.0` is the only mutable folder;
a released folder is frozen, and kept while a consumer pins its provided contracts. An asset's name picks its kind and its direction, a
per-release `contract.yml` overrides the direction, and many-file addressing is a configured mode. Every contract is verified by its owning
module's tests, so a break is caught in CI, not in production. Everything outside `contracts/` is internal and follows one living version.

### How this is enforced

- **`Catzc.Base.Contracts`** owns the mechanism: it enumerates `contracts/<release>/**`, derives each asset's kind, direction, owning
  module, and target from the name and `contract.yml`, and runs the kind's check against the real tree as a quality gate. Each owning
  module's L1 test per asset is generated from the same enumeration, so `Test-Automation` covers every contract with no hand-written test.

- **The frozen-folder test** fails on any change to a release folder other than `0.0.0` (ADR-REPO-CONTRACT#5).

- **Code review** guards what the tests cannot phrase: that the boundary stays confined to `contracts/` (ADR-REPO-CONTRACT#1), that a
  retirement is justified by the absence of a pinning consumer (ADR-REPO-CONTRACT#3), and that a `contract.yml` override is the exception
  the convention calls for (ADR-REPO-CONTRACT#7).

## Consequences

- The boundary is explicit and small: what is in `contracts/` is promised or required; everything else is free to change with one living
  version.
- A platform's expectations are tested like a consumer's promises, so a workflow edit that GitHub would reject fails CI here first.
- An incompatible change to a provided contract never breaks a consumer silently — it reaches the outside only as a new release, and the
  pinned release keeps passing its tests until it is deliberately retired.
- Assets need no registration: the path is the target, the suffix is the kind, and the convention is the direction.
- The internal code stays shim-free: backwards compatibility is a boundary concern, expressed as frozen release folders, not as dual-read
  paths threaded through implementations.
- The cost is real and bounded: each pinned release's provided contracts are maintained and tested for as long as a consumer pins them. That
  cost buys the one thing it should — external consumers that keep working across change.
