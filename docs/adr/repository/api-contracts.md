---
catzc:
  immutable:
    with_body_sha: ce56bccfd0a0
    path: docs/adr/repository/api-contracts.md
    folder: docs/adr/repository
    name: api-contracts
    filetype: md
    kind: adr
    language: markdown
    track: docs
  edges:
    defines:
      - ADR-REPO-CONTRACT#{1-10}
    cites:
      - ADR-AUTO-BUNDLE#7
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-ONELIVE#7
      - ADR-REPO-FOLDERS#4
      - ADR-REPO-ROOTCFG#1
    links:
      - docs/adr/automation/execution-engines.md
      - docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/automation/zero-ceremony-poka-yoke.md
      - docs/adr/principles/one-living-version.md
      - docs/adr/principles/one-living-version.md#rule-adr-prin-onelive7
      - docs/adr/repository/conventional-folders.md#rule-adr-repo-folders11
      - docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4
      - docs/adr/repository/generated-root-configs.md#rule-adr-repo-rootcfg1
---

# ADR: Contracts at the repository boundary — both directions, versioned with their unit, proven by tests

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

Contracts are laid out as `contracts/<unit>/<version>/<module>/<path>`. `<unit>` is the deployable-unit that carries the contracts —
`catzc`, the bundle, the one unit a consumer pins; `<version>` is that unit's version, which `Resolve-CatzcBuildVersion` resolves;
`<module>` is the owning catzc module, the one that talks to the outside party and holds the tests that prove the contract, with its
dependencies governed by `dependencies.yml`; and `<path>` is the path of the real file the asset constrains, relative to the module's
**target root**. A module's target root is the repository-relative folder that `contracts.yml` declares for it, a configured setting whose
default, the repository root, is declared once on the contracts config type; so with `Catzc.Tooling.Github`'s target root `.github`, the
asset `contracts/catzc/0.0.0/Catzc.Tooling.Github/workflows/release-automation.yml` constrains `.github/workflows/release-automation.yml`
([conventional-folders](conventional-folders.md#rule-adr-repo-folders11)). Provided and depended-on contracts both version with their unit.
There is no repository-wide version: another unit that carries contracts gets its own `contracts/<unit>/`, with its own versions.

- [One folder per unit version, one per owning module](#one-folder-per-unit-version-one-per-owning-module)
- [A target root per module](#a-target-root-per-module)

### Rule ADR-REPO-CONTRACT:3

A released provided contract is kept while a consumer pins that version of its unit. This is the one sanctioned backwards-compatibility in
the repository: external consumers genuinely exist at this boundary and cannot change in lockstep
([ADR-PRIN-ONELIVE#7](../principles/one-living-version.md#rule-adr-prin-onelive7)), and a released version folder is retired only when no
consumer pins it — a deliberate, contract-driven deprecation, not a hedge. A depended-on contract follows its outside platform instead: a
platform change is a new draft in its unit's `0.0.0`, never an old version kept beside the new one.

- [Where back-compat is owed](#where-back-compat-is-owed)

### Rule ADR-REPO-CONTRACT:4

Contracts are **binding**, proven by tests: the owning module verifies that the repository honours every asset of its unit's current version
folder, and the provided assets of every released version folder still in the tree — released folders are the pin record, so retiring a
version means deleting its folder. The depended-on assets of an older release are not re-checked: they follow their platform
(ADR-REPO-CONTRACT#3). A change that breaks a contract fails CI here, not a consumer or a platform in production. This is what makes "kept
for back-compat" a guarantee rather than a hope.

- [Binding, by contract testing](#binding-by-contract-testing)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT:5

A released version folder is immutable. Evolving a contract means editing its unit's draft, `contracts/<unit>/0.0.0/`, the only mutable
folder of that unit; releasing the unit freezes the draft as `contracts/<unit>/<version>/`, and that folder is never edited again. The draft
freezes only when its own unit is released. The devbox build version `6.6.666` names no release, so it never freezes a folder. Releasing
freezes the draft with `Publish-ContractRelease`, which writes the folder's `.frozen` record (the SHA-256 of each file), and
`Test-Contracts` fails on any file changed, added, or removed since.

- [A released folder is frozen](#a-released-folder-is-frozen)

### Rule ADR-REPO-CONTRACT:6

A **contract asset** is one file under `contracts/<unit>/<version>/<module>/`, and its name alone picks its kind. With no suffix it is a
fragment: the real file at the same path under its module's target root must exist and contain it — a key subset for YAML and JSON, the
non-blank lines in order for any other text — and an empty fragment requires presence only. `<path>.schema.json` is a schema the real file
at `<path>` validates against. `<name>.sample.<ext>` is a sample payload the owning module's tests produce or parse.

- [The name picks the kind](#the-name-picks-the-kind)

### Rule ADR-REPO-CONTRACT:7

A contract asset's direction comes by convention: an asset that constrains a real repository file is depended-on, and a sample payload is
provided. A per-version `contract.yml`, at `contracts/<unit>/<version>/contract.yml`, overrides the direction of a single asset.

- [Direction by convention](#direction-by-convention)

### Rule ADR-REPO-CONTRACT:8

How one asset addresses many files is a configured setting with a sensible default, declared once on the contracts config type. A mode that
is not built throws `NotImplemented` when configured; a mode is switched on only once it is proven from every engine. The scan for matching
files runs only when the configured mode says what to match — nothing is enumerated speculatively.

- [Addressing many files](#addressing-many-files)

### Rule ADR-REPO-CONTRACT:9

An asset says what it pins in its own header comment — the leading `#` lines of a YAML asset, the `$comment` of a schema — and `contracts/`
holds only assets. `Build-ContractReference` generates one committed page per unit, `docs/references/contracts/<unit>.md`, with one table
per version folder listing every asset's module, target, direction, and kind, and the assets' notes in a list under the table. An asset
whose check compares every byte or key — a presence asset, a text fragment, a JSON fragment or sample payload — carries no note. The writer
removes only pages it wrote, so a hand-written page in that folder is never touched.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT:10

`contracts/` holds no dot-prefixed folder at any depth. A dot prefix marks infrastructure at the repository root
([ADR-REPO-FOLDERS#4](conventional-folders.md#rule-adr-repo-folders4)), and every folder under `contracts/` is a unit, a version, a module,
or a folder of an asset's path: content, never infrastructure. An asset whose target sits under a dot-prefixed root, such as `.github/`,
reaches it through its module's target root (ADR-REPO-CONTRACT#2) and never repeats the dot folder. The rule covers folders, not file names:
the root's `.gitkeep`, a released folder's `.frozen` record, and an asset that pins a dotfile by its own name keep their names, because a
target root relocates a folder but never renames a file. `Test-Contracts` reports each dot-prefixed folder.

- [No dot-prefixed folder](#no-dot-prefixed-folder)
- [How this is enforced](#how-this-is-enforced)

## Context

The [one-living-version](../principles/one-living-version.md) principle holds for the **inside** of the repository: every internal caller is
in the tree and moves with a change, so there is no external consumer to keep a back-compat shim alive for. But the repository has an
outside, and it meets that outside in two directions. Outside consumers build against what it provides, on their own upgrade schedule. And
outside platforms read what it holds — GitHub reads the workflow files and renders the READMEs, Azure DevOps reads the pipeline triggers —
and break the delivery when a file stops matching what they expect.

`contracts/` is the structure for both. It makes the boundary explicit (so it is obvious what is a promise or an obligation to the outside
versus an internal implementation detail), versioned with the unit that carries it (so a frozen version is never mutated under a consumer),
and testable (so the boundary is verified mechanically, not asserted in a README).

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

### One folder per unit version, one per owning module

`contracts/<unit>/<version>/<module>/<path>`

The first segment names the deployable-unit that carries the contracts, and the second is that unit's version, so one number tells a
consumer which build of the unit and which contracts belong together, and the version folder is a self-contained snapshot of every contract
of that unit at that version. The one such unit is `catzc`, the bundle: it is the one unit a consumer pins
([ADR-AUTO-BUNDLE#7](../automation/platform-bundle.md#rule-adr-auto-bundle7)), and the owning modules ship in it, so provided and
depended-on contracts alike version with it. The repository is a product mono-repository, not one monolithic application: inside the trunk
everything is at HEAD, and a version exists only where a unit crosses the boundary. So there is no repository-wide version, and another
deployable-unit that carries contracts gets its own `contracts/<unit>/` beside `catzc/`, with versions of its own.

Inside a version folder, each owning module has its own folder: the module that talks to the outside party — `Catzc.Tooling.Github` for
GitHub, `Catzc.Azure.DevOps` for Azure DevOps — is the one that holds the tests, and the module dependency graph governs it like any other
code. Under the module, the path repeats the real file's path under the module's target root, so the asset and the file it constrains are
found from each other through one declared folder per module.

```text
contracts/
  catzc/                                              # the unit: the bundle
    0.0.0/                                            # the mutable draft: the bundle's next release
      Catzc.Tooling.Github/                           # target root .github
        workflows/ci-automation.yml                   # fragment of .github/workflows/ci-automation.yml: the keys GitHub reads
        workflows/ci-automation.yml.schema.json       # schema: .github/workflows/ci-automation.yml validates against it
        README.md                                     # presence of .github/README.md, the page GitHub renders
      Catzc.Azure.DevOps/                             # target root: the repository root, the default
        pipelines/ci-automation.yaml                  # fragment of pipelines/ci-automation.yaml: the keys Azure Pipelines reads
        rest/build-queue.sample.json                  # sample payload: the module produces or parses it
    1.0.0/                                            # frozen when the bundle 1.0.0 is released
```

### A target root per module

`One declared folder per module, the repository root by default`

Most owning modules constrain files across the repository, so their assets' paths are repository-relative, and the default target root, the
repository root, needs no declaration. A module whose files all sit under one folder, such as `Catzc.Tooling.Github` under `.github/`,
declares that folder once in `contracts.yml`, and its assets' paths start below it. The target root is a configured setting resolved like
any other ([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)), so its default lives on the config type and no
function restates it. One folder per module keeps the mapping as small as a mapping can be: the module folder and the path still find the
real file with no per-asset declaration.

### No dot-prefixed folder

`Infrastructure stays at the root`

A leading dot means "infrastructure, not content" ([ADR-REPO-FOLDERS#4](conventional-folders.md#rule-adr-repo-folders4)), and the
dot-prefixed roots are infrastructure of the repository itself. Repeating `.github/` inside `contracts/` would put a dot-prefixed folder
below the root, where it marks nothing: the folder holds contract assets, which are content. Tools also treat a dot-prefixed folder as
hidden, so a listing skips the very assets a reviewer must see. The target root carries the dot instead, once, in `contracts.yml`, where it
names the real folder.

File names are different. A dotfile's name is the file's identity (`.gitignore` has no other spelling), so an asset that pins it repeats the
name, and the `.gitkeep` and `.frozen` records are files the mechanism itself defines. A target root can stand in for a folder, never for a
file name, so the rule stops at folders.

### Where back-compat is owed

`Why this is the one place back-compat is owed`

Backwards compatibility buys a grace period for consumers who cannot change in lockstep with the producer. Internally there are none, so
internally it is rejected. At the provided boundary there genuinely are, so a released provided contract stays live while a consumer pins
that version of its unit. There is no separate pin list: a released folder in the tree is pinned, and deleting it is the reviewed
retirement. The cost (a maintained old version folder) buys something real: it is the difference between an external consumer that keeps
working and one that breaks. Retirement is deliberate and evidence-based — a version folder goes away when no consumer pins it — not on a
guessed-at calendar.

A depended-on contract owes no grace period, because its outside party pins no version of the unit; it reads the files as they are. When the
platform changes what it expects, the only useful contract is the new expectation, so the change is made in the unit's draft and released
with the unit's next release. An old expectation the platform has dropped protects nothing.

### Binding, by contract testing

A contract is only a promise if breaking it is caught. The owning module carries the tests that assert the repository satisfies its assets:
every asset of its unit's current version folder (`0.0.0` on a devbox, the resolved version in a release build), and the provided assets of
every released version a consumer pins. The check follows the asset's kind (ADR-REPO-CONTRACT#6), so a change that violates a contract turns
the test run red before it ships. Without the test, "we keep this working" is a hope; with it, it is enforced.

### A released folder is frozen

Once a unit is released, that version's folder is not edited — a consumer builds against exactly those bytes. A fix or an evolution that
changes a contract lands in the unit's draft, `contracts/<unit>/0.0.0/`, and reaches the outside with that unit's next release; releasing
one unit freezes only that unit's draft. The draft exists precisely so a contract can be shaped before it becomes a binding promise. A
devbox build carries the `6.6.666` placeholder ([ADR-AUTO-BUNDLE#7](../automation/platform-bundle.md#rule-adr-auto-bundle7)), which is a
local convenience and not a release, so no `contracts/<unit>/6.6.666/` folder ever exists. This immutability is what lets a consumer pin a
version and trust it does not move underneath them.

### The name picks the kind

`Sensible defaults from the asset's own path`

An asset declares nothing: its kind, its target, and its owning module all come from where it sits and what it is called, with its module's
target root as the one declared folder ([zero-ceremony-poka-yoke](../automation/zero-ceremony-poka-yoke.md)). The four kinds are the four
things a boundary can require:

- **Presence** — an empty fragment: the real file at the same path under the target root must exist.
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
right for most assets, so most version folders carry no `contract.yml`; the one at `contracts/<unit>/<version>/contract.yml` overrides a
single asset's direction where the convention is wrong, such as a sample payload an outside platform requires of a call. It is part of the
version folder, so it freezes with it.

### Addressing many files

`Do the scan once the mode is known`

By default an asset addresses exactly one real file: the one at its own path (ADR-REPO-CONTRACT#6). Constraining many files with one asset —
by a manifest glob, by a per-folder file — is a configured mode, resolved like any setting
([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)). A mode that is not built throws `NotImplemented` rather
than half-working, and it is switched on by configuration only after it is proven from every engine
([ADR-AUTO-ENGINE](../automation/execution-engines.md)), since the mechanism runs under each of them. The match set is computed only once
the configured mode says what to match, so no tree walk runs on speculation.

### Rejected alternatives

1. **One unversioned contract set, evolved in place** — rejected: every change becomes a potential break for some consumer, and there is no
   way to support an old and a new shape at once. Version folders let the two coexist and be tested independently.

2. **A version per contract (`contracts/<contract-name>/v<N>/`)** — rejected: a consumer upgrades the catzc bundle, not individual
   contracts, so a separate number per contract forces a mapping from bundle to contract versions that the unit's version folder makes
   unnecessary.

3. **One repository-wide version (`contracts/<version>/<module>/`)** — rejected: the repository is a product mono-repository, not a
   monolithic application, so nothing versions the repository as a whole. A version exists only where a unit crosses the boundary, and each
   such unit versions on its own; one shared version would tie every unit's contracts to one release cadence that no consumer pins.

4. **Separate trees for provided and depended-on contracts** — rejected: both directions share the layout, the asset kinds, and the test
   mechanism; two trees would duplicate all three and split one owning module's boundary in two.

5. **Documenting the boundary in a README and trusting both sides** — rejected: a prose promise is not verified, so it drifts from the code
   and breaks consumers and platforms silently. A binding, tested contract catches the break in CI.

6. **A back-compat shim in internal code** (dual-read the old and new shape inside the implementation) — rejected: it smears the public
   boundary through internal code, which then can never reach [one living version](../principles/one-living-version.md). The compatibility
   belongs at the boundary, as a frozen version folder, not inside.

7. **Repeating the real file's repository-relative path, dot-prefixed folders included** — rejected: it puts a dot-prefixed folder below the
   root, where the dot marks content as infrastructure and hides the assets from a listing. A target root per module carries the dot once,
   in configuration.

8. **A target declared per asset** — rejected: it turns every asset into a registration and lets one module's assets scatter across
   unrelated folders. One target root per module keeps the path the mapping.

## Decision

`contracts/` holds every binding interface at the repository boundary: provided contracts, the only public API, and depended-on contracts,
what outside platforms require of our files and calls. It is laid out as `contracts/<unit>/<version>/<module>/<path>`, where the unit is the
deployable-unit that carries the contracts (`catzc`, the bundle), the version is that unit's, the module owns and tests the contract, and
the path is the real file's, relative to the module's target root: the repository root unless `contracts.yml` declares another folder for
the module. No folder under `contracts/` is dot-prefixed; a dot-prefixed root is reached through a target root. There is no repository-wide
version. Each unit's draft `0.0.0` is its only mutable folder, frozen only when that unit is released; a released version folder is kept
while a consumer pins its provided contracts. An asset's name picks its kind and its direction, a per-version `contract.yml` overrides the
direction, and many-file addressing is a configured mode. Every contract is verified by its owning module's tests, so a break is caught in
CI, not in production. Everything outside `contracts/` is internal and follows one living version.

### How this is enforced

- **`Catzc.Base.Contracts`** owns the mechanism: it enumerates `contracts/<unit>/<version>/**`, derives each asset's kind, direction, owning
  module, and target from the name, `contract.yml`, and the module's target root in `contracts.yml`, and runs the kind's check against the
  real tree as a quality gate (`Test-Contracts`). One data-driven L1 test file generates a test per binding asset from the same enumeration,
  so `Test-Automation` covers every contract with no hand-written test.

- **The dot-folder check** in `Test-Contracts` reports each dot-prefixed folder under `contracts/` as one issue, and passes dot-prefixed
  file names (ADR-REPO-CONTRACT#10).

- **The frozen-folder test** compares each released version folder with the `.frozen` record `Publish-ContractRelease` wrote at release, and
  fails on any file changed, added, or removed (ADR-REPO-CONTRACT#5).

- **`Build-ContractReference`** writes the per-unit reference pages from the assets' header comments, and `Test-GeneratedFiles` fails when
  one is stale (ADR-REPO-CONTRACT#9).

- **`.gitattributes`** marks every file in a version folder `catzc-contract`, generated from the `contract-asset` kind's `git` entry in
  the file-kinds registry ([ADR-REPO-ROOTCFG#1](generated-root-configs.md#rule-adr-repo-rootcfg1)), so the link and Markdown-title tools leave an asset as written:
  its bytes are what its check compares (ADR-REPO-CONTRACT#6), and a released folder stays byte-for-byte frozen (ADR-REPO-CONTRACT#5).

- **Code review** guards what the tests cannot phrase: that the boundary stays confined to `contracts/` (ADR-REPO-CONTRACT#1), that a
  retirement is justified by the absence of a pinning consumer (ADR-REPO-CONTRACT#3), and that a `contract.yml` override is the exception
  the convention calls for (ADR-REPO-CONTRACT#7).

## Consequences

- The boundary is explicit and small: what is in `contracts/` is promised or required; everything else is free to change with one living
  version.
- A platform's expectations are tested like a consumer's promises, so a workflow edit that GitHub would reject fails CI here first.
- An incompatible change to a provided contract never breaks a consumer silently — it reaches the outside only as a new version of its unit,
  and the pinned version keeps passing its tests until it is deliberately retired.
- Each unit that carries contracts versions on its own, so releasing one unit never freezes or re-versions another's contracts.
- Assets need no registration: the path under the module's target root is the target, the suffix is the kind, and the convention is the
  direction. A module whose files sit under one folder declares that folder once, not per asset.
- Every folder under `contracts/` is visible content: a dot-prefixed root of the repository appears there only as a module's target root.
- The internal code stays shim-free: backwards compatibility is a boundary concern, expressed as frozen version folders, not as dual-read
  paths threaded through implementations.
- The cost is real and bounded: each pinned version's provided contracts are maintained and tested for as long as a consumer pins them. That
  cost buys the one thing it should — external consumers that keep working across change.
