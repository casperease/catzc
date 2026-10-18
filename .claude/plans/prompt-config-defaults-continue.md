---
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/prompt-config-defaults-continue.md"
    folder: plans
    name: prompt-config-defaults-continue
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
      - ADR-REPO-CONTRACT#3
---

# Continuation prompt for the config-defaults work: paste as the first message of a fresh session

Written 2026-10-16. Copy this file and `.claude/plans/plan-config-defaults.md` into your scratchpad first (another session wiped `out/`
once). Everything below the rule is the prompt.

---

You are the coordinator for the config-defaults work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). Nothing is built yet.
The decisions are made; do not re-ask them.

## Read first, in this order

1. `.claude/CLAUDE.md` (already loaded) and `docs/adr/index.md`; then in full: `docs/adr/automation/sensible-defaults.md`
   (`ADR-AUTO-DEFAULT`), `docs/adr/automation/consumer-overlay.md` (`ADR-AUTO-OVERLAY`), `docs/adr/configuration/module-config-loading.md`
   (`ADR-CONF-LOADING`), `docs/adr/repository/api-contracts.md` (`ADR-REPO-CONTRACT`). Cite rules by code.
2. `.claude/plans/plan-config-defaults.md` (master: facts, design, postures, phases 1-5, **section 6 holds the decisions**, section 7 the
   cross-plan interactions).
3. `.claude/plans/plan-module-kinds-tracks.md (carried section: plan-module-model)` (lands first; it adds `tracks.<t>.engines` and shrinks
   `aspects`), `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: master plan)` and
   `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: rename worklist)` (the `automation` -> `pwsh` rename; overlay
   path `.catzc/pwsh/`), `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: layer model)` (`ImporterConfig`).
4. Reference code: `automation/Catzc.Base.Contracts/types/ContractsConfig.cs` (the model: constants for defaults, null means default),
   `automation/Catzc.Base.Variants/types/VariantsConfig.cs` (the pilot), `automation/Catzc.Base.Config/Get-Config.ps1`,
   `automation/Catzc.Base.Repository/Get-CatzcOverlayRoot.ps1`, `automation/Catzc.Base.Objects/types/DictionaryRecord.cs` (`Contains` is
   false for null).

## The decisions (final)

- A setting's default is declared **once, on the config type** (constants, like `ContractsConfig`). No getter restates it;
  `Get-Variant -Default` is deleted.
- Every property has one posture: **defaulted**, **empty-is-valid**, or **required** (throws at construction naming the key and the fix).
- Variants: `ado_naming` = `standard`; `git_workspace` = `main-direct`; `have_customers` = **`false`** (this repo's fragment says `all`);
  `aspects` = per-track universal catch-all `[ { all: ["**"] } ]` when a track has no entry; `tracks` = **required**.
- This repo's own data (`tracks`, `aspects`, `have_customers`) moves to `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml`; the
  module-shipped `configs/variants.yml` is **deleted**. A registered type with no shipped file is built from `{}` plus the fragment (general
  rule, `ADR-CONF-LOADING`).
- The overlay reads this repo's own `.catzc/` **config fragments only** in source mode; function/asset overrides, local modules, local tests
  stay build-only. Canonical `.catzc/`; `.cats/` is a read alias, never written; both present is one error.
- A **generated** contract `contracts/catzc/0.0.0/<Module>/configs/<name>.yml` publishes the type's full defaults: new asset kind
  **`defaults`**, direction provided by convention. Defaulted keys show literals, empty-valid keys `[]`/`{}`, a required key is named in a
  `# required: …` header comment and omitted. A gate compares the regenerated defaults to the file. Releasing freezes them
  (`ADR-REPO-CONTRACT#3`, `#5`).
- Assert ladder: construct-time, load-time (fragment), cross-config, contract-time, repo-time. Named in an ADR in Phase 5.

## Standing constraints

- Plans and scratch go in `out/`. No plan mode, no selection menu.
- **Never batch-edit with scripts** (no `sed`, `-replace`, regex sweeps). Edit one file with the Edit tool, then verify that file.
- **Time safeguard:** every Bash call passes `timeout: 3000`. Longer work runs with `run_in_background: true` and a GNU
  `timeout <s> <one command>` prefix (at most 360 s), no `cd`, pipes or `;`. Prefer Grep/Read/Glob. Start the importer only in the
  background; C# type edits need a fresh `pwsh` process.
- **No mutating git** unless the user explicitly asks. The user runs all tests and handles commits; propose no commit split; per-file checks
  only.
- Never claim a test or gate passed unless you ran it and read the output. Known unrelated reds: `Test-Spelling` 5, `Test-Glossary` G4,
  `Test-Formatting` `.compiled/*.json`, about 37 `Test-ScriptAnalyzer`.
- One living version (`ADR-PRIN-ONELIVE`): no shims, aliases-for-old-shapes, fallbacks or "we used to" notes. Say "domain rules" / "ADR
  rules".
- Tests use neutral fixtures (widget/gadget, `ADR-TEST:3`); all code strict-mode clean.
- Other sessions edit concurrently (`automation/Catzc.Base.Variants/Get-Track.ps1` and its test were already dirty): message the user before
  editing a dirty file you do not own.
- `C:\projects\eac` is inspiration only; say when an idea came from it.
- Delegate to `catzc-worker` with disjoint file sets; you own shared files (`configs.yml`, `adrs.yml`, glossary, agents list).

## What to do, in order

1. **Sequencing check.** Ask the user whether the module-model plan is implemented. Phase 1 may start regardless (it only adds defaults to
   the types that exist); **Phase 2 must wait** for module-model, because it deletes `variants.yml` which module-model still edits. If
   module-model has already added `engines`/`layout` keys, give each its default and posture in Phase 1 too.
2. **Phase 1 (pilot).** In `VariantsConfig.cs` add the constants and postures; delete `Get-Variant`'s `-Default`; update `Get-AdoNaming`,
   `Get-GitWorkspace`, `Get-EnabledCustomers`, `Get-Aspect`, `Get-Track` and their tests and `VariantsConfig.Tests.ps1`, one file at a time,
   each verified in a background run. Cover: empty dict yields the defaults; `null` equals omitted; `tracks` omitted or empty throws;
   unknown key still throws.
3. **Phase 2a.** The "typed config without a file" rule behind a **fixture** config (discovery, `Get-Config`, `Test-ShippedConfigs`,
   `Test-ConfigValidators`, `-ListOwners`) and the source-mode fragment root with the `.cats` alias. **Phase 2b.** The variants move
   (fragment created, shipped file and its reference page deleted, generators re-run). Resolve the track folder through the resolver, never
   a literal.
4. **Phase 3.** `Build-ConfigDefaultsContract`, the `defaults` kind, the gate, the first generated contract for `variants`;
   `Build-ContractReference`.
5. **Stop and report.** Phases 4 (every typed config, audit script first) and 5 (ADRs) each wait for the user's go.

## Stop and ask when

- A fact in the plan is contradicted by what you read: correct the plan file and say so.
- A step needs a decision the plan does not settle, a change to a sealed config, or any mutating git.

## Report

At the end of each phase: files changed, per-file checks that ran and what they printed, what is unverified, reds that are not yours
(separately), and the next phase.
