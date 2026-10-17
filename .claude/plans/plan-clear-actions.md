---
plan:
  status: active
  value: medium
  reviewed: 2026-10-17
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: d5fc4fcd55b3
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

## Steps

- [ ] `plan-minimal-robots.md`: judge it (it was skipped). Check: a verdict row exists and `Test-Links` is clean.
- [ ] `plan-adr-link-cleanup-prose-to-pages.md`: re-point 15 dangling links (lines 79-86, 205, 263, 308, 334, 348, 349, 420, 427, all
      `.claude/docs/adr/...` to `docs/adr/...`), then trim the carried draft (434 lines). Check: `Test-Links` reports 0 dangling.
- [ ] `plan-config-defaults.md`: re-point 3 sibling links (lines 243, 247, 250) to the plans that now hold the text. Check: `Test-Links`
      reports 0 dangling.
- [ ] `plan-layers-vocabulary-rename-contracts.md`: re-point 9 dangling links (lines 111-113, 359, 360, 532, 533, 712), then trim the
      890-line file after its data is in the tree. Give line 88 a check. Check: `Test-Links` reports 0 dangling.
- [ ] `plan-module-kinds-tracks.md`: re-point 3 dangling links (lines 98, 104, 370), then trim (956 lines). Give line 85 a check. Check:
      `Test-Links` reports 0 dangling.
- [ ] `plan-plans-body-sha-landing-zone.md`: re-point 2 links (line 114 `file-meta.md`, line 146 `sensible-defaults.md`). Check:
      `Test-Links` reports 0 dangling.
- [ ] `plan-materialization-of-knowledge.md`: say where the text of `adr-draft-materialization.md` now lives. Check: no `out/` path to an
      absent file remains.
- [ ] `value-of-plan.md`: fix lines 137 and 139 (`out/prompt-*-continue.md`, `out/adr-draft-materialization.md`); keep rows for live plans.
      Check: no named path is absent.
- [ ] `plan-file-head-immutable-edges-classes.md`: trim "Done" sections whose data is in the tree; give the 13 unchecked steps (lines 102,
      104, 107, 108, 110, 113, 135-138, 142, 146, 149) a check on the line itself; skip steps that sit in a peer's files.
- [ ] `plan-out-artifacts.md`: give lines 62, 67, 69, 84 a check. `plan-bounded-folder-enumeration.md` line 50: give it a check.
- [ ] `questionnaire-2026-10-16.md`: trim (716 lines). Keep the question numbers that `decisions-2026-10-16.md` rows cite.
- [ ] `plan-adr-ai.md`: drop the repeated "plan-intake, plan-decide" line.
- [ ] Delete candidates, each only after a line-by-line diff shows its plan holds every item:
      `prompt-file-kinds-and-formatting-continue.md`, `prompt-file-kinds-registry-continue.md`, `prompt-head-path-split-continue.md`.
- [ ] After the user's level-2 gate run: delete `plan-bounded-folder-enumeration.md` and `prompt-bounded-folder-enumeration-continue.md`.
- [ ] `out/test-links/20261016-2012*`: the 36 report folders of the verdict pass are gate output; clear them when the user agrees.

## Keep as is

`decisions-2026-10-16.md`, `plan-adr-cats.md`, `plan-format-step-moves-comments.md`, `plan-lazy-types-load.md`,
`plan-minimal-robots-agents.md`, `plan-minimal-robots-capabilities.md`, `plan-test-run-budget.md`, `plan-unboxing.md`, the
`prompt-*-continue.md` and `prompt-k8s-*` / `prompt-module-model-*` files that pair with an open plan, and the two fundamental
questionnaires.
