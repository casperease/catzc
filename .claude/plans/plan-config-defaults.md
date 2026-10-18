---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets:
    [
      automation/Catzc.Base.Variants,
      automation/Catzc.Base.Overlay,
      automation/Catzc.Base.Contracts,
      automation/Catzc.Base.Config,
      docs/adr/automation,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-config-defaults.md"
    folder: plans
    name: plan-config-defaults
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#{5,6}
      - ADR-AUTO-OVERLAY#{1,4,8}
      - ADR-CATS#5
      - ADR-PRIN-CONFIG#3
      - ADR-REPO-CONTRACT#{3,6,9}
    links:
      - ".claude/plans/plan-layers-vocabulary-rename-contracts.md"
      - ".claude/plans/plan-module-kinds-tracks.md"
      - ".claude/plans/prompt-config-defaults-continue.md"
---

# Config defaults: declared once on the type, overridden by a repo fragment, pinned by a contract

Pilot is variants (VariantsConfig). The model to copy is ContractsConfig: const defaults, constructor sets them, null means default, unknown
keys rejected. The decisions below are the session's recommendations taken as decisions (2026-10-16 15:35): the user's message did not
restate answers to Q1 to Q7, the draft's provenance note says so, and the user is asked to confirm or change them. A continuation prompt for
a fresh session is written. Phase 1 can start now; Phase 2 waits for the module model.

## Why its value is high

ADR-AUTO-DEFAULT#6 already rules the resolution order and says the type declares the default exactly once. VariantsConfig breaks it in five
getters, and the shipped variants.yml and the code disagree on have_customers today. A rule the tree breaks is worth more than a new rule.
It generalises to every typed config in configs.yml.

## Decided, and why (Q1 to Q7 confirmed by the user in the questionnaire round of 2026-10-16, Q13 to Q21; Q6 reframed)

- Q6 is reframed: .catzc and .cats are not canonical and alias. cats and catzc, their distinction and their cross-purpose use are a core
  product principle to be ruled by a new ADR-CATS (plan-adr-cats); the overlay and fragment folder names follow from it.
- ADR-CATS#5 rules the folder (2026-10-17): `.catzc/` only, for the overlay root and this repository's own fragment root; no `.cats/` alias
  is written or read (supersedes Q6's alias). The overlay root tests read the name from the rule.
- Q20 Phase 1 waits for the module model too (shared VariantsConfig.cs); Q21 the assert ladder is a section in ADR-AUTO-FAILFAST.
- F5, Q101, S5: every config type is audited into a posture; every -Default literal in a getter goes; the contract folder gains one defaults
  file per type; an analyzer rule flags a literal default in a function and keeps it so (the audit script is its seed; ADR-PRIN-CONFIG#3 is
  its rule). The fragment folder name waits for ADR-CATS.

- Q1 have_customers defaults to false; this repo's fragment sets all. Q2 tracks is required (throws when omitted or empty); aspects defaults
  to a universal catch-all per track. Q3 the shipped variants.yml is deleted; a typed config with no file is built from an empty map plus
  the fragment. Q4 a new contract asset kind, defaults. Q5 source mode reads this repo's own config fragments only. Q6 .catzc/ is canonical
  and .cats/ is read as an alias. Q7 a required key is listed in a header comment of the generated contract file, not given a value.
- A default is declared once, on the config type, as constants; no getter restates it; Get-Variant loses -Default.
- Every property has one posture: defaulted, empty-is-valid, or required (throws at construction naming the key and the fix).
- Variants: ado_naming standard; git_workspace main-direct; have_customers false (this repo's fragment says all); aspects a per-track
  universal catch-all when a track has no entry; tracks required.
- This repo's own data (tracks, aspects, have_customers) moves to .catzc/\<track>\/Catzc.Base.Variants/configs/variants.yml and the
  module-shipped variants.yml is deleted. A registered type with no shipped file is built from an empty map plus the fragment.
- The overlay reads this repo's own .catzc/ config fragments only, in source mode; function and asset overrides, local modules and local
  tests stay build-only. Canonical .catzc/; .cats/ is a read alias never written; both present is one error.
- A generated contract contracts/catzc/0.0.0/\<Module>/configs/\<name>.yml publishes the type's full defaults: asset kind defaults,
  direction provided by convention; defaulted keys show literals, empty-valid keys show empty, a required key is named in a header comment
  and omitted. A gate compares regenerated defaults to the file. Releasing freezes them (ADR-REPO-CONTRACT#3, #5).
- Assert ladder: construct-time, load-time, cross-config, contract-time, repo-time; named in an ADR in Phase 5.
- With the layers plan: the fragment root is resolver-based, so the pwsh rename changes the folder only (.catzc/pwsh/).

## Done, and why (session report of 2026-10-16 15:35; nothing in code is built)

- The draft rewritten with the decisions as section 6, the phases (Phase 2 split in two) and section 7 on interactions with other plans.
- .unordered/15-10-2026/plan-contracts.md amended: an earlier plan had rejected "defaults as contract YAML"; that row now says the new
  contract file is generated from the type, so it publishes the one declaration instead of adding a second (ADR-PRIN-ONELIVE).
- The module-model draft says every new config key gets its default on the type and that this plan's Phase 2 waits for it (it still edits
  variants.yml). The layers master and worklist note that variants.yml's data moves to the repo's .catzc/ fragment. The layer model draft
  says ImporterConfig follows the same pattern. Memory config-defaults-plan.md written.
- Dirty files to respect: Get-Track.ps1 and its test were already modified in the user's working tree; the next session tells the user
  before editing them.

## Needed docs

- Amend ADR-AUTO-DEFAULT#6 (posture per config, contracted defaults), ADR-AUTO-OVERLAY#1 and #8 (the repo's own overlay in source mode,
  .cats alias), ADR-REPO-CONTRACT#6 (the defaults asset kind), ADR-CONF-LOADING (type with no shipped file). The assert ladder.
- Re-cite with Update-AdrCitation; regenerate the affected reference pages; header note on the asset per ADR-REPO-CONTRACT#9.

## Needed tests

- VariantsConfig.Tests and the five getters with neutral fixtures; a required key throws with key and fix in the message.
- Get-CatzcOverlayRoot and Get-ConfigOverlayRoot source-mode tests; both .catzc and .cats present is one error.
- Build-ConfigDefaultsContract output checked by Test-Contracts and Test-GeneratedFiles; Build-ContractReference lists it.
- An audit script in out/ over every registered config type: empty map constructs, which properties are null; three postures.
- Sealed configs take defaults but no fragment.

## Open steps

- [ ] ADR-CATS names the consumer overlay and this repo's fragment folders (check: plan-adr-cats decided section).
- [ ] Copy the plan and prompt to the scratchpad, paste prompt-config-defaults-continue.md into a fresh session (check: Phase 1 report).
- [ ] Phase 1 variants types carry defaults (check: VariantsConfig.Tests and getter tests pass; have_customers agrees).
- [ ] Phase 2 repo fragment and source-mode overlay, after the module model is implemented (check: overlay root tests pass; shipped file
      gone).
- [ ] Phase 3 generated defaults contract (check: Test-Contracts, Test-GeneratedFiles clean).
- [ ] Phase 4 one config per change (check: each config's own tests).
- [ ] Phase 5 ADRs and re-citation (check: Test-Links, Test-AdrRegistry clean).

## Refs

- prompt-config-defaults-continue.md (beside this file)
- the full draft is carried below (formerly out/plan-config-defaults.md; section 6 decisions, section 7 cross-plan interactions)
- docs/adr/automation/sensible-defaults.md, docs/adr/automation/consumer-overlay.md
- docs/adr/configuration/module-config-loading.md, docs/adr/repository/api-contracts.md
- memory: config-defaults-plan.md

## Carried: out/plan-config-defaults.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

## Plan: config defaults — coded, overridable by a repo fragment, pinned by a contract

Status: **decisions recorded 2026-10-16**, nothing built. Pilot: `variants` (`Catzc.Base.Variants.VariantsConfig`). Generalises to every
typed config in `configs.yml`. Continuation prompt: [prompt-config-defaults-continue.md](prompt-config-defaults-continue.md).

**Provenance of the decisions.** The user asked to "update the plan files with the decisions" after the Q1–Q7 round without restating
answers, so each decision below is the recommendation of the first draft, taken as accepted. Anything the user later overrides is a one-line
edit in section 6 and a note in the affected phase. Do not re-ask them; do flag a contradiction found in the tree.

## 1. What we found (facts, read 2026-10-16)

- **Resolution order is already ruled** (`ADR-AUTO-DEFAULT#6`, `ADR-AUTO-OVERLAY#4`): caller → overlay fragment → Markdown contributions →
  shipped `configs/<name>.yml` → **type default, "declared exactly once, on the config type; no function restates it"**.
- **`VariantsConfig` breaks that rule.** All five keys (`ado_naming`, `git_workspace`, `have_customers`, `aspects`, `tracks`) are `null`
  when unset. The defaults live as `-Default` literals in five getters: `Get-AdoNaming` ('standard'), `Get-GitWorkspace` ('main-direct'),
  `Get-EnabledCustomers` (`$false`), `Get-Aspect` (a local `$default`), `Get-Track` (`@()`).
- **They already disagree:** shipped `variants.yml` says `have_customers: all`; the restated code default is `$false`.
- **`ContractsConfig` is the model to copy**: `public const string DefaultAddressing`, `DefaultTargetRoot`; the constructor sets defaults
  first, treats `null` as "use the default", rejects unknown keys.
- **`DictionaryRecord.Contains(key)` is false for a null property.** Once a property has a non-null default, `Get-Variant`'s `-Default` is
  dead code, and `Contains` becomes true for every defaulted key.
- **The overlay is build-mode only** and reads `<RepositoryRoot>/.catzc/<track>/<Module>/configs/<name>.yml` (`Get-CatzcOverlayRoot`,
  `ADR-AUTO-OVERLAY#8`). The track folder is `automation` today and becomes `pwsh` in the rename plan (P4). No `.catzc/` or `.cats/` folder
  exists in this repo; `.cats` appears in code only inside the overlay files.
- **Contracts today** (`ADR-REPO-CONTRACT#6`): a fragment asset at `contracts/catzc/0.0.0/<Module>/<path>` is a _key-subset check against
  the real shipped file_. It does **not** check the type's coded defaults. `0.0.0` is the mutable draft; frozen folders are immutable and
  hash-recorded (`Publish-ContractRelease`, `.frozen`).
- **An earlier plan rejected "defaults as contract YAML"** (`.unordered/15-10-2026/plan-contracts.md`, the eac comparison row "System
  defaults live in `contracts/…/defaults/`": _Not adopted, defaults are declared once on the config type_). This plan keeps that rule and
  changes only the mechanism: the contract file is **generated from** the type, so it is a published view of the one declaration, not a
  second one (`ADR-PRIN-ONELIVE`). That row has been updated to say so.

## 2. The design

Three artefacts per config, each with one job:

| Artefact                 | Where                                                                    | Job                                                                          | Who writes it                                  |
| ------------------------ | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------- | ---------------------------------------------- |
| **Coded defaults**       | constants on the config type (`VariantsConfig.cs`)                       | the _only_ declaration of "what an omitted key means"                        | human, in C#                                   |
| **This repo's fragment** | `.catzc/<track>/<Module>/configs/<name>.yml` (`.cats/` read as an alias) | this repo's own choices (tracks, aspects, customers…), keys that differ only | human, YAML                                    |
| **Contracted defaults**  | `contracts/catzc/0.0.0/<Module>/configs/<name>.yml`                      | the _full effective defaults of the type_, published as a provided contract  | **generated** from the type, never hand-edited |

Consequences:

1. **The module-shipped `configs/variants.yml` is deleted.** What it holds today (`tracks`, `aspects`, `have_customers`) is this
   repository's data model, not a default; it moves to the repo fragment. General rule (new, `ADR-CONF-LOADING`): a **registered type with
   no shipped file is built from `{}` plus the fragment**. `Resolve-ConfigEntry`, `Get-Config` (`Assert-PathExist`), `Test-ShippedConfigs`,
   `Test-ConfigValidators` and `-ListOwners` change to match.
2. **The contract is generated, then checked both ways.** Generator = construct the type from `{}`, serialise every property in declared
   order, write the result to the `0.0.0` contract path. Gate = regenerate in memory and compare to the file (`Test-GeneratedFiles` style,
   `ADR-REPO-CONTRACT#9`). A changed coded default without a regenerated contract fails CI; a hand-edited contract fails CI.
3. **Releasing freezes the defaults.** Once `catzc` 1.0.0 is released, `contracts/catzc/1.0.0/…/variants.yml` promises a consumer who sets
   nothing exactly these values. A later default change is a new `0.0.0` draft and a visible diff (`ADR-REPO-CONTRACT#3`, the one place
   back-compat is owed).
4. **New asset kind `defaults`, direction provided by convention.** The name picks the kind (`contracts/…/<Module>/configs/<name>.yml` whose
   module ships a registered type of that name); no `contract.yml` override per asset.
5. **The overlay reads this repo's own `.catzc/` in source mode, config fragments only.** Function overrides, asset overrides, local modules
   and local tests stay build-only. Amends `ADR-AUTO-OVERLAY#8`.
6. **Spelling.** Canonical `.catzc/`; `.cats/` is read as an alias and never written. Both present at once is an error reported in one
   failure. One implementation of the root lookup (`Get-CatzcOverlayRoot`), so the alias is not threaded through callers.

## 3. Null / empty / unknown policy — "sensible, or honest"

Every config property declares exactly one of three postures (a stable-but-honest rule per property, instead of an accident of `null`):

- **Defaulted** — omitted, `null`, or empty means the declared default.
- **Empty-is-valid** — omitted means an honestly empty collection; every reader handles empty.
- **Required** — no default makes sense (`ADR-AUTO-DEFAULT#5`): omitted or empty **throws at construction**, naming the key and the fix.

Decided posture for the five variants:

| Key              | Posture      | Default / failure                                                                                                                         |
| ---------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `ado_naming`     | defaulted    | `standard`                                                                                                                                |
| `git_workspace`  | defaulted    | `main-direct`                                                                                                                             |
| `have_customers` | defaulted    | **`false`** (no customers unless stated); this repo's fragment sets `all`                                                                 |
| `aspects`        | defaulted    | per track; a track with no entry gets the universal `[ { all: ["**"] } ]`; a _declared_ list must still end in `**` (already validated)   |
| `tracks`         | **required** | omitted or empty throws: "this repository declares no tracks; add `tracks:` to `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml`" |

`Get-Variant`'s `-Default` parameter is deleted; the five getters read the typed property directly. Fixtures use neutral names
(widget/gadget, `ADR-TEST:3`).

**Contract rendering of the postures:** a defaulted key shows its literal value; an empty-is-valid key shows `[]` or `{}`; a **required**
key cannot show a value, so the generated file lists it in a header comment (`# required: tracks`) and omits the key. A comment keeps the
file a valid key subset for `Test-Contracts`. The exact comment grammar is settled in Phase 3 against `Get-ContractAssetNote`.

## 4. Assert levels (planned, not all built now)

Cheapest to dearest; each gate declares which level it is:

1. **Construct-time** — the type's constructor: shape, enums, regexes, posture. Exists; extend with posture.
2. **Load-time (fragment)** — `Get-Config` merges the fragment, then the type validates the _merged_ result. Exists in build mode; Phase 2
   extends it to source mode.
3. **Cross-config** — referential integrity between configs (a `tracks.*.type` names a `track-types` entry; a `have_customers` name exists
   in `customer`). New gate, one function per relation.
4. **Contract-time** — generated defaults equal the type's defaults; frozen folders unchanged. New (this plan) + existing `Test-Contracts`.
5. **Repo-time** — the effective config satisfies the data-model invariants (every file in exactly one track and one aspect). Largely exists
   as quality gates.

The ladder is named in an ADR (Phase 5) so later gates can say "I am level 3".

## 5. Phases (one file at a time, verify each; the user runs the full gate)

**Phase 1 — types carry defaults (pilot: variants).** Independent of the rename; lands first.

- `VariantsConfig.cs`: constants `DefaultAdoNaming`, `DefaultGitWorkspace`, `DefaultHaveCustomers`, `DefaultAspects`, posture per section 3.
  Edit `VariantTrack.cs` only if module-model has not already (see section 7).
- Delete `-Default` from `Get-Variant`; update `Get-AdoNaming`, `Get-GitWorkspace`, `Get-EnabledCustomers`, `Get-Aspect`, `Get-Track` and
  their tests, and `VariantsConfig.Tests.ps1` (empty dict yields the defaults; `tracks` omitted throws; `null` and omitted agree).
- Fresh `pwsh` process per C# edit. Background, `timeout`-prefixed runs for any test that imports.

**Phase 2 — the repo fragment and the config-without-file rule.**

- `Get-CatzcOverlayRoot` / `Get-ConfigOverlayRoot`: source mode returns the config-fragment root only; `.cats` alias; both-present error.
  Resolve the track folder through the one resolver, never a `'automation'` literal (rename plan P2/P4 move it to `pwsh`).
- `Resolve-ConfigEntry` / `Get-Config` / `Test-ShippedConfigs` / `Test-ConfigValidators`: a registered type with no shipped file is built
  from `{}` plus the fragment.
- Create `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml` with this repo's `tracks`, `aspects`, `have_customers: all`; delete
  `automation/Catzc.Base.Variants/configs/variants.yml` and its reference page; re-run the head/links generators.
- Tests: merge in source mode, alias, both-present, sealed configs still refuse a fragment.

**Phase 3 — generated contract of defaults.**

- Writer `Build-ConfigDefaultsContract`; check in `Test-Contracts` / `Test-GeneratedFiles`; asset kind `defaults` (direction provided);
  `contracts/catzc/0.0.0/Catzc.Base.Variants/configs/variants.yml`; `Build-ContractReference` lists it; header note per
  `ADR-REPO-CONTRACT#9`.
- `.gitattributes` / file-kinds `contract-asset` already cover the folder; verify.

**Phase 4 — roll out to every typed config.** An audit script in `out/` lists each registered type: does `{}` construct, what does it yield,
which properties are null. Triage into the three postures; convert one config per change. `contracts` is already correct. Sealed configs
(`overridable: false`) take defaults but no fragment. Each converted config gets its generated contract only if a consumer can set it
(sealed configs are not contracted).

**Phase 5 — ADRs and docs.** Amend `ADR-AUTO-DEFAULT#6` (posture, contracted defaults), `ADR-AUTO-OVERLAY#1/#8` (repo's own fragments in
source mode, `.cats` alias), `ADR-CONF-LOADING` (a typed config without a file), `ADR-REPO-CONTRACT#6` (the `defaults` kind); add the assert
ladder (new ADR or an `ADR-AUTO-FAILFAST` section). `Update-AdrCitation`, glossary (`fragment`, `posture`, `contracted defaults`),
regenerate pages.

## 6. Decisions (accepted 2026-10-16)

- **Q1** `have_customers` code default is `false`; this repo's fragment states `all`.
- **Q2** `tracks` is required (throws when omitted or empty); `aspects` defaults to the universal catch-all per track.
- **Q3** The shipped `configs/variants.yml` is deleted; a registered type with no shipped file is built from `{}` plus the fragment, as a
  general rule.
- **Q4** New contract asset kind `defaults`, direction provided by convention.
- **Q5** Source mode reads this repo's own `.catzc/` config fragments only; function/asset overrides, local modules and tests stay
  build-only.
- **Q6** Canonical `.catzc/`; `.cats/` read as an alias, never written; both present is an error.
- **Q7** The contract file shows literal values for defaulted keys and `[]`/`{}` for empty-valid ones; a required key is named in a header
  comment and omitted as a key.

## 7. Interactions with the other plans (read before Phase 1 and 2)

- **Module model** ([plan-module-model.md](plan-module-kinds-tracks.md), lands first): adds `tracks.<t>.engines` to `variants.yml` and
  `VariantTrack`, and shrinks `aspects` to each track's remainder rule. Its new keys must be written **defaulted on the type** from the
  start (section 3), and Phase 1 here edits `VariantsConfig.cs` / `VariantTrack.cs` after it, one file at a time. If both touch the file,
  module-model owns the shape and this plan owns the defaults.
- **Rename** ([plan-automation-layers-rename.md](plan-layers-vocabulary-rename-contracts.md), P2/P4): the overlay path is
  `.catzc/pwsh/<Module>/` after P4. Phase 2 here must not add literals; it uses the resolver, so P4 needs no extra edit. `variants.yml`
  leaves `automation/` in Phase 2, so the rename's worklist row for the `variants.yml` track key now points at the fragment file.
- **Importer vocabulary** ([plan-layers-importer-vocabulary.md](plan-layers-vocabulary-rename-contracts.md)): `ImporterConfig` carries its
  defaults on the type and gets the same three postures and a contracted-defaults file; it is Phase 4 material.
- **Contracts** (`.unordered/15-10-2026/plan-contracts.md`): the "defaults as contract YAML: not adopted" row is superseded by the
  generated, one-declaration form in section 1.
- **Memory-recorded rules that bind this plan:** configure, don't program; strict-mode compliance; one living version; the user runs all
  tests and handles commits; no mutating git; time safeguard on every Bash call.

## 8. Risks

- Source-mode overlay changes a deliberate ADR rule (`OVERLAY#8`) and the `Get-Config` cache key (`cacheKey` includes the fragment's mtime
  and size); it needs tests from every engine that reads configs.
- "A typed config with no file" touches discovery, the registry gate and `-ListOwners`: the largest blast radius, so Phase 2 is split into
  two reviewable steps (the rule first behind a fixture config, then the variants move).
- Freezing defaults is irreversible per released version: confirm the Phase 1 values before any release.
- Deleting `variants.yml` while the module-model plan still edits it would conflict; Phase 2 starts only after module-model is implemented.
- C# type edits need a fresh `pwsh` process; never claim a gate passed without running it and reading the output.
