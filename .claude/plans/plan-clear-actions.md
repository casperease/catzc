---
plan:
  status: active
  value: medium
  reviewed: 2026-10-17
  targets: [.claude/plans]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-clear-actions.md"
    folder: plans
    name: plan-clear-actions
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Acting on the plan-clear verdicts of 2026-10-16

The verdict pass over this folder (36 files) judged every plan and acted on none. The verdicts are the steps below, each with its check.
Edit one file at a time, run `Test-Links -Path <file>` on it, then go to the next. Never sweep. A plan with a peer's uncommitted edits is
skipped and named in the report.

## Findings that cross files

- No plan has zero open steps, so none is deleted as done. Nothing was pasted, so there is no intake step.
- 32 broken links in 5 files, from two causes: links written from `out/` that resolve to `.claude/docs/...` from this folder, and sibling
  links to `plan-*.md` files that were folded into the carried drafts.
- 13 files carry an `out/plan-*.md` provenance path that no longer exists. Re-point or trim per `plan-shape`.
- Three plans run over 400 lines: layers (890), module-kinds (956), file-head (365 with carried drafts).
- `plan-minimal-robots.md` was not judged (dirty during the pass). Judge it first.
- Correction (task001, 2026-10-17): the 32 links were already re-pointed in the tree when the task ran (`../../docs/adr/...` targets,
  sibling plan names); `Test-Links` reports "No links issues found." on all six files (reports `out/test-links/20261017-053922` and
  `20261017-054019` to `-6`). The remaining `out/plan-*.md` mentions are backticked provenance prose in the "Carried" headings, not links.

## Open steps

- [x] `plan-minimal-robots.md`: judged 2026-10-17 (task002), verdict keep: head keys present (status, value, reviewed, targets, siblings),
      three open steps each with a check, its one `out/` path (`out/drawio/token-count.md`) exists, no provenance path to an absent file;
      `reviewed` re-stamped. Check: `Test-Links` clean (`out/test-links/20261017-055215-2`).
- [x] `plan-adr-link-cleanup-prose-to-pages.md`: re-point 15 dangling links. Check: `Test-Links` 0 dangling (`out/test-links/20261017-053922`).
- [ ] `plan-adr-link-cleanup-prose-to-pages.md`: trim the carried draft (434 lines). Check: `Test-Links` reports 0 dangling.
- [x] `plan-config-defaults.md`: re-point 3 sibling links to the plans that now hold the text. Check: `Test-Links` 0 dangling
      (`out/test-links/20261017-054019-3`).
- [x] `plan-layers-vocabulary-rename-contracts.md`: re-point 9 dangling links. Check: `Test-Links` 0 dangling (`out/test-links/20261017-054019`).
- [ ] `plan-layers-vocabulary-rename-contracts.md`: trim the 890-line file after its data is in the tree. Check: `Test-Links` reports 0
      dangling.
- [x] `plan-module-kinds-tracks.md`: re-point 3 dangling links. Check: `Test-Links` 0 dangling (`out/test-links/20261017-054019-2`).
- [ ] `plan-module-kinds-tracks.md`: trim (956 lines). Check: `Test-Links` reports 0 dangling.
- [x] Open steps without a check (the verdict's `plan-layers-vocabulary-rename-contracts.md` line 88, `plan-module-kinds-tracks.md` line 85,
      `plan-bounded-folder-enumeration.md` line 50, `plan-out-artifacts.md` lines 62, 67, 69, 84, the 13 steps of
      `plan-file-head-immutable-edges-classes.md`): every one carries its "(check: ...)" on a wrapped continuation line already; the verdict
      pass read single lines. Check: a grep over wrapped `- [ ]` items in those five files finds none without "check" (task002, 2026-10-17).
- [x] `plan-plans-body-sha-landing-zone.md`: re-point 2 links (`file-meta.md`, `sensible-defaults.md`). Check: `Test-Links` 0 dangling
      (`out/test-links/20261017-054019-4`).
- [x] `plan-materialization-of-knowledge.md`: say where the text of `adr-draft-materialization.md` now lives (its Refs line and the
      "Carried" heading say so; the Refs path to the caching ADR corrected to `docs/adr/automation/caching.md`). Check: no `out/` path to an
      absent file remains (`out/test-links/20261017-054248`).
- [x] `value-of-plan.md`: the `out/prompt-*-continue.md` and `out/adr-draft-materialization.md` paths are gone; rows for live plans kept.
      Check: every named path exists (`ls` on `docs/explanation/automation/reference-unboxing.md`, `out/README.md`, the six out/ scripts;
      `Test-Links` 0 dangling, `out/test-links/20261017-054019-6`).
- [ ] `plan-file-head-immutable-edges-classes.md`: trim "Done" sections whose data is in the tree; skip steps that sit in a peer's files.
      Check: `Test-Links` reports 0 dangling.
- [x] `questionnaire-2026-10-16.md`: judged for a trim 2026-10-17 (task003): 740 lines, 140 items Q01 to Q140, every number cited by a
      `decisions-2026-10-16.md` row, one context paragraph per item and no duplicated paragraph (two repeated one-word lines only). A trim
      under the rule (never an item, its number or its context) removes nothing, so the file stays at 740 lines. Check: every Q number a
      decisions row cites resolves to a heading (grep of `Q[0-9]+` in decisions against `### Q` headings: all 140 present).
