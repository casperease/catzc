# ADR: Contracts at the repository boundary — thin promises in both directions, current at 0.1.0, proven by tests

## Rules: ADR-REPO-CONTRACT

### Rule ADR-REPO-CONTRACT-BINDINGINTERFACE

A **contract** is a thin, checkable promise at the repository boundary, held under `contracts/`, and `contracts/` holds every one of them,
in both directions. A **provided contract** is what we promise the world: the only public API of the repository. A **depended-on contract**
is what the world promised us: the part of a vendor's shape our files and calls rely on, such as GitHub reading a workflow file or Azure
DevOps reading a pipeline. A contract records only what is bound across the boundary, never a copy of the whole shape, so a vendor stays a
vendor and not a dependency of every file. Everything else in the repository is internal and governed by
[one living version](../principles/one-living-version.md) (changed in place, no back-compat).

- [Both directions](#both-directions)
- [The only public API](#the-only-public-api)
- [Thin promises](#thin-promises)

### Rule ADR-REPO-CONTRACT-LAYOUT

Contracts are laid out as `contracts/<root>/<version>/<asset>`, with at most one **group** folder between the version and the asset:
`contracts/<root>/<version>/<group>/<asset>`. `<root>` names who made the promise: `catzc`, the repository itself, or one vendor by its
plain moniker (`azure`, `ado`, `github`, `python`, `npm`). `<version>` is a version folder (ADR-REPO-CONTRACT-CURRENTVERSION). A group
gathers related assets: in `catzc` it is the owning module in its repository normal form
([ADR-AUTO-IDIOM-NORMALFORM](../automation/idiomatic-names.md#rule-adr-auto-idiom-normalform), `catzc.base.contracts`), the module that
holds the tests that prove the contract; in a vendor root it is the vendor's area (`workflows`, `pipelines`, `templates`). No deeper folder
exists.

- [One root per promiser](#one-root-per-promiser)
- [Flat by design](#flat-by-design)

### Rule ADR-REPO-CONTRACT-CURRENTVERSION

Every root's current contracts live in one version folder, `0.1.0`: one living version, edited in place and checked on every run, and every
internal binding — a test, a generator, an editor setting, a link from one asset to another — points at `0.1.0`. The rest of the `0.1` range
is reserved for internal contract glue and holds no folder until a decision gives it one. `0.0.0` is never a folder. A version from `1.0.0`
up is a release of `catzc` (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE). The local build version `6.6.666` names a build made on a devbox and is
never a contract folder.

- [One current version](#one-current-version)
- [Three version ranges](#three-version-ranges)

### Rule ADR-REPO-CONTRACT-KEPTWHILEPINNED

A released provided contract is kept while a consumer pins that release of `catzc`. This is the one sanctioned backwards-compatibility in
the repository: external consumers genuinely exist at this boundary and cannot change in lockstep
([PDR-ONELIVE-PINNEDVERSIONNOTLEGACY](../principles/one-living-version.md#rule-pdr-onelive-pinnedversionnotlegacy)), and a release folder is
retired only when no consumer pins it — a deliberate, contract-driven deprecation, not a hedge. A vendor root never releases: it follows its
vendor, so a vendor's change is an edit in the vendor's `0.1.0`, never an old shape kept beside the new one.

- [Where back-compat is owed](#where-back-compat-is-owed)

### Rule ADR-REPO-CONTRACT-PROVENBYTESTS

Contracts are **binding**, proven by tests: every asset of every root's `0.1.0` is checked against the repository on every run, and so are
the provided assets of every `catzc` release folder still in the tree — release folders are the pin record, so retiring a release means
deleting its folder. A change that breaks a contract fails CI here, not a consumer or a vendor in production. This is what makes "kept for
back-compat" a guarantee rather than a hope.

- [Binding, by contract testing](#binding-by-contract-testing)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT-RELEASEDIMMUTABLE

A release folder, `contracts/catzc/<version>/` with a version from `1.0.0` up, is immutable. Releasing `catzc` copies its `0.1.0` as that
folder with `Publish-ContractRelease`, which writes the folder's `.frozen` record (the SHA-256 of each file), and `Test-Contracts` fails on
any file changed, added, or removed since. `0.1.0` is never frozen, and neither is the local build version.

- [A release folder is frozen](#a-release-folder-is-frozen)

### Rule ADR-REPO-CONTRACT-CONTRACTASSET

A **contract asset** is one file under a version folder, and its name alone picks its kind. With no suffix it is a fragment: each file it
applies to must exist and contain it — a key subset for YAML and JSON, the non-blank lines in order for any other text — and an empty
fragment requires presence only. `<name>.schema.json` is a schema each file it applies to validates against. `<name>.sample.<ext>` is a
sample payload the owning module's tests produce or parse, validated against the `<name>.schema.json` beside it when one exists.
`<command>.command.yml` is a command contract, the call interface of the command whose repository normal form is `<command>`
(`get_command_contract`), of the module its group names ([command-contracts](command-contracts.md)).

- [The name picks the kind](#the-name-picks-the-kind)

### Rule ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION

A contract asset's direction comes from its root: every asset under `catzc` is provided, and every asset under a vendor root is depended-on.
Nothing overrides it; an asset in the wrong direction is in the wrong root.

- [One root per promiser](#one-root-per-promiser)

### Rule ADR-REPO-CONTRACT-CONFIGUREDADDRESSING

A `catzc` fragment or schema names the repository files it applies to in its version folder's `contract.yml`, under `applies_to`: the
asset's path inside the version folder, mapped to a list of repository-relative globs over the tracked files. A vendor root holds nothing
local, so its assets are bound from the consumer end: the module that owns the bound files declares, in its `contract-bindings.yml`, which
vendor asset each of its globs depends on, and a vendor version folder has no `contract.yml`. Either way, an asset checks every file its
globs match, so one asset binds many files and one file may be bound by several assets. An entry that names no asset, names a sample or a
command contract, or matches no tracked file is a finding; and a fragment, or a schema with no sample beside it, that no entry names binds
nothing and is a finding too. The tracked files are listed only once an entry asks for them.

- [Addressing from the right end](#addressing-from-the-right-end)

### Rule ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS

An asset says what it pins in its own header comment — the leading `#` lines of a YAML asset, the `$comment` of a schema — and a vendor
asset also says its source and the date it was taken, so a reviewer can compare it with the vendor. `contracts/` holds only assets and their
`contract.yml` maps. `Build-ContractReference` generates one committed page per root, `docs/references/contracts/<root>.md`, with one table
per version folder listing every asset's group, the files it applies to, its direction, and its kind, and the assets' notes in a list under
the table. An asset whose check compares every byte or key — a presence asset, a text fragment, a JSON fragment or sample payload — carries
no note. The writer removes only pages it wrote, so a hand-written page in that folder is never touched.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT-NODOTFOLDERS

`contracts/` holds no dot-prefixed folder at any depth. A dot prefix marks infrastructure at the repository root
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), and every folder under `contracts/` is
a root, a version, or a group: content, never infrastructure. An asset that constrains a file under a dot-prefixed folder, such as
`.github/`, reaches it through a glob: in `applies_to` for a `catzc` asset, in the owning module's `contract-bindings.yml` for a vendor
asset. The rule covers folders, not file names: the root's `.gitkeep` and a release's `.frozen` record keep their names. `Test-Contracts`
reports each dot-prefixed folder.

- [No dot-prefixed folder](#no-dot-prefixed-folder)
- [How this is enforced](#how-this-is-enforced)

## Context

The [one-living-version](../principles/one-living-version.md) principle holds for the **inside** of the repository: every internal caller is
in the tree and moves with a change, so there is no external consumer to keep a back-compat shim alive for. But the repository has an
outside, and it meets that outside in two directions. Outside consumers build against what it promises, on their own upgrade schedule. And
vendors read what it holds — GitHub reads the workflow files and renders the READMEs, Azure DevOps reads the pipelines, Azure Resource
Manager reads the compiled templates — and break the delivery when a file stops matching what they expect.

`contracts/` is the structure for both. It makes the boundary explicit (so it is obvious what is a promise to or from the outside versus an
internal implementation detail), current at one version every binding points at (so nothing has to choose which one to trust), and testable
(so the boundary is verified mechanically, not asserted in a README).

### Both directions

`One tree, two directions`

A provided contract is a promise the repository makes; a depended-on contract is a promise a vendor made that the repository relies on. They
differ in who moves first: a consumer upgrades when it chooses, so a released provided contract must not move; a vendor changes when it
chooses, so a depended-on contract must follow it. They share everything else — a thin, binding shape, a check, and a test that turns red
when the shape breaks — so they share one tree, one layout, and one mechanism rather than two.

### The only public API

`Provided contracts are the only public API`

Everything outside `contracts/` is internal. A consumer that reaches past the provided contracts — into a module function, an internal
config schema, a data record — gets no compatibility promise and may break on any change, exactly as internal code does. This keeps the
public commitment small and deliberate: the repository promises what it puts in `contracts/catzc/`, and nothing else. A depended-on contract
promises nothing to a consumer; it records what a vendor requires, so the repository cannot break that vendor unnoticed.

### Thin promises

`Bind to the part that matters, and stay decoupled from the rest`

A vendor's full shape is neither small nor bounded — a workflow schema validates every action through hundreds of branches, a template
schema refs hundreds of resource schemas — and most of it is no promise to us at all, only the vendor's own detail. A contract that copied
it would bind every file to every corner of the vendor and break on changes that touch nothing we use. So a contract is thin: the keys,
types, and patterns our files actually rely on, trimmed from the vendor's source and stating where it was taken from. The same holds for a
provided contract: it promises the call interface or the payload shape a consumer reads, and leaves the implementation free under one living
version.

### One root per promiser

`Who promised it decides where it lives and which way it binds`

The first folder names who made the promise. `catzc` is the repository, so everything under it is what we promise the world. Every other
root is one vendor, named by its plain moniker, and everything under it is what that vendor promised us. The root is therefore the
direction: no per-asset declaration, no override, no prefix to tell an external root from ours. A promise the repository makes about its own
files to a vendor's reader — the keys GitHub reads from a workflow — is the vendor's promise to read them, so it lives under the vendor.

```text
contracts/
  catzc/                                              # what we promise the world
    0.1.0/                                            # the current contracts, every internal binding points here
      catzc.base.contracts/
        get_command_contract.command.yml              # command contract: the call interface of Get-CommandContract
      catzc.base.flow/
        actionable-fact.schema.json                   # schema of the sample beside it
        actionable-fact.sample.json                   # sample payload the module produces
      contract.yml                                    # applies_to: each catzc fragment or file schema to the files it binds
    1.0.0/                                            # a release, frozen while a consumer pins it
  github/                                             # what GitHub promised us: the vendor's shapes, nothing local
    0.1.0/
      workflows/
        workflow.yml.schema.json                      # the workflow shape GitHub reads
  ado/
    0.1.0/
      pipelines/
        pipeline.yaml.schema.json                     # the pipeline shape Azure DevOps reads
```

### Flat by design

`One group folder at most`

A contract is found by who promised it and what it is called. A deeper tree would only repeat the path of the file it binds, and the files a
contract binds are many, scattered, and often under dot-prefixed folders, so a mirrored path is either deep, dotted, or wrong. One optional
group folder keeps related assets together — a module's command contracts, a vendor's workflow shapes — and the version's `contract.yml`
says which files each asset binds.

### One current version

`Every internal binding points at 0.1.0`

Below `1.0.0`, a version folder is not a snapshot in time: it is the current contracts, edited in place and checked on every run. One such
folder per root is all the inside needs, so every test, generator, editor setting, and link between assets names `0.1.0` and never has to
choose. Layering the current contracts across several low versions would make every binding pick a layer and every move between layers an
edit of its callers, for an order the module dependency graph already keeps; so the rest of the `0.1` range stays reserved, empty until a
decision gives a folder there a meaning. `0.0.0` reads as "no version", so it is never a folder.

### Three version ranges

`Current, releases, local builds`

Every version a contract folder can carry falls in one range, and the range says what the folder is:

- `0.1.0` — the current contracts (ADR-REPO-CONTRACT-CURRENTVERSION), in every root; the rest of the `0.1` range is reserved for internal
  contract glue.
- `1.0.0` and up — a release of `catzc`, frozen and kept while pinned (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE,
  ADR-REPO-CONTRACT-KEPTWHILEPINNED). A vendor root has no releases.
- `6.6.666` — the local build version a devbox install carries
  ([ADR-AUTO-BUNDLE-AUTOVERSION](../automation/platform-bundle.md#rule-adr-auto-bundle-autoversion)): a local convenience, never a contract
  folder.

### Addressing from the right end

`The party that owns the bound files names them`

An asset's name says what kind of check it is; a glob map says what it checks, and the map sits with whoever owns the bound files. A `catzc`
asset is ours on both sides, so its version folder's `contract.yml` `applies_to` names the files. A vendor asset is the vendor's promise,
copied and hard-locked, and holds nothing of ours: no vendor asset is named after a repository file, and a vendor version folder has no
`contract.yml`. The module that owns the files a vendor reads declares the binding instead, in its `contract-bindings.yml`, so the vendor
root changes only when the vendor does, and a moved pipeline is a change in the module that moved it.

Every map is checked whole: every entry must name an asset and match a file, and every fragment and file schema must be named, so a moved
file or a renamed asset turns the check red instead of silently binding nothing.

```yaml
# pwsh/Catzc.Tooling.Github/configs/contract-bindings.yml
bindings:
  ".github/workflows/*.yml": github/0.1.0/workflows/workflow.yml.schema.json
```

```yaml
# contracts/catzc/0.1.0/contract.yml
applies_to:
  catzc.base.globs/file-kinds.yml: ["pwsh/Catzc.Base.Globs/configs/file-kinds.yml"]
```

### The name picks the kind

`Sensible defaults from the asset's own name`

An asset's kind comes from its name ([zero-ceremony-poka-yoke](../automation/zero-ceremony-poka-yoke.md)). The five kinds are the five
things a boundary can require:

- **Presence** — an empty fragment: each file it applies to must exist.
- **Fragment** — no suffix: each file it applies to must exist and contain the fragment. YAML and JSON compare by key subset, so the real
  file may carry more keys than the fragment names; any other text compares by its non-blank lines, which must appear in the real file in
  the same order.
- **Schema** — `<name>.schema.json`: each file it applies to validates against the JSON Schema, applied to YAML after parsing. A schema that
  shares its `<name>` with a sample payload beside it applies to that sample instead.
- **Sample payload** — `<name>.sample.<ext>`: a payload the owning module's tests must produce or parse, validated against the schema beside
  it when one exists.
- **Command contract** — `<command>.command.yml`, the command's repository normal form: the call interface of the command the group's module
  exports under that name, compared with the parse of the command's file ([command-contracts](command-contracts.md)).

A fragment pins only what the outside party reads, so the rest of the file stays free to change under one living version.

### No dot-prefixed folder

`Infrastructure stays at the root`

A leading dot means "infrastructure, not content"
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), and the dot-prefixed roots are
infrastructure of the repository itself. Repeating `.github/` inside `contracts/` would put a dot-prefixed folder below the root, where it
marks nothing: the folder holds contract assets, which are content. Tools also treat a dot-prefixed folder as hidden, so a listing skips the
very assets a reviewer must see. The binding glob names the dotted path instead, where it names the real folder: in `applies_to`, or in the
owning module's `contract-bindings.yml`.

### Where back-compat is owed

`Why this is the one place back-compat is owed`

Backwards compatibility buys a grace period for consumers who cannot change in lockstep with the producer. Internally there are none, so
internally it is rejected, and `0.1.0`, being current, owes none either. At the provided boundary there genuinely are consumers, so a
released provided contract stays live while a consumer pins that release. There is no separate pin list: a release folder in the tree is
pinned, and deleting it is the reviewed retirement. Retirement is deliberate and evidence-based — a release goes away when no consumer pins
it — not on a guessed-at calendar.

A depended-on contract owes no grace period, because its vendor pins no release of ours; it reads the files as they are. When the vendor
changes what it promises, the only useful contract is the new promise, so the vendor's `0.1.0` is edited in place. An old promise the vendor
has dropped protects nothing.

### Binding, by contract testing

A contract is only a promise if breaking it is caught. `Test-Contracts` checks every asset of every root's `0.1.0`, and the provided assets
of every `catzc` release a consumer pins. The check follows the asset's kind (ADR-REPO-CONTRACT-CONTRACTASSET), so a change that violates a
contract turns the test run red before it ships. Without the test, "we keep this working" is a hope; with it, it is enforced.

### A release folder is frozen

Once `catzc` is released, that release's folder is not edited — a consumer builds against exactly those bytes. A fix or an evolution lands
in `0.1.0` and reaches the outside with the next release, which freezes a copy of `0.1.0` again under its own version. A devbox build
carries the `6.6.666` placeholder, which is a local convenience and not a release, so no `contracts/catzc/6.6.666/` folder ever exists. This
immutability is what lets a consumer pin a release and trust it does not move underneath them.

### Rejected alternatives

1. **One unversioned contract set, evolved in place** — rejected: it cannot hold a frozen release beside the current shape. `0.1.0` is the
   current shape, release folders the pins.

2. **A version per contract (`contracts/<contract-name>/v<N>/`)** — rejected: a consumer upgrades the catzc bundle, not individual
   contracts, so a separate number per contract forces a mapping from bundle to contract versions that a release folder makes unnecessary.

3. **A mutable draft at `0.0.0`, frozen at every release** — rejected: `0.0.0` reads as "no version", and freezing a vendor's shape records
   nothing the vendor will honour. `0.1.0` is current, and only `catzc` releases freeze.
4. **Separate trees for provided and depended-on contracts** — rejected: both directions share the layout, the asset kinds, and the test
   mechanism; the root already tells them apart, so a second tree would only duplicate the first.

5. **Documenting the boundary in a README and trusting both sides** — rejected: a prose promise is not verified, so it drifts from the code
   and breaks consumers and vendors silently. A binding, tested contract catches the break in CI.

6. **A back-compat shim in internal code** (dual-read the old and new shape inside the implementation) — rejected: it smears the public
   boundary through internal code, which then can never reach [one living version](../principles/one-living-version.md). The compatibility
   belongs at the boundary, as a frozen release folder, not inside.

7. **Mirroring each bound file's path under the version folder** — rejected: the bound files sit at any depth and under dot-prefixed
   folders, so the mirror is deep, dotted, or needs a per-module target root to relocate it, and it still binds only one file per asset. The
   version's `applies_to` names the files once, as globs, in a flat tree.

8. **A vendor marked by a prefix (`EXTERNAL-<vendor>`)** — rejected: the root already says who promised, and everything outside `catzc` is a
   vendor, so the prefix only lengthens every path.

9. **Copying a vendor's whole schema** — rejected: it binds our files to the vendor's every detail and breaks on changes we never use; a
   thin contract binds the part we rely on.

10. **Layers of current contracts across several low versions (`0.0.1`, `0.1.0`, `0.1.1`)** — rejected: every binding would have to pick a
    layer and every move between layers would edit its callers, for an order the module dependency graph already keeps. One current version
    is easier to maintain; the `0.1` range stays reserved.

11. **A vendor version folder's own `applies_to`** — rejected: it puts our file names inside the vendor's hard-locked promise, so moving a
    pipeline edits the vendor root, and a vendor update has to merge around our paths. The module that owns the files binds them.

## Decision

`contracts/` holds every thin promise at the repository boundary: `contracts/catzc/` what we promise the world, the only public API, and one
root per vendor for what that vendor promised us. It is laid out as `contracts/<root>/<version>/[<group>/]<asset>`, at most one group deep.
Every root's current contracts live in `0.1.0`, edited in place and always checked, and every internal binding points there; the rest of the
`0.1` range is reserved, `0.0.0` is never a folder, `1.0.0` and up are frozen `catzc` releases kept while pinned, and `6.6.666` is a local
build, never a folder. An asset's name picks its kind and its root its direction; a `catzc` asset's version folder `contract.yml` names the
files it binds, and a vendor asset's bound files are named by the module that owns them, in its `contract-bindings.yml`. Every contract is
verified by tests, so a break is caught in CI, not in production. Everything outside `contracts/` is internal and follows one living
version.

### How this is enforced

- **`Catzc.Base.Contracts`** owns the mechanism: it enumerates `contracts/<root>/<version>/**`, derives each asset's kind from its name, its
  direction from its root, and the files it binds from `contract.yml` or the owning module's `contract-bindings.yml`, and runs the kind's
  check against the real tree as a quality gate (`Test-Contracts`). One data-driven L1 test file generates a test per binding asset from the
  same enumeration, so `Test-Automation` covers every contract with no hand-written test.

- **The layout check** in `Test-Contracts` reports a version folder other than `0.1.0` below `1.0.0`, a `6.6.666` folder, a release folder
  under a vendor root, a folder deeper than one group, and each dot-prefixed folder (ADR-REPO-CONTRACT-LAYOUT,
  ADR-REPO-CONTRACT-CURRENTVERSION, ADR-REPO-CONTRACT-NODOTFOLDERS).

- **The frozen-folder test** compares each release folder with the `.frozen` record `Publish-ContractRelease` wrote at release, and fails on
  any file changed, added, or removed (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).

- **`Build-ContractReference`** writes the per-root reference pages from the assets' header comments and the `contract.yml` maps, and
  `Test-GeneratedFiles` fails when one is stale (ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS).

- **`.gitattributes`** marks every file under `contracts/` `catzc-contract`, generated from the `contract-asset` kind's `git` entry in the
  file-kinds registry ([ADR-REPO-ROOTCFG-FULLYMANAGED](generated-root-configs.md#rule-adr-repo-rootcfg-fullymanaged)), so the link and
  Markdown-title tools leave an asset as written: its bytes are what its check compares (ADR-REPO-CONTRACT-CONTRACTASSET), and a release
  folder stays byte-for-byte frozen (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).

- **Code review** guards what the tests cannot phrase: that the boundary stays confined to `contracts/`
  (ADR-REPO-CONTRACT-BINDINGINTERFACE), that a contract stays thin, and that a retirement is justified by the absence of a pinning consumer
  (ADR-REPO-CONTRACT-KEPTWHILEPINNED).

## Consequences

- The boundary is explicit and small: what is in `contracts/` is promised or relied on; everything else is free to change with one living
  version.
- Who promised a contract is the first thing its path says, and the direction follows from it with no declaration.
- A vendor's expectations are tested like a consumer's promises, so a workflow edit that GitHub would reject fails CI here first, and the
  thin shape keeps the vendor's unrelated changes from breaking us.
- Every internal binding names one version, `0.1.0`, so no caller chooses between versions and none moves when a contract changes.
- An incompatible change to a provided contract never breaks a consumer silently — it reaches the outside only as a new release, and the
  pinned release keeps passing its tests until it is deliberately retired.
- The tree stays flat: one root, one version, at most one group, then the asset; the files an asset binds are named once, in its version's
  map.
- The internal code stays shim-free: backwards compatibility is a boundary concern, expressed as frozen release folders, not as dual-read
  paths threaded through implementations.
- The cost is real and bounded: each pinned release's provided contracts are maintained and tested for as long as a consumer pins them, and
  each `contract.yml` must name every fragment and file schema it holds.
