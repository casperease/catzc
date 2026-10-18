---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [.claude/plans]
---

# The cleaner's open verdicts on this folder

Edit one file at a time, run `Test-Links -Path <file>` on it, then go to the next. Never sweep. A plan another session holds is skipped and
named in the report.

## Done, and why

- 2026-10-18 cleanup: plan-csproj-xml-head, plan-lazy-types-load and plan-materialization-of-knowledge deleted with their done tasks
  (task-lazy-types-load, task-adr-auto-material) and prompt-unboxing-continue (its task's leftover check is done); value-of-plan records
  each. The carried drafts whose data is in the tree were cut from plan-bounded-folder-enumeration (435 to 45 lines),
  plan-file-head-immutable-edges-classes (401 to 47), plan-plans-body-sha-landing-zone (266 to 44), plan-out-artifacts (215 to 44) and
  plan-test-run-budget (119 to 57); the ticked history of this file went too. git keeps every cut line.
- 2026-10-18, second pass: plan-unboxing and task-unboxing-closeout deleted (no open step once the user ruled the typed DLL ignored);
  value-of-plan.md lost its rows for plan-assets-beside-articles, plan-adr-ai, plan-adr-cats and plan-unboxing, all deleted earlier, and its
  State column re-read against the plans; the vocabulary list below lost the files that no longer exist.
- Kept on purpose: the 2026-10-16 questionnaires (decisions rows cite their Q numbers, and the questions live nowhere else) and the
  2026-10-18 round files (answers the user still owes).

## Open steps

- [x] `plan-adr-link-cleanup-prose-to-pages.md`: trim the carried draft when catzc-cc releases the file. Check: `Test-Links` reports 0
      dangling. Done 2026-10-18: Phase 1 is done (its placeholder fix moot since the held-codes merge went), so the draft's Phase 1 half is
      cut and its Phase 2 half, the open step's spec, stays; 450 to 222 lines.
- [x] `plan-layers-vocabulary-rename-contracts.md`: trim after its data is in the tree. Check: `Test-Links` reports 0 dangling. Judged
      2026-10-18, verdict keep: its four carried drafts (the rename map and phases, the layer vocabulary, the command contracts, the rename
      worklist) are the specs of the open phases P2 to P8, so none is in the tree yet; trim each as its phase lands.
- [x] `plan-module-kinds-tracks.md`: trim. Check: `Test-Links` reports 0 dangling. Done 2026-10-18: the module-model, track-type,
      track-structure and tracks-modules-types drafts are in the tree (ADR-AUTO-MODULE, ADR-DSGN-TRACKTYPE, ADR-DSGN-MODTYPE; the track-type
      Q1 to Q5 answered by its rules, LoadedModule dropped by D03) and are cut; the k8s kinds draft stays for the kind-to-role task; 1,062
      to 266 lines. plan-config-defaults keeps its draft too: Phases 2, 4 and 5 are open.
- [x] The topic prompts superseded by task files (prompt-automation-layers-continue, prompt-config-defaults-continue,
      prompt-k8s-kinds-1-prepare, prompt-k8s-kinds-2-implement, prompt-adr-links-and-plans-continue) and the landed module-model prompts
      (prompt-module-model-1-prepare, prompt-module-model-2-implement): delete each once no plan links it. Check: `Test-Links` clean on
      `.claude/plans`. Done 2026-10-18: catzc-cc dropped their links; the seven are deleted, two Refs lines that named them removed; the
      mentions left are history in ticked steps. The minimap pages under docs/explanation/.assets name them until their next render.
- [ ] After the final session's full run (task-user-runs-and-commits, last step): delete `plan-bounded-folder-enumeration.md` and
      `prompt-bounded-folder-enumeration-continue.md` (check: both files gone, `Test-Links` clean on `.claude/plans`).
- [ ] `out/test-links/20261016-2012*`: the 36 report folders of the verdict pass are gate output; clear them when the user agrees (check:
      `ls out/test-links` lists no `20261016-2012*` folder).

## Vocabulary steps, one per flagged file

`Test-Glossary` flags bare terms in these files ("full suite" for "all tests", "gate", "phase", "layer", "source", "slot"). No sweep: each
file is fixed when it is next edited for its own reason (D15: no exemption for plan files).

- [ ] Fix the flagged wording file by file, each when that file is next edited, and strike the file from the list below (check: the next
      `Test-Glossary` run names no line in the struck file; the list below is empty when the step is done).

The files: `plan-layers-vocabulary-rename-contracts.md`, `questionnaire-2026-10-16.md`, `decisions-2026-10-16.md`, `value-of-plan.md`,
`questionnaire-fundamental-2026-10-16.md`, `questionnaire-fundamental-2-2026-10-16.md`, `plan-assert-wait.md`,
`prompt-bounded-folder-enumeration-continue.md`, `plan-module-model-closeout.md`. Struck 2026-10-18 as deleted files:
plan-module-kinds-tracks, plan-config-defaults, plan-adr-link-cleanup-prose-to-pages, plan-unboxing and the five topic prompts.
