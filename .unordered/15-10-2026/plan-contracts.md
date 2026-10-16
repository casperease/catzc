# Plan: contracts in both directions — testable fragments at `contracts/<release>/<module>/`

Started 2026-10-14 from the world-map track work. `.github` is an external port, and GitHub reads our checked-in files to drive its UI. That
makes the shapes GitHub depends on part of the repository's boundary, so they must be pinned by tests.

## Decisions (user)

| #   | Decision                                                                                                                                                                                                                                                                   |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | **One tree, both directions.** `contracts/` holds every binding interface at the repository boundary: **provided** (what an outside consumer may rely on) and **depended-on** (what an outside platform expects of our files and calls). Both are proven by tests.         |
| C2  | **The version segment is the catzc release version.** The layout is `contracts/<release>/<module>/…`. `0.0.0` is the mutable, unreleased draft (today's `v0` role). A released version folder is frozen.                                                                   |
| C3  | **`<module>` is the owning catzc module**: the one that talks to the integration and holds the provider test (e.g. `Catzc.Tooling.Github`, `Catzc.Azure.DevOps`). `dependencies.yml` already governs it.                                                                   |
| C4  | **Four asset kinds:** required file present, required fragment / keys, schema, and sample payload. **Sensible defaults come from the asset's own path:** the path under `<module>/` is the repo-relative path of the real file it constrains, and a suffix picks the kind. |

## What exists today (analysis)

- **ADR-REPO-CONTRACT** (`docs/adr/repository/api-contracts.md`):
  - #1 says contracts/ is the external API surface, **provided** direction only.
  - #2 says layout `contracts/<contract-name>/v<N>/`.
  - #3 says old versions are kept while a consumer pins them.
  - #4 says contracts are binding, proven by provider tests.
  - #5 says a published version is immutable, and `v0` is the mutable draft.
- **ADR-REPO-FOLDERS#11** fixes the `v<N>` layout too.
- **`contracts/` holds only `.gitkeep` and `README.md`.** No contract exists yet, so the layout can change now without moving anything (one
  living version: the `v<N>` text is replaced, not kept beside the new one).
- **GitHub-facing files today:** `.github/README.md`, `.github/workflows/ci-automation.yml` and `release-automation.yml`, plus the root
  `README.md` and `docs/**/README.md`, which GitHub renders.
- **Owning modules that exist:** `Catzc.Tooling.Github` (GitHub), `Catzc.Azure.DevOps` (ADO REST, pipelines), `Catzc.Azure.Templates`
  (ARM/Bicep).
- **A concurrent change** adds a `go/` root for black-box tests (`conventional-folders.md`, uncommitted, another session). It will be a
  track, and possibly a contract consumer.

## Design

### Layout and the name-derived defaults (C4)

```text
contracts/
  0.0.0/                                         # mutable draft = the next release
    Catzc.Tooling.Github/                        # target root .github (contracts.yml target_roots)
      workflows/ci-automation.yml                 # FRAGMENT: real file must contain these keys/lines
      README.md                                   # FRAGMENT: e.g. the badge/heading GitHub renders
      workflows/ci-automation.yml.schema.json     # SCHEMA: real file validates against it
    Catzc.Azure.DevOps/
      pipelines/cd-shared.yaml                    # FRAGMENT: trigger/extends block ADO relies on
      rest/build-queue.sample.json                # SAMPLE: payload the module must produce/parse
  1.0.0/                                          # frozen at release 1.0.0
```

Each kind is picked by its name:

- **No suffix** = **fragment**. The real file at the same repo-relative path must exist (**presence**) and contain the fragment. For
  YAML/JSON that means a key-subset match; for text, every non-blank line in order. An **empty** fragment file means presence only.
- **`<path>.schema.json`** = **schema**. The real file validates against it (JSON Schema, applied to YAML after parsing).
- **`<name>.sample.<ext>`** = **sample payload**. The owning module's test must produce or parse it. By default it also validates against a
  sibling `<name>.schema.json` when one exists.
- **The direction default:** an asset whose path names a real repo file is **depended-on** (an outside platform reads it). A `.sample.*`
  under a module that exposes it is **provided**. A per-version `contract.yml` may override either (see Q1).

### Mechanism

- **`Get-Contract`** (in an owning-agnostic base module, Q4) enumerates `contracts/<release>/**`. It derives each asset's kind, direction,
  owning module and target path from the name alone (zero ceremony, ADR-AUTO-ZERO).
- **`Test-Contracts`** is a quality gate: for each asset of the **current** release folder (`0.0.0` on a devbox, the resolved version in a
  release build), it runs the kind's check against the real tree. Each owning module also gets a generated L1 test per asset, so
  `Test-Automation` covers contracts with no hand-written test.
- **Freeze at release:** the release workflow copies `0.0.0/` to `<release>/` and makes that folder immutable. A test fails on any diff to a
  non-draft folder, following ADR-REPO-CONTRACT#5.

## ADR changes (in the same change, one living version)

- **ADR-REPO-CONTRACT#1:** add the depended-on direction.
- **ADR-REPO-CONTRACT#2 and #5:** replace `contracts/<name>/v<N>/` and `v0` with `contracts/<release>/<module>/` and `0.0.0`.
- **ADR-REPO-CONTRACT#3:** "kept while a consumer pins it" applies to provided contracts. A depended-on contract follows the platform.
- **New rule:** the name-derived defaults (C4).
- **ADR-REPO-FOLDERS#11:** the same layout change. Coordinate with the session editing `conventional-folders.md`.
- **Terms (register first):** `contract` and `contract asset`, plus the direction words if they become terms.

## Phases (one `catzc-worker` each; user review between)

| Phase | Work                                                                                               | Done when                                    |
| ----- | -------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| C-T   | ADR-REPO-CONTRACT + FOLDERS#11 rewrite, the new defaults rule, glossary terms                      | doc gates + Test-Glossary + Test-AdrRegistry |
| C-1   | `Get-Contract` + its config type (if any) + L0 tests (kind/direction/target derivation from names) | L0 green                                     |
| C-2   | The four checkers (presence, fragment, schema, sample) + L0 tests with widget/gadget fixtures      | L0 green                                     |
| C-3   | `Test-Contracts` gate + generated L1 test per asset                                                | gate run reported                            |
| C-4   | The first real contracts: GitHub (`.github/workflows/*`, `README.md` render), ADO pipeline trigger | gate green on the real tree                  |
| C-5   | Freeze-at-release in the release workflow + the frozen-folder test                                 | release dry run                              |

## Decisions, round 2 (user, 2026-10-14)

- **Q1: the direction comes by convention, and a manifest may override.** A path naming a real repo file is depended-on, and a `.sample.*`
  is provided. A per-version `contract.yml` may override a single asset.
- **Q2: many-file addressing is a configured setting with a sensible default.** The mode is a config key (on the contracts config type). Its
  candidate values are a manifest glob (meta), a per-folder file, and full path. The default mode is implemented first. Modes that aren't
  built yet **throw NotImplemented** while the mechanism is proven from **both pwsh and bash**, and then they are switched on by config. The
  scan for matching files runs only when the configured mode says what to match ("do the scan when you know"); nothing is enumerated
  speculatively.
- **Q3: the release is the catzc bundle version** from `Resolve-CatzcBuildVersion` (ADR-AUTO-BUNDLE). `0.0.0` is the draft. The devbox
  `6.6.666` never freezes a folder.
- **Q4: the mechanism lives in a new `Catzc.Base.Contracts` module.** Owning modules keep their assets under `contracts/`, and their L1
  tests are generated.

## Decisions, round 3 (user, 2026-10-14)

- **Contracts are many files, grouped by named groups (the owning modules) inside `contracts/0.0.0/`.** The module folder is the group. The
  default addressing is therefore **full path inside the module group**: each asset constrains the one real file at its own path, and a
  module group holds as many assets as the integration needs. ADR-REPO-CONTRACT#8's default ("full path") stands. The other many-file modes
  stay configured-but-NotImplemented until they're needed.

## Correction (user, 2026-10-14): no repository-wide version

- **C2 is superseded.** "The catzc release version" read as one repository-wide release. This is a product mono-repository, not a monolithic
  app, so there is no repository-wide version (see `out/plan-framing.md`, rules 4 and 5).
- **The layout is `contracts/<unit>/<version>/<module>/<repo path>`.**
  - `<unit>` is the deployable-unit that carries the contracts: today `catzc`, the bundle, the one unit consumers pin.
  - `<version>` is that unit's version (`Resolve-CatzcBuildVersion`). `0.0.0` is that unit's draft, and it freezes only when that unit is
    released.
  - Provided and depended-on contracts both version with the bundle.
- **To fix in one change:**
  - ADR-REPO-CONTRACT #2, #3, #5, #8 and its body;
  - ADR-REPO-FOLDERS#11 and the "How this is enforced" bullet;
  - the ADR-PRIN-ONELIVE contract passages;
  - `docs/references/contracts.md`;
  - the `adrs.yml` REPO description;
  - the glossary `contract asset` / `published artifact` contrast wording ("frozen per release" becomes "frozen with its unit's release").

## C-1 done (2026-10-14)

- **Module:** `Catzc.Base.Contracts`. `Get-Contract` (`-Unit`/`-Version`/`-Module`/`-Path`, plus `-Addressing` and `-RepositoryRoot`), five
  private helpers, the types `ContractAsset`, `ContractAssetKind`, `ContractDirection`, `ContractManifest` and `ContractsConfig`, and
  `contracts.yml` (`addressing: full-path`). 66/67 tests; the one failing L1 test needed the `configs.yml` entry, which is now added.
- **Pending:** the `dependencies.yml` line `Catzc.Base.Contracts: [Catzc.Base.Config, Catzc.Base.Repository, Catzc.Base.Objects]`, held
  while another session's edits there are uncommitted.
- **Worker design choices, all confirmed by the user (2026-10-14):**
  - the contract.yml shape `direction: { <module>/<path>: provided | depended-on }`;
  - a schema beside two samples of the same name throws;
  - a schema that applies to a sample is provided, and takes its own override;
  - `-Path` matches either the asset path or its target.

## C-2 done (2026-10-14)

- **Public function:** `Get-ContractCheckResults`, not `Test-` (ADR-AUTO-VERBS#2: a Test- returns a bool; the gate is C-3's
  `Test-Contracts`). Pipeline input from Get-Contract; default: every unit's draft.
- **Checks:** Presence (case-exact, segment by segment), Fragment (key subset for JSON/YAML with any-order array matching, a null value
  meaning "the key exists"; ordered non-blank lines for text), Schema (bounded subset: type, required, properties, additionalProperties as a
  bool, enum, items as one schema, const; anything else is an explicit finding), Sample (parses; validated against an exact-case sibling
  schema).
- **Tests:** 158/158 for the module. The `dependencies.yml` line is applied.
- **User decisions (2026-10-14):**
  - The **annotation keywords** `$schema`, `$id`, `$comment`, `title`, `description` and `examples` are accepted as explicit no-ops. Every
    other unsupported keyword still fails.
  - **One finding per defect.** A schema asset whose target is a sample only checks that it is a well-formed, supported schema. The sample's
    own check does the validation.

## C-3 done (2026-10-14)

- **The gate:** `Test-Contracts` (ADR-AUTO-TEST#35) runs Get-Contract | Get-ContractCheckResults over each unit's version folder. `-Version`
  defaults to the draft `0.0.0`; the C-5 release workflow will pass the resolved version. Each finding becomes one issue, reported to
  `out/test-contracts/`. Zero assets is a clean pass.
- **Per-asset coverage:** one data-driven L1 file, `Get-ContractCheckResults.Assets.Tests.ps1`, with one `It` per asset at discovery;
  nothing is generated into other modules.
- **Shared lines applied:** `dependencies.yml` (`Catzc.Base.Contracts` gains `Catzc.Base.Reports`) and manual-test-plan rows 11–12,
  formatted with `Format-Code`.
- **Verified by the coordinator:** 181/181 tests; Test-Contracts, Test-ScriptAnalyzer, Test-Spelling, Test-Markdownlint and
  Test-ManualTestPlan are all clean.
- **Open, for C-5:** checking the provided assets of _pinned_ released versions needs a pin record, which doesn't exist yet. Until then, the
  gate checks only the given version folder.

## C-4 done (2026-10-14)

- **10 depended-on assets** under `contracts/catzc/0.0.0/`. They pin key existence only, never internal values:
  - `Catzc.Tooling.Github`: the presence of `.github/README.md` (GitHub's README precedence is `.github` → root → `docs`), and the two
    workflows' `on` / `jobs.<id>.runs-on` / `jobs.<id>.steps`;
  - `Catzc.Azure.DevOps`: the 7 `pipelines/*.yaml` files' `trigger`, `pr`, and `extends.template` / `stages` / `jobs`.
- **Verification:** Test-Contracts reports 0. The module passes 191/191, with the data-driven file discovering 10 per-asset tests.
- **Found, outside any contract:** the `.github/README.md` CI badge points to `workflows/ci.yml`, which doesn't exist (the workflow is
  `ci-automation.yml`).
- **Open (asked of the user):** the GitHub owning module, the `.gitattributes` exclusion that protects markdown assets from the title and
  link tools, where the module-group notes go, and the badge fix.

## C-4 decisions (user, 2026-10-14)

- A new `.gitattributes` class **`catzc-contract`** protects assets from the title, link and format tools (C-4b, running).
- **`Catzc.Tooling.Github`'s scope grows** to the repository's GitHub integration (C-4b).
- **The CI badge is fixed:** `.github/README.md` now points to `ci-automation.yml` (done by the coordinator).
- **Per-group notes become a generated `docs/references` page per unit**, built from the assets' header comments (the ADR-REPO-README
  pattern). `contracts/` holds only assets. This is new phase **C-6**.

## C-5 decisions (user, 2026-10-14)

- **Released folders are the pin record.** Every frozen `contracts/<unit>/<version>/` still in the tree counts as pinned. Retiring a version
  means deleting its folder, which is a deliberate, reviewed change. There is no separate list.
- **The release workflow resolves the version** and calls `Test-Contracts -Version <resolved>`. The gate stays free of git and of Exporter.

## C-5 done (2026-10-14)

- **What `Test-Contracts -Version <v>` checks:** every asset of `<v>` (default the draft), the PROVIDED assets of every other released
  folder (`pinned`), and every released folder against its `.frozen` record. A `-Version` with no folder is an issue.
- **`Publish-ContractRelease -Unit -Version`** copies the draft to `<version>/` and writes `.frozen` (SHA-256 per file, read with CRLF as
  LF). It refuses `0.0.0`, `6.6.666` (read from exporter config) and an existing target, supports `-WhatIf`, and never commits.
- **Verification:** 219/219 tests. A release dry run on a scratch copy works end to end.
- **Coordinator follow-up:** ADR-REPO-CONTRACT #4, #5, "Where back-compat is owed" and "How this is enforced" are updated, and the
  manual-test-plan rows 11–13 are set.
- **Workflow (`.github/workflows/release-automation.yml`, NOT yet edited, user decision):** `fetch-depth: 0` (an existing bug:
  Resolve-CatzcBuildVersion throws on a shallow clone), then the draft check → freeze → `Test-Contracts -Version $PKG_VERSION` → a bot
  commit and push of the frozen folder. Open: branch protection may block the bot's push, and `gh release create --target "$GITHUB_SHA"`
  keeps the tag on the built commit.

## Inspiration from eac (`C:\projects\eac`, ideas only — catzc's ADRs decide)

eac's material: `contracts/<module>/0.1.0/` with a README per contract, `docs/reference/eac/architecture/contracts.md` and
`docs/reference/devex/internal/contracts-overview.md`.

| eac does                                                                                                                                         | For catzc                                                                                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Module first, version second** (`contracts/<module>/<semver>/`); each contract versions on its own.                                            | **Not adopted.** You chose release first (C2): one frozen folder per catzc release, holding every module group. The trade-off: catzc freezes everything per release, and eac lets one module move without the others.                              |
| **A README per contract** (Key Types, Patterns, Internal Structure, Dependencies, Role in System).                                               | **Idea for C-1/C-4:** each `contracts/<release>/<module>/` gets a README describing its assets (direction, constrained file, kind). It could be generated from the asset names, following ADR-REPO-README's generated READMEs.                     |
| **JSON Schemas validate the YAML configs**, and configs link their schema (`# yaml-language-server: $schema=…`) so editors validate as you type. | **Idea for C-2:** a `.schema.json` contract asset could also be linked from the real file. That gives editor-time validation of a depended-on shape. Weigh it against catzc's C#-typed configs (ADR-AUTO-TYPES#8), which already validate on load. |
| **System defaults live in `contracts/…/defaults/`** as YAML.                                                                                     | **Not adopted as a second declaration.** Catzc declares each sensible default once, on the config type (ADR-AUTO-DEFAULT#6). Superseded in form on 2026-10-16 by `out/plan-config-defaults.md`: a `defaults` contract asset is *generated from* the type, so it publishes the one declaration instead of repeating it.                                                                                                                                               |
| **"Configuration over convention: everything explicit."**                                                                                        | **Not adopted.** Catzc is zero-ceremony and convention-first (ADR-AUTO-ZERO); the name-derived defaults (#6, #7) are the catzc answer.                                                                                                             |
| **A docs manifest is itself a contract** (`contracts/docs/0.1.0/schemas/manifest.schema.json`).                                                  | **Idea:** the `docs` track's structure (book and README manifests) could be a depended-on contract too. Candidate for after C-4.                                                                                                                   |
| **Contract relationships** are drawn as one diagram (repository → blueprints → tool-config; test-suites → tags → environments).                  | **Idea:** a `contracts` diagram for the diagram waves once C-4 has real assets.                                                                                                                                                                    |

## Open questions (round 1, answered above)

See the four questions asked with this plan:

- Q1: direction declared by convention or by a manifest;
- Q2: addressing many files with one asset (globs);
- Q3: what counts as "the release";
- Q4: the owning module of the mechanism.

## Release workflow wired (2026-10-14)

`.github/workflows/release-automation.yml` now:

- checks out with `fetch-depth: 0`;
- after the build sets `PKG_VERSION`, runs `Test-Contracts`, then `Publish-ContractRelease -Unit catzc -Version $env:PKG_VERSION`, then
  `Test-Contracts -Version $env:PKG_VERSION`;
- commits `contracts/catzc/<version>` as `github-actions[bot]` and pushes to the trunk directly (the user's choice, so the token needs
  bypass rights on the branch rule);
- passes `--target "$GITHUB_SHA"` to `gh release create`.

Format-Code, Test-Spelling and Test-Contracts are clean. **C-6** (the generated notes page) is delegated to a worker.

## C-6 done (2026-10-14)

- **`Build-ContractReference`** (Catzc.Base.Contracts) generates `docs/references/contracts/<unit>.md`. It has one table per version folder
  (the draft first, then released folders newest first) with the columns Module, Asset, Target, Direction, Kind and Note.
- **Where a note comes from:** a YAML asset's leading `#` lines, or a schema's `$comment`. Presence assets, text fragments, JSON fragments
  and samples carry no note.
- **Coordinator lines applied:**
  - ADR-REPO-CONTRACT#9 plus an enforcement bullet;
  - the ADR-REPO-README#7 wording;
  - the link from `docs/references/contracts.md`;
  - Test-GeneratedFiles registration, with an L0 mock and a count of 15;
  - the importer janitor;
  - `.gitattributes` `linguist-generated`, through Build-RootConfig;
  - the dependency lines: Contracts gains Files and Writers, and QualityGates gains Contracts;
  - manual-test-plan row 19.
- **Gates:** links, markdownlint, spelling, script-analyzer, ADR registry, generated files, manual test plan, module dependency and
  contracts are all 0. Pester: 18/18 (Test-GeneratedFiles and Build-ContractReference); the worker ran 239/239 Contracts tests.
- **Open:** notes as a list instead of a wide Note column; confirm that `docs/references/contracts/` is wholly generated (orphaned pages are
  removed).

## C-6 follow-up (user decisions, 2026-10-14)

- **Notes as a list (user: yes).** Each version section is a five-column table, followed by a `Notes:` list with one item per asset that
  carries a note, filled at 140 columns. `Format-MarkdownParagraph` moved from Docs/private to the Docs root (public, a new responsibility:8
  "Generated markdown"). Contracts gains a dependency on Docs. `ConvertTo-ContractNoteCell` is renamed `ConvertTo-ContractNoteMarkdown`,
  with no pipe escaping. ADR-REPO-CONTRACT#9 is reworded to match.
- **Is docs/references/contracts/ wholly generated? (user: find out).** No, and it should not be assumed: the sibling
  `docs/references/pipelines/` holds a hand-written article. So the writer now removes an orphaned page only when the page carries its own
  marker line (`` `Build-ContractReference` writes this page from``). A hand-written page is never touched; a test proves it.
- Gates: Format-Code -DryRun on the page changes 0; links, markdownlint, spelling, script analyzer, module dependency, generated files, ADR
  registry and contracts all report 0. Pester: 259 passed with 1 failure on the first run; after the fix, the rerun files pass 14/14.

## No dot folders under contracts/ (user, 2026-10-15)

- **User ruling:** `contracts/catzc/0.0.0/Catzc.Tooling.Github/.github/` is an illegal path; the fix the user chose is a per-module target
  root.
- **Layout:** `contracts.yml` declares `target_roots: { Catzc.Tooling.Github: .github }`; the default target root is the repository root,
  declared once on ContractsConfig. ADR-REPO-CONTRACT#2 is amended.
- **New rule #10, plus a Test-Contracts check:** no dot-prefixed folder anywhere under contracts/. Dotfiles such as `.frozen` and `.gitkeep`
  are allowed.
- **Assets moved:** they are now `Catzc.Tooling.Github/README.md` and `workflows/{ci,release}-automation.yml`. Test-Contracts reports 0 over
  10 assets, and 259/259 Contracts tests pass.
- **Found along the way:** the README presence asset was never committed, because `**/README.md` ignored it. gitignore.yml now carries
  `!contracts/*/**/README.md`.
- **Fixed a generator bug:** Format-GitIgnoreSection wrote notes as trailing comments, and git has no trailing comments, so every noted
  negation (`!out/.gitkeep`, `!automation/.vendor/**/*.psd1`, the analyzer settings) silently matched nothing. Notes now sit on their own
  line above the pattern; `git check-ignore` confirms every negation applies. 78/78 Git and RootConfig tests pass.
- **Other files updated:** ADR-REPO-FOLDERS#11, `docs/references/contracts.md`, and the Tooling.Github reference article.
- **User action:** commit the moved assets, including `contracts/catzc/0.0.0/Catzc.Tooling.Github/README.md`, which is now trackable.
