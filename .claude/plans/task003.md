---
task:
  id: "003"
  status: done
  plans: [plan-clear-actions, value-of-plan]
  value: medium
  blocked_on: nothing
  targets: [.claude/plans]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task003.md"
    folder: plans
    name: task003
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task003: value-of-plan.md rows for the unlisted plans, prompt deletions after diff, questionnaire trim

value-of-plan.md is the sorting overlay (plan-value capability: the rank lives there and in each head's value key). Six plans written on
2026-10-17 have no row. Three continuation prompts are delete candidates once their plans hold every item. The questionnaire is 740 lines
and only the numbers that decisions-2026-10-16.md cites need to stay findable.

## Correction (2026-10-17)

Step 6's premise does not hold: the decisions file cites every number Q01 to Q140, and each item has one context paragraph and no
duplicate, so a trim under its own rule removes nothing. Recorded as judged, 740 lines kept. Every `Test-Links` verdict below is
`[Write-QualityGateReport] No links issues found.`; `Format-FileMeta` re-stamped each edited head. Note for the next executor: the check
script resolves the importer by absolute path, because the shell's working directory moved mid-task and three checks silently did not run
until that was fixed and they were rerun.

## Steps

1. [x] `value-of-plan.md`: seven rows added (six in the meta table, plan-assert-wait in the feature table), the plan-clear-actions State
   refreshed, `reviewed` re-stamped. Check: `ls plan-*.md` against the table finds no plan without a row; column counts uniform (24 rows of
   six, 4 of five); `out/test-links/20261017-055918-3`.
2. [x] The seven heads' `value:` (highest, low, low, medium, low, medium, medium) match their rows. Check: grep agrees.
3. [x] `prompt-head-path-split-continue.md`: both items in the plan (spelling-gate step; Q43 decided). Verdict in `plan-clear-actions.md`,
   delete is the user's `git rm`.
4. [x] `prompt-file-kinds-registry-continue.md`: all three items plus the peers rule in the plan (Q51 done; five-gates step; Q45 decided).
   Verdict recorded, the user's `git rm`.
5. [x] `prompt-file-kinds-and-formatting-continue.md`: all three items plus the peers rule in the plan (Q47 step; Q41 decided; Q48, Q49
   context); the mid-sentence cut is in the plan's Refs. Verdict recorded, the user's `git rm`.
6. [x] `questionnaire-2026-10-16.md`: no edit (see the correction). Check: all 140 cited numbers resolve to a `### Q` heading; 740 lines
   recorded in `plan-clear-actions.md`.
7. [x] `value-of-plan.md` "Decision round": the next-funnel line (Q102 to Q126 plus D01 to D16) exists. Check: same report as step 1.
8. [x] `plan-clear-actions.md`: the questionnaire, delete-candidates and value-of-plan lines ticked with their verdicts. Check:
   `out/test-links/20261017-055918`; `plan-master.md` pointer updated, `out/test-links/20261017-055918-2`.

## Report

As report-fixed.
