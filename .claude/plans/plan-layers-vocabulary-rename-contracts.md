---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  waits_on: P6 pipeline renames wait for the user's go, the same day the user re-points Azure DevOps and GitHub
  targets: [pwsh, docs/adr/automation, docs/adr/repository, contracts, pwsh/Catzc.Base.Docs/configs]
---

# Automation is the abstract term; the PowerShell track is named pwsh; public commands get contracts

`automation/` is `pwsh/`, ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER and ADR-REPO-CMDCONTRACT are written, and the contracted command set is in
`contracts/`. Open: P6, the externally bound pipeline names and the last old layer form; P7, the user's call on the uncontracted public
functions; and the carried designs below.

## Why its value is high

It fixes what automation, language, engine, importer, command and contract mean across every file, and makes contracts/ the only public API
by naming which public functions are contracted. Every later plan speaks this vocabulary.

## Decided, and why (all took the recommendation, 2026-10-16)

- Q2 keep invoke-automation.yaml and release-automation.yml: they invoke and release the automation, the abstract thing.
- Q3 keep Test-Automation, its helpers and test-automation/: the name is already accurate.
- Q10 concern automation and value-chain row AUTO keep their names; ADR-AUTO-\* is never re-coded.
- Q11 bash, python and go stay test-artifact languages; the importer throws NotImplemented for any other configured language.
- P6 renames ci-automation, ci-automation-expected-failures and the globset; the user re-points the Azure DevOps and GitHub bindings outside
  git the same day. P8 (diagrams) is out of this plan: nothing is rendered unasked.
- Public API (F6, S5, D21): internal is internal to its module; the pilot contracts are hand-written; generating a contract from the ADR
  that defines it is a direction tried on the second set.

## Open steps

- [ ] P6 pipeline and unit names, one atomic set (task-layers-classification-flip step 1): `ci-automation` -> `ci-pwsh`,
      `ci-automation-expected-failures` -> `ci-pwsh-expected-failures`, the globset and `pipeline:` key, the workflow and pipeline files,
      their name-keyed contract fragments, `docs/references/pipelines/*`, the README badge, the `Test-GitHubWorkflowTriggerGlob` and
      `Register-AdoPipeline` examples, and ADR-DSGN-TRACK-DEPLOYABLEUNIT's "as `ci-automation` binds the automation track". With it, the
      `automation` form leaves the layer family. The user's go first (check: Test-Pipelines, Test-Contracts and Test-Glossary clean; the
      triggers fire on the next push after the user re-points the bindings).
- [x] P7: decided by the user 2026-10-18 (D26, D27) and landed (task-command-contracts): five dead functions left the tree, the Test/Assert
      pair halves and debug writers stay exported, the how-to-named commands the grammar can state are contracted; `CONTRACTS issues=0`, 65
      contracted commands. The parameter-set grammar and the QualityGateResult gate contracts landed too (task-command-contracts steps 8 and
      9); the test runners return TestRunResult and IsolationRunResult and are contracted.

## Stop and ask when

- A plan fact is contradicted by the tree: record the correction in the plan and say so.
- A step needs an unsettled decision, any mutating git, or an external binding.

## Refs

- memory: automation-layers-rename-plan.md
- The full text of the four drafts (the master, the layer model, the command contracts, the rename worklist) is in git.

## Carried: what is still open from the four drafts

### P6 edges, from the worklist

- CI triggers fire silently never if stale: `.github/workflows/ci-automation.yml`, `pipelines/ci-automation.yaml`,
  `pipelines/ci-automation-expected-failures.yaml`. Their depended-on contract assets pin the file **names**, so renames move the fragments
  together: `contracts/catzc/0.0.0/Catzc.Tooling.Github/workflows/{ci,release}-automation.yml`,
  `Catzc.Azure.DevOps/pipelines/ci-automation*.yaml`.
- `README` badge `.github/README.md` and external bindings outside git: Azure DevOps pipeline definitions point at
  `pipelines/ci-automation.yaml`; GitHub required checks.

### Not in this plan

