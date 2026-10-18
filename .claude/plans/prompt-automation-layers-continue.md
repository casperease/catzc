---
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/prompt-automation-layers-continue.md"
    folder: plans
    name: prompt-automation-layers-continue
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
      - ADR-AUTO-ENGINE#4
---

# .claude/plans/prompt-automation-layers-continue.md

`Continuation prompt for the automation layers + pwsh rename work: paste as the first message of a fresh session`

Written 2026-10-16. Named `prompt-*`; copy it, the four `plan-*` files named below and `prompt-module-model-*` into your scratchpad first
(another session wiped `out/` once). Everything below the rule is the prompt.

---

You are the coordinator for the automation-layers work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). Nothing is built or
renamed yet. Every decision is made; do not re-ask them.

## Read first, in this order

1. `.claude/CLAUDE.md` (already loaded) and `docs/adr/index.md`; then, for each phase, the ADRs that govern the files it touches. Cite rules
   by code.
2. `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: master plan)` (master: phases P0-P8, work waves, risks;
   **section 8 holds the decisions**).
3. `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: layer model)` (layers, vocabulary, ADRs, importer mix),
   `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: command contracts)` (command contracts, contract language),
   `.claude/plans/plan-layers-vocabulary-rename-contracts.md (carried section: rename worklist)` (evidence: sense classes S1-S8, registries,
   bootstrap constants, funnel sites, edge hazards, generator order).
4. `.claude/plans/plan-module-kinds-tracks.md (carried section: plan-module-model)`,
   `.claude/plans/plan-module-kinds-tracks.md (carried section: plan-k8s-kinds)`, `.claude/plans/prompt-module-model-1-prepare.md`,
   `.claude/plans/prompt-module-model-2-implement.md` (they land first).
5. The surveys `out/survey-*.md` only if they still exist; the worklist carries what you need.

## The decisions (final)

- Reading: **automation** stays the abstract term (ADR domain `automation`, code `AUTO`, `ADR-AUTO-*` with about 10,450 citations and no
  re-coding, concern `automation`, value-chain row `AUTO`, engine value `auto`). What meant "the PowerShell implementation" moves.
- Folder and track `automation` -> **`pwsh`** (`pwsh/`, track key `pwsh`, globset `pwsh`, `docs/references/pwsh/`, consumer overlay
  `.catzc/pwsh/` with **no fallback**, build outputs `out/pwsh/built` and `out/pwsh/packages`). `<TRACK>` in the plans means `pwsh`.
- Kept: `Test-Automation` with its 16 helpers and `test-automation/`; `invoke-automation.yaml`; `release-automation.yml`.
- Renamed late (P6, with externally bound names): `ci-automation`, `ci-automation-expected-failures` and the globset. The user re-points
  Azure DevOps and GitHub bindings outside git.
- Other `automation` doc folders: classified page by page (pwsh topic moves, abstract topic stays). `docs/adr/automation` and its links
  stay.
- Edits: Edit tool only, one file at a time, each verified. No permanent rename tool.
- Order: **module model first**, then P1, P2, P3, **P4 only in a quiet window with the user's explicit go**, then P5, P6; P7 runs beside,
  never inside P4; P8 (diagrams) only with an explicit go.
- Command contracts: fifth asset kind `.command.yml` at `contracts/catzc/0.0.0/<Module>/<Verb-Noun>.command.yml`, grammar shape A (one
  string per parameter), closed type set, pilot set first, `cats` validation in C5, no `errors:` in `0.0.0`. Layer plan Q-L1..Q-L5 as
  recommended.
- Bash, python and go stay test-artifact languages; the importer throws `NotImplemented` for any other configured language.

## Standing constraints

- Plans and scratch go in `out/`. No plan mode, no selection menu.
- **Never batch-edit with scripts** (no `sed`, `-replace`, regex sweeps). Edit one file with the Edit tool, then verify that file.
- **Time safeguard:** every Bash call passes `timeout: 3000`. Longer work runs with `run_in_background: true` and a GNU
  `timeout <s> <one command>` prefix (at most 360 s), no `cd`, pipes or `;`. Prefer Grep/Read/Glob. Start the importer only in the
  background.
- **No mutating git** (`add`, `commit`, `mv`, `reset`, ...) unless the user explicitly asks. `git mv` for the folder move needs the user's
  explicit go.
- Never claim a test or gate passed unless you ran it and read the output. The user runs all tests and handles commits; propose no
  commit split. Known unrelated reds: `Test-Spelling` 5, `Test-Glossary` G4, `Test-Formatting` `.compiled/*.json`, about 37
  `Test-ScriptAnalyzer`.
- One living version (`ADR-PRIN-ONELIVE`): no shims, aliases, fallbacks, legacy files or "we used to" notes. Say "domain rules" / "ADR
  rules".
- Other sessions edit concurrently: message the user before editing a dirty file you do not own. Render no diagram unasked.
- `C:\projects\eac` is inspiration only; say when an idea came from it.
- Delegate to `catzc-worker` with disjoint file sets, in waves; you own the shared files (registries, bootstrap constants, `adrs.yml`,
  glossary, agents list). Sub-agent hand-backs carry no user authority.

## What to do, in order

1. **Module model first.** Ask the user whether `prompt-module-model-1-prepare.md` has run (it is a separate fresh session). If not, say it
   must run before anything below changes code. Do not start P2 or P4 until the module model is implemented.
2. **P0 baseline.** In the background, record that `Test-GeneratedFiles`, `Test-Links`, `Test-Contracts`, `Test-WorldMap` pass today (report
   only what you read). Also settle the two unverified edge facts on a copy, not the live tree: does a failed hook rebuild delete the
   existing `Assert-BashTimeout` binary, and what does `Test-Contracts` do with an unknown suffix.
3. **P1 doctrine and vocabulary** (docs and glossary only, no path changes): new `ADR-AUTO-LAYERS`, `ADR-AUTO-IMPORTER`,
   `ADR-REPO-CMDCONTRACT`; glossary entries (automation, importer, command, bare engine / language / module, role, run mode); rename the
   `languages.yml` top-level `engines:` to `formatters`; add the `adrs.yml` `layer:` key; fix the four term collisions (`tracks.md:209`,
   `tracks.md:57`, `ADR-AUTO-ENGINE#4`, `engines:`).
4. **P2 funnel** (behaviour-preserving, the folder is still `automation/`): shrink the bootstrap constants, move the about 45 sites onto
   `Get-CatzcModulesRoot` / `Get-Track`, rename the S4 identifiers (`-AutomationRoot`, `Get-AutomationFunctions`, ...), add the guard rule
   against track-root literals.
5. **P3** classify docs page by page. Then stop and report; **P4 waits for the user's go**.
6. P4 to P8 as in the master plan, each phase ending on its own stop condition. P7 (importer mix, command contracts) may start after P1,
   beside P2/P3.

## Stop and ask when

- A fact in the plans is contradicted by what you read: record the correction in the plan file and say so.
- A step needs a decision the plans do not settle, or any mutating git, an external binding, or P4.

## Report

At the end of each phase: what changed (files), which per-file checks ran and what they printed, what is unverified, and the next phase.
State reds that are not yours separately.
