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
- Kept on purpose: the 2026-10-16 questionnaires (decisions rows cite their Q numbers, and the questions live nowhere else) and the
  2026-10-18 round files (answers the user still owes).

## Open steps

- [ ] `plan-adr-link-cleanup-prose-to-pages.md`: trim the carried draft (434 lines) when catzc-cc releases the file. Check: `Test-Links`
      reports 0 dangling.
- [ ] `plan-layers-vocabulary-rename-contracts.md`: trim the 890-line file after its data is in the tree, when catzc-cc releases it. Check:
      `Test-Links` reports 0 dangling.
- [ ] `plan-module-kinds-tracks.md`: trim (956 lines) when catzc-cc releases it. Check: `Test-Links` reports 0 dangling.
- [ ] The topic prompts superseded by task files (prompt-automation-layers-continue, prompt-config-defaults-continue,
      prompt-k8s-kinds-1-prepare, prompt-k8s-kinds-2-implement, prompt-adr-links-and-plans-continue) and the landed module-model prompts
      (prompt-module-model-1-prepare, prompt-module-model-2-implement): delete each once no plan links it; their links sit in plans catzc-cc
      holds. Check: `Test-Links` clean on `.claude/plans`.
- [ ] After the user's full test run: delete `plan-bounded-folder-enumeration.md` and `prompt-bounded-folder-enumeration-continue.md`
      (check: both files gone, `Test-Links` clean on `.claude/plans`).
- [ ] `out/test-links/20261016-2012*`: the 36 report folders of the verdict pass are gate output; clear them when the user agrees (check:
      `ls out/test-links` lists no `20261016-2012*` folder).

## Vocabulary steps, one per flagged file

`Test-Glossary` flags bare terms in these files ("full suite" for "all tests", "gate", "phase", "layer", "source", "slot"). No sweep: each
file is fixed when it is next edited for its own reason (D15: no exemption for plan files).

- [ ] Fix the flagged wording file by file, each when that file is next edited, and strike the file from the list below (check: the next
      `Test-Glossary` run names no line in the struck file; the list below is empty when the step is done).

The files: `plan-layers-vocabulary-rename-contracts.md`, `questionnaire-2026-10-16.md`, `plan-module-kinds-tracks.md`,
`decisions-2026-10-16.md`, `plan-config-defaults.md`, `value-of-plan.md`, `questionnaire-fundamental-2026-10-16.md`,
`questionnaire-fundamental-2-2026-10-16.md`, `plan-adr-link-cleanup-prose-to-pages.md`, `plan-assert-wait.md`,
`prompt-module-model-2-implement.md`, `prompt-k8s-kinds-2-implement.md`, `prompt-bounded-folder-enumeration-continue.md`,
`plan-unboxing.md`, `prompt-module-model-1-prepare.md`, `prompt-config-defaults-continue.md`, `prompt-automation-layers-continue.md`,
`plan-module-model-closeout.md`.