- [x] `plan-adr-ai.md`: the repeated "plan-intake, plan-decide" dropped in both sentences. Check: `Test-Links` clean
      (`out/test-links/20261017-055215`).
- [x] Plan-shape for the four numbered-step plans (task002): `plan-fast-push-followups.md` (4 steps, `out/test-links/20261017-055059-2`),
      `plan-idle-compaction.md` (2, `20261017-055042`), `plan-csproj-xml-head.md` (2, `20261017-055059`), `plan-skip-unchanged-generators.md`
      (6, `20261017-055142`). Check: grep `- [ ]` counts as listed and `Test-Links` clean on each.
- [x] Delete candidates, diffed line by line against `plan-file-head-immutable-edges-classes.md` (task003, 2026-10-17); each is now the
      user's `git rm`:
      `prompt-head-path-split-continue.md`: the spelling-gate run is the first step of "Open leftovers from the path split"; folder and name
      on generated heads is Decided (Q43) there.
      `prompt-file-kinds-registry-continue.md`: the memory-note check is Done (Q51), the five gates are the first step of "Open leftovers from
      the registry work", PowerShell versus Powershell is Decided (Q45), the peers rule is the "Rule to keep" line.
      `prompt-file-kinds-and-formatting-continue.md`: the Test-Formatting rerun and the `.compiled` question are the first step of "Open
      leftovers from that follow-up" (Q47), the reachability decision is Decided (Q41), the Test-Comments findings and the untracked page
      are its context lines (Q48, Q49), the peers rule is the "Rule to keep" line; its mid-sentence cut is recorded in the plan's Refs.
- [x] `value-of-plan.md`: rows for the seven unlisted plans (plan-master, plan-fast-push-followups, plan-skip-unchanged-generators,
      plan-csproj-xml-head, plan-idle-compaction, plan-assets-gallery-pdf in the meta table; plan-assert-wait in the feature table), each
      head's `value` matching its row; the next-funnel line under "Decision round". Check: `ls plan-*.md` against the table finds no plan
      without a row; `Test-Links` clean (report in task003).
- [ ] After the user's level-2 gate run: delete `plan-bounded-folder-enumeration.md` and `prompt-bounded-folder-enumeration-continue.md`
      (check: both files gone, `Test-Links` clean on `.claude/plans`).
- [ ] `out/test-links/20261016-2012*`: the 36 report folders of the verdict pass are gate output; clear them when the user agrees (check:
      `ls out/test-links` lists no `20261016-2012*` folder).

## Vocabulary steps, one per flagged file

`Test-Glossary` (report `out/test-glossary/20261017-012431`, 196 issues) flags bare terms in these files ("full suite" for "all tests",
"gate", "phase", "layer", "source", "slot"). No sweep: each file is fixed when it is next edited for its own reason.

- [ ] Fix the flagged wording file by file, each when that file is next edited, and strike the file from the list below (check: the next
      `Test-Glossary` run names no line in the struck file; the list below is empty when the step is done).

The files, with their finding counts: `plan-layers-vocabulary-rename-contracts.md` (24), `questionnaire-2026-10-16.md` (18),
`plan-module-kinds-tracks.md` (16), `decisions-2026-10-16.md` (15), `plan-config-defaults.md` (9), `value-of-plan.md` (7),
`plan-out-artifacts.md` (7), `questionnaire-fundamental-2026-10-16.md` (6), `questionnaire-fundamental-2-2026-10-16.md` (6),
`plan-adr-link-cleanup-prose-to-pages.md` (6), `plan-plans-body-sha-landing-zone.md` (5), `plan-assert-wait.md` (4),
`prompt-module-model-2-implement.md` (3), `plan-minimal-robots-capabilities.md` (3), `plan-file-head-immutable-edges-classes.md` (3),
`plan-bounded-folder-enumeration.md` (3), `prompt-k8s-kinds-2-implement.md` (2), `prompt-bounded-folder-enumeration-continue.md` (2),
`plan-unboxing.md` (2), `plan-minimal-robots-agents.md` (2), `plan-format-step-moves-comments.md` (2), and one each in
`prompt-unboxing-continue.md`, `prompt-module-model-1-prepare.md`, `prompt-head-path-split-continue.md`,
`prompt-config-defaults-continue.md`, `prompt-automation-layers-continue.md`, `plan-test-run-budget.md`,
`plan-skip-unchanged-generators.md`, `plan-module-model-closeout.md`, `plan-minimal-robots.md`, `plan-csproj-xml-head.md`,
`plan-adr-cats.md` and `plan-adr-ai.md`.

## Keep as is

`decisions-2026-10-16.md`, `plan-adr-cats.md`, `plan-format-step-moves-comments.md`, `plan-lazy-types-load.md`,
`plan-minimal-robots-agents.md`, `plan-minimal-robots-capabilities.md`, `plan-test-run-budget.md`, `plan-unboxing.md`, the
`prompt-*-continue.md` and `prompt-k8s-*` / `prompt-module-model-*` files that pair with an open plan, and the two fundamental
questionnaires.
