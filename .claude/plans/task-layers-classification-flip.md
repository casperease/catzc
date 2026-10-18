---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: P6 on the user's explicit go, the same day the user re-points Azure DevOps and GitHub
  targets: [docs/explanation/automation, docs/how-to/automation, docs/references/pwsh, pwsh, out, .github, pipelines]
---

# Task: layers P3 classification, then the flip P4 and the pipeline names P6

P3 and P4 have landed: `automation/` is `pwsh/` since 2026-10-18. P6 renames the externally bound pipeline names the same day the user
re-points Azure DevOps and GitHub. P8 diagrams are dropped (Q23).

## Steps

1. [x] Done 2026-10-18: the table is in the plan's section 8 (P3 classification), 165 hand pages, 94 move and 71 stay; the reference mirror
       holds 69 hand pages, not 56 (the module articles and diagram descriptions count). Original step: P3 classification table in the plan:
       every hand page in `docs/explanation/automation`, `docs/how-to/automation`, `docs/how-to/getting-started/automation` and the 56 hand
       pages inside `docs/references/pwsh`: page, topic, move (a pwsh topic) or stay (an abstract topic). `docs/adr/automation` stays (Q4).
       Check: every page has a row; report and stop.
2. [x] Done 2026-10-18: the drafts are in the plan's section 7 (P3 wording drafts), 22 rules: 18 reworded,
       ADR-DSGN-RUNMODE-SAMETESTSBOTHMODES, ADR-REPO-FILEMETA-MODULEFACTS and ADR-REPO-CONTRACT-LAYOUT need no edit,
       ADR-DSGN-TRACK-DEPLOYABLEUNIT lands with P6. Original step: ADR rules that state the folder as a fact (worklist section 7): list each
       with its new wording against TRACK; no edit until P4. Check: the list in the plan.
3. [x] P4 preconditions, met 2026-10-18: the user named the window ("quiet window now"), every peer session stopped, and the hook kept
       working through the move.
4. [x] P4 done 2026-10-18 by session catzc-cc: `automation/` is `pwsh/` and `docs/references/automation/` is `docs/references/pwsh/`; the
       gates came back clean, and the obj/bin build output the move staged is no longer tracked. The word residue left after the move is
       plan-automation-word-residue.
5. [x] The ADR rules of step 2 edited to the present tree. Check: Test-AdrRegistry, Test-Links, Test-AdrEngineNeutrality clean. Done
       2026-10-18: ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER, ADR-DSGN-TRACK-ONETRACKTYPE and ADR-DSGN-TRACK-ONETECHSTACK and their context,
       ADR-DSGN-RUNMODE-TWORUNMODES, ADR-DSGN-RUNMODE-MODEISDERIVED and ADR-DSGN-RUNMODE-THREEBUILDKINDS, ADR-DSGN-ASPECT-TRACKPICKSCATCHALL
       and ADR-DSGN-ASPECT-PARTITIONISCHECKED, ADR-REPO-FOLDERS-DOTMEANSTOOLING with its Level 2 heading and anchor,
       ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY (folder-free), ADR-AUTO-BUNDLE-BUNDLEISBUILD, ADR-AUTO-OVERLAY-SAMERELATIVEPATH,
       ADR-AUTO-OVERLAY-MODULEOVERRIDEENTRIES and ADR-AUTO-OVERLAY-LOCALMODULE (and the source-mode sentence now matching rule 8),
       ADR-AUTO-PARITY-SAMECLIBOTHENVIRONMENTS; ADR-DSGN-TRACK-DEPLOYABLEUNIT waits for P6. `ADRREG issues=0`, `ADR-NEUTRALITY issues=0`,
       Test-Links, Test-Glossary, Test-Markdownlint and Test-Spelling clean on the eight ADRs.
6. [x] Landed 2026-10-18 by session catzc-fb, verdict: "Test-Glossary: 0 G-issues on each of the 25 edited files (glossary.yml + 24 pages);
       tree G4=31, all residue meanings outside this step". Five avoid-phrasings under the `automation` concept in
       `pwsh/Catzc.Base.Docs/configs/glossary.yml`; the real count was 24 pages, not 68; `docs/adr/glossary.md` is generated and left to
       Build-Glossary. The 31 G4 hits left are folder, track and modules meanings in plan-automation-word-residue (tracks.md:53 waits for
       P6). Decided 2026-10-18 by the orchestrator on the user's delegation: the forms `PowerShell` and `implementation` leave the layer
       family now (no page uses them any more); `automation` stays until P6, where the 31 residue hits and `ci-automation` go. Handed to
       catzc-fb. Original step: P5 guards: avoid-phrasings for the retired uses ("automation folder", "automation track", "automation
       modules", "automation layer", "PowerShell automation") in `glossary.yml`; the P2 analyzer rule stays; the 68 pages that still say
       "automation layer", "implementation layer" or "PowerShell layer" reworded one file at a time. Check: Test-Glossary on each edited
       file reports none; the final full run is the tree-wide proof.
7. P6, one atomic set: `ci-automation` to `ci-pwsh`, `ci-automation-expected-failures` to `ci-pwsh-expected-failures`, the globset and
   `pipeline:` key, workflow and pipeline files, their file-name-keyed contract fragments, `docs/references/pipelines/*`, the README badge,
   `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples. `invoke-automation` and `release-automation` stay (Q2). The user
   re-points the Azure DevOps definitions, GitHub required checks and bookmarks the same day. Check: triggers fire on the next push; the
   contract check is clean.
8. Tick P3, P4, P5 and P6 in the plan as each lands. Check: grep `- [ ]` counts P7 (task-command-contracts) only.

## Report

As report-fixed.
