---
task:
  id: "003"
  status: open
  plans: [plan-clear-actions, value-of-plan]
  value: medium
  blocked_on: nothing
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: "9be811ec4f79"
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

## Steps

1. `value-of-plan.md`, meta table: add rows for plan-master (highest; the one executable order; needs ADR-REPO-PLANS to name the task files;
   state: T001 to T004 written), plan-assets-gallery-pdf (low), plan-csproj-xml-head (low), plan-fast-push-followups (medium),
   plan-idle-compaction (low), plan-skip-unchanged-generators (medium), plan-assert-wait (medium; feature table). Columns: Why in one
   sentence, Needed docs, Needed tests, State, copied from each plan's head and sections. Check: every `plan-*.md` in the folder has a row
   (`ls plan-*.md` against the table).
2. `value-of-plan.md`: the heads of the six plans carry `value:`; confirm each matches its row. Check: a grep of `value:` across the six
   files agrees with the table.
3. `prompt-head-path-split-continue.md` against `plan-file-head-immutable-edges-classes.md` "Open leftovers from the path split": a
   line-by-line read; every item present in the plan. If yes, the file is a delete candidate for the user (`git rm` is the user's); record
   the verdict in `plan-clear-actions.md`. Check: the verdict line names each item and where it lives.
4. `prompt-file-kinds-registry-continue.md` against the same plan's "Open leftovers from the registry work": same procedure. Check: same.
5. `prompt-file-kinds-and-formatting-continue.md` against "Open leftovers from that follow-up": same procedure; its pasted text is cut
   mid-sentence, note that the cut is recorded in the plan's Refs. Check: same.
6. `questionnaire-2026-10-16.md`: trim to the items whose number a row of `decisions-2026-10-16.md` cites (Q01 to Q101 answered; Q102 to
   Q126 unasked stay as the next batch, so keep them too). Remove only duplicated context paragraphs, never an item or its number; numbers
   are never renumbered (plan-decide capability). Check: every Q number in the decisions table resolves to a heading in the questionnaire;
   line count recorded in `plan-clear-actions.md`.
7. `value-of-plan.md` "Decision round" section: add one line that the next funnel batch is Q102 to Q126 plus the D-items task004 lists.
   Check: the line exists.
8. Tick the matching verdict lines in `plan-clear-actions.md`. Check: Test-Links clean on every edited file (as in task001).

## Report

As report-fixed.
