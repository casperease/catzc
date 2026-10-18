---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: P3 after task-layers-funnel; P4 and P6 on the user's explicit go (D10), in a quiet window with no peer-dirty files
  targets: [docs/explanation/automation, docs/how-to/automation, docs/references/pwsh, pwsh, out, .github, pipelines]
---

# Task: layers P3 classification, then the flip P4 and the pipeline names P6

P3 changes no path: it classifies pages and drafts ADR wording against the placeholder TRACK. P4 is the one phase that cannot be
interleaved: `git mv automation pwsh` in the user's window, run by the user (a mutating git command). P6 renames the externally bound
pipeline names the same day the user re-points Azure DevOps and GitHub. P8 diagrams are dropped (Q23).

## Steps

1. [x] Done 2026-10-18: the table is in the plan's section 8 (P3 classification), 165 hand pages, 94 move and 71 stay; the reference mirror
       holds 69 hand pages, not 56 (the module articles and diagram descriptions count). Original step: P3 classification table in the plan:
       every hand page in `docs/explanation/automation`, `docs/how-to/automation`, `docs/how-to/getting-started/automation` and the 56 hand
       pages inside `docs/references/pwsh`: page, topic, move (a pwsh topic) or stay (an abstract topic). `docs/adr/automation` stays (Q4).
       Check: every page has a row; report and stop.
2. [x] Done 2026-10-18: the drafts are in the plan's section 7 (P3 wording drafts), 22 rules: 18 reworded, ADR-DSGN-RUNMODE#6,
       ADR-REPO-FILEMETA#12 and ADR-REPO-CONTRACT#2 need no edit, ADR-DSGN-TRACK#5 lands with P6. Original step: ADR rules that state the
       folder as a fact (worklist section 7): list each with its new wording against TRACK; no edit until P4. Check: the list in the plan.
3. [x] P4 preconditions, met 2026-10-18: the user named the window ("quiet window now"), every peer session stopped, and the hook kept
       working through the move. The record as it stood before:
   - P1 to P3 green on touched files: true (P2's stop check: guard one hit, the orphan template for the user's delete; Test-GeneratedFiles 0
     issues).
   - No peer-dirty file: false today; session catzc-cc has five ADR files and `variants.yml` open for config-defaults-postures.
   - A hook-recovery path out of band: true. The hook finds `timeouts.yml` in whichever top-level folder holds it, and Build-BashTimeoutHook
     builds it with the folder from `Get-CatzcModulesFolder`, so a `git mv` keeps the published hook working; if it still fails, every Bash
     call is denied and the user recovers in a terminal (`. ./importer.ps1` republishes it, or removes the hook from `.claude/settings.json`
     for the window).
   - The user has named the window (D10): not yet. Original step: P4 preconditions recorded: P1 to P3 green on touched files; `git status`
     shows no peer-dirty file; a hook-recovery path exists out of band; the user has named the window (D10). Check: four lines in the plan,
     each true.
4. P4, the user runs: `git mv automation pwsh`; `.catzc/<track>` becomes `.catzc/pwsh`; build outputs `out/pwsh/built` and
   `out/pwsh/packages` (Q6); the tracks registry row and the one bootstrap constant change to pwsh; `Build-RootConfig` regenerates
   importer.ps1; the docs mirror `docs/references/pwsh` follows the folder for the moved pages of step 1. One source edit per step,
   generators after. Check: the P0 baseline gates green again (Test-GeneratedFiles, Test-Links, Test-Contracts, Test-WorldMap). Done
   2026-10-18 by session catzc-cc with the user's leave for `git mv`: `automation/` became `pwsh/` and `docs/references/automation/` became
   `docs/references/pwsh/` (3,797 renames), and the eleven P3 "move" pages went to `docs/explanation/pwsh`, `docs/how-to/pwsh` and
   `docs/how-to/getting-started/pwsh`. The bootstrap set by hand (the importer constant, Get-CatzcModulesRoot, Get-CatzcRunMode,
   Get-CatzcOverlayRoot, CommentsConfig's default pages, the importer shim line, the exporter's `out/pwsh/{built,packages}`), the tracks
   `pwsh` and `pwsh-vendor`, the module-types root, then 64 configs, assets and tests one file at a time and 2,184 docs files by a
   one-file-at-a-time path pass that rewrote only code-folder paths, the mirror and the moved pages, never the ADR domain
   `docs/adr/automation` or the concern word. Generators reran and the flat minimap pages were restamped. Check: `GENERATED issues=0`,
   `CONTRACTS issues=0`, `LINKS issues=0` over the tree, `COMMENTS issues=0`, `FILEMETA issues=0`, `FOLDERS issues=0`; Test-WorldMap has one
   finding, the build output under `pwsh/.internal/assets/{obj,bin}` that the move staged before `.gitignore` knew the new path (the user's
   `git rm --cached` of `out/p4-unstage.txt`, 66 files, which the permission settings kept from this session); the grep for `automation/`
   code paths is empty. The tests of every touched file passed, the full and reduced builds included (Import-Catzc.Tests).
5. [x] The ADR rules of step 2 edited to the present tree. Check: Test-AdrRegistry, Test-Links, Test-AdrEngineNeutrality clean. Done
       2026-10-18: ADR-DSGN-TRACK#1 to #3 and its context, ADR-DSGN-RUNMODE#1, #4 and #7, ADR-DSGN-ASPECT#3 and #5, ADR-REPO-FOLDERS#4 with
       its Level 2 heading and anchor, ADR-REPO-CODEMETA#2 (folder-free), ADR-AUTO-BUNDLE#1, ADR-AUTO-OVERLAY#2, #3 and #9 (and the
       source-mode sentence now matching rule 8), ADR-AUTO-PARITY#1; ADR-DSGN-TRACK#5 waits for P6. `ADRREG issues=0`,
       `ADR-NEUTRALITY issues=0`, Test-Links, Test-Glossary, Test-Markdownlint and Test-Spelling clean on the eight ADRs.
6. P5 guards: avoid-phrasings for the retired uses ("automation folder", "automation track", "automation modules", "automation layer",
   "PowerShell automation") in `glossary.yml`; the P2 analyzer rule stays. Check: Test-Glossary clean; G4 reports none in tracked prose.
7. P6, one atomic set: `ci-automation` to `ci-pwsh`, `ci-automation-expected-failures` to `ci-pwsh-expected-failures`, the globset and
   `pipeline:` key, workflow and pipeline files, their file-name-keyed contract fragments, `docs/references/pipelines/*`, the README badge,
   `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples. `invoke-automation` and `release-automation` stay (Q2). The user
   re-points the Azure DevOps definitions, GitHub required checks and bookmarks the same day. Check: triggers fire on the next push; the
   contract check is clean.
8. Tick P3, P4, P5 and P6 in the plan as each lands. Check: grep `- [ ]` counts P7 (task-command-contracts) only.

## Report

As report-fixed; P4 is reported only after the user has run it.
