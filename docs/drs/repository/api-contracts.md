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
plain moniker (`azure`, `ado`, `github`, `python`, `npm`). A shape we wrote is an inner contract and lives in `catzc` under its owning
module's group, even when it describes a file a vendor reads; a vendor root exists only to hold a shape the vendor ships, copied verbatim,
so today `catzc` is the only root. `<version>` is a version folder (ADR-REPO-CONTRACT-CURRENTVERSION). A group gathers related assets: in
`catzc` it names the owning module, the module that holds the tests that prove the contract, by where the module lives: its track and its
folder in the repository normal form ([ADR-AUTO-IDIOM-NORMALFORM](../automation/idiomatic-names.md#rule-adr-auto-idiom-normalform),
`pwsh.base.contracts` for `Catzc.Base.Contracts`), never the namespace the module carries. The form and its rare exceptions are declared
once, in the contracts config, and one resolver turns a module into its group and back. In a vendor root a group is the vendor's area
(`workflows`, `pipelines`, `templates`). A group may hold one level of folders that sort its assets by the format they describe
(`pwsh.azure.templates/arm/` for the compiled ARM template's schema), so the tree is
`contracts/<root>/<version>/[<group>/[<folder>/]]<asset>` and an asset's key is its path below the version folder. Such a folder holds
schemas, fragments, presence assets and samples; a command contract, the types surface and the types schema belong to the group itself. No
deeper folder exists.

- [One root per promiser](#one-root-per-promiser)
- [Flat by design](#flat-by-design)

### Rule ADR-REPO-CONTRACT-CURRENTVERSION

Every root's current contracts live in one version folder, `0.1.0`: one living version, edited in place and checked on every run, and every
internal binding — a test, a generator, an editor setting, a link from one asset to another — points at `0.1.0`. The rest of the `0.1` range
is reserved for internal contract glue and holds no folder until a decision gives it one. `0.0.0` is never a folder. A version from `1.0.0`
up is a release of `catzc` (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE). The local build version `6.6.666` names a build made on a devbox and is
never a contract folder ([ADR-AUTO-BUNDLE-BUNDLEVERSION][r1]). A vendor root has no releases.

- [One current version](#one-current-version)

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
sample payload the owning module's tests produce or parse, validated against the `<name>.schema.json` beside it when one exists, which then
applies to that sample instead of the files `applies_to` names. YAML is parsed before a schema applies. `<command>.command.yml` is a command
contract, the call interface of the command whose repository normal form is `<command>` (`get_command_contract`), of the module its group
names, compared with the parse of the command's file ([command-contracts](command-contracts.md)). `types.json` is a types surface, the
public types the group's module compiles with their accelerators, display properties and public members, generated from the types assembly
and never written by hand, and validated against the one `types.schema.json` in the contracts tooling's group; every catzc type a command
contract names is listed in some group's surface, and a module with types publishes a surface even with no command contract. A fragment pins
only what the outside party reads, so the rest of the file stays free to change.

### Rule ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION

A contract asset's direction comes from its root: every asset under `catzc` is provided, and every asset under a vendor root is depended-on.
Nothing overrides it; an asset in the wrong direction is in the wrong root.

- [One root per promiser](#one-root-per-promiser)

### Rule ADR-REPO-CONTRACT-CONFIGUREDADDRESSING

A fragment or a schema names the repository files it applies to in its version folder's `contract.yml`, under `applies_to`: the asset's path
inside the version folder, mapped to a list of repository-relative globs over the tracked files. An asset `applies_to` names checks every
file its globs match, so one asset binds many files and one file may be bound by several assets. An entry that names no asset, names a
sample or a command contract, or matches no tracked file is a finding; and a fragment, or a schema with no sample beside it, that
`applies_to` does not name binds nothing and is a finding too. The tracked files are listed only once an entry asks for them.

- [Addressing by the version's map](#addressing-by-the-versions-map)

### Rule ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS

An asset says what it guarantees in one plain sentence it holds itself: the `description` key of a command contract, which is its command's
help synopsis stripped of links, rule codes and markup, the `$comment` of a schema, or the leading `#` lines of another YAML asset. The
sentence is letters, digits, spaces and `. , - ( ) '` only, on one line, so a YAML plain scalar holds it unquoted, and `Test-Contracts`
checks that form and that a command contract's `description` equals its command's synopsis. A vendor-shaped schema also says its source and
the date it was taken in its `description` annotation, so a reviewer can compare it with the vendor; a sample payload says nothing, since a
key would change what it pins. `contracts/` holds only assets and their `contract.yml` maps. `Build-ContractReference` generates one
committed page per root, `docs/references/contracts/<root>.md`, with one table per version folder listing every asset's group, the files it
applies to, its direction, and its kind, and the assets' notes in a list under the table. An asset whose check compares every byte or key —
a presence asset, a text fragment, a JSON fragment or sample payload — carries no note. The writer removes only pages it wrote, so a
hand-written page in that folder is never touched.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT-NODOTFOLDERS

`contracts/` holds no dot-prefixed folder at any depth. A dot prefix marks infrastructure at the repository root
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), and every folder under `contracts/` is
a root, a version, or a group: content, never infrastructure. An asset that constrains a file under a dot-prefixed folder, such as
`.github/`, reaches it through `applies_to`. The rule covers folders, not file names: the root's `.gitkeep` and a release's `.frozen` record
keep their names. `Test-Contracts` reports each dot-prefixed folder.

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
direction: no per-asset declaration, no override, no prefix to tell an external root from ours. A shape we wrote about our own files for a
vendor's reader — the keys GitHub reads from a workflow — is our promise, so it lives under `catzc` in its owning module's group.

```text
contracts/
  catzc/                                              # what we promise the world
    0.1.0/                                            # the current contracts, every internal binding points here
      pwsh.azure.dev_ops/                             # a group: the owning module's track and folder
        pipeline.yaml.schema.json                     # our schema of the pipeline files Azure DevOps reads
      pwsh.base.contracts/
        get_command_contract.command.yml              # command contract: the call interface of Get-CommandContract
      pwsh.base.flow/
        actionable-fact.schema.json                   # schema of the sample beside it
        actionable-fact.sample.json                   # sample payload the module produces
      pwsh.tooling.github/
        workflow.yml.schema.json                      # our schema of the workflow files GitHub reads
      contract.yml                                    # applies_to: each fragment or file schema to the files it binds
    1.0.0/                                            # a release, frozen while a consumer pins it
```

### Flat by design

`One group folder at most, and one sorting folder in it`

A contract is found by who promised it and what it is called. A deeper tree would only repeat the path of the file it binds, and the files a
contract binds are many, scattered, and often under dot-prefixed folders, so a mirrored path is either deep, dotted, or wrong. One optional
group folder keeps related assets together — a module's command contracts, its schemas of the files a vendor reads — and the version's
`contract.yml` says which files each asset binds. The group is named by the module's track, not its namespace: the namespace is already the
root, so repeating it in every group says nothing, while the track says which language the contract's module is written in, and a group read
in a listing points straight at the folder that holds the module. A group that describes several formats may sort its schemas into one
folder per format (`arm/`), never deeper: the folder names the format a schema describes, not the path of the files it binds.

### One current version

`Every internal binding points at 0.1.0`

Below `1.0.0`, a version folder is not a snapshot in time: it is the current contracts, edited in place and checked on every run. One such
folder per root is all the inside needs, so every test, generator, editor setting, and link between assets names `0.1.0` and never has to
choose. Layering the current contracts across several low versions would make every binding pick a layer and every move between layers an
edit of its callers, for an order the module dependency graph already keeps; so the rest of the `0.1` range stays reserved, empty until a
decision gives a folder there a meaning. `0.0.0` reads as "no version", so it is never a folder.

### Addressing by the version's map

`One map per version folder says which files each asset binds`

An asset's name says what kind of check it is; the version folder's `contract.yml` says what it checks. `applies_to` maps each fragment or
schema to repository-relative globs, matched against the tracked files only once an entry asks, so a thin workflow schema binds every
workflow file and a fragment binds the one file it pins. The map is the only place a target is named, it is checked whole — every entry must
name an asset and match a file, and every fragment and file schema must be named — so a moved file or a renamed asset turns the check red
instead of silently binding nothing.

```yaml
# contracts/catzc/0.1.0/contract.yml
applies_to:
  pwsh.tooling.github/workflow.yml.schema.json: [".github/workflows/*.yml"]
  pwsh.base.globs/file-kinds.yml: ["pwsh/Base.Globs/configs/file-kinds.yml"]
```

### No dot-prefixed folder

`Infrastructure stays at the root`

A leading dot means "infrastructure, not content"
([ADR-REPO-FOLDERS-DOTMEANSTOOLING](conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), and the dot-prefixed roots are
infrastructure of the repository itself. Repeating `.github/` inside `contracts/` would put a dot-prefixed folder below the root, where it
marks nothing: the folder holds contract assets, which are content. Tools also treat a dot-prefixed folder as hidden, so a listing skips the
very assets a reviewer must see. `applies_to` names the dotted path instead, as a glob, where it names the real folder.

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

A contract is only a promise if breaking it is caught. The check follows the asset's kind (ADR-REPO-CONTRACT-CONTRACTASSET), so a change
that violates a contract turns the test run red before it ships. `Test-Contracts` covers every asset of every root's `0.1.0`, plus the
provided assets of every `catzc` release a consumer pins.

### A release folder is frozen

Once `catzc` is released, that release's folder is not edited — a consumer builds against exactly those bytes. A fix or an evolution lands
in `0.1.0` and reaches the outside with the next release, which freezes a copy of `0.1.0` again under its own version. A devbox build
carries the `6.6.666` placeholder, which is a local convenience and not a release, so no `contracts/catzc/6.6.666/` folder ever exists. This
immutability is what lets a consumer pin a release and trust it does not move underneath them.

### Rejected alternatives

1. **Another version scheme** — rejected, each for the same reason: only one current folder beside frozen releases fits.
   - One unversioned contract set, evolved in place: it cannot hold a frozen release folder beside the current `0.1.0`.
   - A mutable draft at `0.0.0`, frozen at every release: `0.0.0` reads as "no version", and freezing a vendor's shape records nothing the
     vendor will honour. `0.1.0` is current, and only `catzc` releases freeze.
   - Layers of current contracts across several low versions (`0.0.1`, `0.1.0`, `0.1.1`): every binding would have to pick a layer and every
     move between layers would edit its callers, for an order the module dependency graph already keeps. The `0.1` range stays reserved.

2. **Another tree shape** — rejected: the bundle and the files it binds fix the shape.
   - A version per contract (`contracts/<contract-name>/v<N>/`): a consumer upgrades the catzc bundle, not individual contracts, so a
     separate number per contract forces a mapping from bundle to contract versions that a release folder makes unnecessary.
   - Mirroring each bound file's path under the version folder: the bound files sit at any depth and under dot-prefixed folders, so the
     mirror is deep, dotted, or needs a per-module target root, and it still binds only one file per asset. The version's `applies_to` names
     the files once, as globs, in a flat tree.

3. **Separate trees for provided and depended-on contracts** — rejected: both directions share the layout, the asset kinds, and the test
   mechanism; the root already tells them apart, so a second tree would only duplicate the first.

4. **Documenting the boundary in a README and trusting both sides** — rejected: an unverified promise drifts; a tested contract fails in CI.

5. **A back-compat shim in internal code** (dual-read the old and new shape inside the implementation) — rejected: it smears the public
   boundary through internal code, which then can never reach [one living version](../principles/one-living-version.md). The compatibility
   belongs at the boundary, as a frozen release folder, not inside.

6. **A vendor marked by a prefix (`EXTERNAL-<vendor>`)** — rejected: the root already says who promised, so the prefix only adds length.

7. **Copying a vendor's whole schema** — rejected: it breaks on vendor changes we never use; a thin contract binds what we rely on.

8. **A vendor root for a shape we wrote** — rejected: a schema we trimmed from a vendor's is our promise about our files, not the vendor's,
   so filing it under the vendor's name misstates who holds it and splits one mechanism in two. It lives in `catzc` under its owning
   module's group, and a vendor root waits for a shape the vendor ships that we copy verbatim.

## Decision

The rules above are the decision; this section holds how they are enforced.

### How this is enforced

- **`Catzc.Base.Contracts`** owns the mechanism: it enumerates `contracts/<root>/<version>/**`, derives each asset's kind from its name, its
  direction from its root, and the files it binds from `contract.yml`, and runs the kind's check against the real tree as a quality gate
  (`Test-Contracts`). One data-driven L1 test file generates a test per binding asset from the same enumeration, so `Test-Automation` covers
  every contract with no hand-written test.

- **The layout check** in `Test-Contracts` reports a version folder other than `0.1.0` below `1.0.0`, a `6.6.666` folder, a release folder
  under a vendor root, a folder deeper than one group and one folder, and each dot-prefixed folder (ADR-REPO-CONTRACT-LAYOUT,
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

[r1]: ../automation/platform-bundle.md#rule-adr-auto-bundle-bundleversion