Re-coding `ADR-AUTO-*`; moving AUTO ADR files into layer sub-folders; renaming the Go/Python/Bash tracks; any change to `.unordered/`;
rendering any diagram unasked; the Azure DevOps and GitHub settings that live outside git; commit structure (the user's).

### From the layer-model draft: stray pwsh rules still in AUTO

- Survey: ADR-AUTO-TEST-SAFESEAMSWAPS, ADR-AUTO-TEST-PROCESSTRIPWIRE, ADR-AUTO-TEST-FILEPARALLELISM, ADR-AUTO-TEST-ONESCHEDULINGPOOL,
  ADR-AUTO-TEST-RUNSNEVERWAIT, ADR-AUTO-EXTEND-MANDATORYCONVENTIONS, ADR-AUTO-CACHE-IMPORTERINVALIDATES, ADR-AUTO-CACHE-LAZYBYDEFAULT and
  the session-cache model, ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING, ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES,
  ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES, ADR-AUTO-NOPWD-ONEROOTACCESSOR. Move each to its `ADR-PWSH-*` twin or reword it engine-neutral;
  extend `Test-AdrEngineNeutrality` so AUTO text with pwsh syntax fails.

### From the layer-model draft: the importer decides the mix (L3 to L5, not built)

The user's phrase: "an IMPORTER deciding the final mix of engines and languages". The design, smallest first, all configuration with
sensible defaults and no new registry (ADR-PRIN-CONFIG, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, ADR-AUTO-OVERLAY for consumer differences):

- **Inputs** (resolution order of ADR-AUTO-DEFAULT-ONERESOLUTIONORDER: the caller's explicit value, else configuration, else the default
  declared once on the config type): `-Languages`, `-Engines` on the importer (an importer switch, like `-Bundle`), environment variables
  only where ADR-AUTO-ENVVAR allows an external contract (**read it first**), `importer.yml` (new, `Catzc.Base.ModuleSystem/configs/`, type
  `ImporterConfig` carries the defaults), then the bundle/profile closure for modules. Run mode (source|build) and host (console|headless)
  stay orthogonal and keep choosing the types-load cell.
- **Values:** `auto` (default) or an explicit list. `auto` for **engines** = pwsh plus every POSIX engine whose executable exists (a missing
  zsh is skipped and reported); for **languages** = the executable languages of the loaded modules.
- **Result:** one `ImportMix { Languages, Engines, Modules }` record kept for the session, readable by `Get-ImportMix`. The test runner
  reads engines from it instead of re-deciding (every Go/Python test runs once per engine from the model), the builder reads modules.
- **Effects, in order of cost:**
  1. report only (`Get-ImportMix` states the current truth: engines [pwsh], languages [powershell, csharp], modules = all in the root);
  2. module selection by language (a module whose live languages are not in the mix is not loaded);
  3. entry files follow the mix (`importer.sh` is only generated and mentioned when a POSIX engine is in the mix);
  4. languages beyond powershell and csharp: **throw `NotImplemented` when configured** (the pattern of
     ADR-REPO-CONTRACT-CONFIGUREDADDRESSING); switched on only once proven from every engine.
- **Per-language facts** that the importer needs (`build`, `test`, `layout` handlers) belong in `languages.yml` beside `formatter`, `checks`
  and `executable`. Whether `FileLanguage` rejects unknown keys is **unverified**; a new key needs the type edit first (C# change, fresh
  `pwsh`).

| Phase | Work                                                                                                                                             |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| L3    | `ImporterConfig` + `importer.yml` (defaults on the type) + `Get-ImportMix` reporting the current mix. L0 tests with neutral fixtures.            |
| L4    | `-Languages`/`-Engines` switches and module selection by language (effect 2); the importer shim is generated, so edit its source and regenerate. |
| L5    | Entry files follow the mix (effect 3); `Test-GeneratedFiles` covers it.                                                                          |

Decisions of the layer model (accepted as recommended on 2026-10-16), kept for L3 to L5:

- **Q-L3** No regrouping of AUTO files into `language/` and `importer/` sub-folders; data (`layer:`) gives the same view.
- **Q-L4** The value-chain concern `automation` keeps its name.
- **Q-L5** `ExecutionEngines` stays a compiled C# model (closed set, no config); languages stay config.

### From the command-contract draft: still open

- **C7** Other implementing languages: only when a real command exists in one (the ADRs make bash/go/python test artifacts,
  ADR-AUTO-GO/PY/BASH). Until then `NotImplemented`.
- **Use 4, tests:** Go/Python black-box tests that call a contracted command take the call shape from the contract; a drift test fails when
  the contract changes and the test does not.
- Rules and traps to respect: a contract asset is **bytes the check compares** (marked `catzc-contract` in `.gitattributes`, no Format-Code
  pass may rewrite it); released folders are frozen (`.frozen` SHA-256, `Publish-ContractRelease`); a signature change to a contracted
  command is a contract change, and the same commit edits the asset; do not store a version, a module, or a language in a command contract
  (placement says them).

### From the worklist: do-not-sweep list

`System.Management.Automation`, `NoAutomaticVariableMisuse.psm1`, CAF/WAF/DORA titles and anchors (`#deployment-automation`,
`platform-automation-and-devops.md`), "Cloud Automation Toolkit", Exporter `-Version auto`, `jidoka`, `.markdownlint.yml` "auto-enable",
`Get-AutoControlledGlobs` (name keeps "Auto"; prose "the automation itself" there means the tooling: reword, do not rename),
`docs/adr/automation/**` paths and `ADR-AUTO-*` codes, `.unordered/**`, `docs/references/pipelines/*automation*` pages until P6.
