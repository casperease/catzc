---
task:
  id: "002"
  status: open
  plans:
    [
      plan-clear-actions,
      plan-fast-push-followups,
      plan-idle-compaction,
      plan-csproj-xml-head,
      plan-skip-unchanged-generators,
      plan-adr-ai,
      plan-minimal-robots,
    ]
  value: medium
  blocked_on: nothing
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: "4f18876a7220"
    repo_status: clean
    path: ".claude/plans/task002.md"
    folder: plans
    name: task002
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task002: a check on every open step, plan-shape for the numbered-step plans, small plan fixes

Plan-shape (ADR-REPO-PLANS to be, Q04): open steps are checkboxes that name the check proving them. Four plans written on 2026-10-17 use
numbered lists or bold questions instead, so a grep for `- [ ]` counts zero open steps in them and the cleaner would judge them done.
Thirteen steps in the file-head plan and a few elsewhere have no check on the line. Edit one file at a time; re-read after each edit;
Test-Links on each edited file as in task001.

## Steps

1. `plan-fast-push-followups.md`: the three numbered items under "Open steps" become `- [ ]` lines; item 1 (check:
   `Build-RootConfig.Tests.ps1` passes), item 2 split in two (check: Test-AdrRegistry no longer names ADR-AI; Test-Glossary findings
   assigned to owners), item 3 marked "the user's, by hand" (check: one real Push-Dirty run reported). Check: grep `- [ ]` counts 4.
2. `plan-idle-compaction.md`: "Steps" 1-3 become checkboxes; Q1 stays an open question (check: its answer recorded; the plan deleted after).
   Check: grep counts 2 open steps.
3. `plan-csproj-xml-head.md`: Q1 and Q2 under "Open" become `- [ ]` steps (Q1 check: Test-Links on the PropertyHead page and the two help
   pages; Q2 check: the four tests run against a tree without the change, result recorded); the DLL line stays context. Check: grep
   counts 2.
4. `plan-skip-unchanged-generators.md`: items 1-6 under "Open" become `- [ ]` steps, each with the check its text implies (1: a decision
   recorded; 2 and 3: a test proving no missed input; 4: a warm run skips; 5: numbers in the plan; 6: Test-FileMeta and Test-GeneratedFiles
   clean). Add `value: medium` is present; add `targets` stays. Check: grep counts 6.
5. `plan-file-head-immutable-edges-classes.md`: every `- [ ]` line without "(check:" gains one on the same line (verdict lines 102, 104,
   107, 108, 110, 113, 135-138, 142, 146, 149 at the time of the verdict; grep `- \[ \]` and filter lines lacking `check`). Check: no open
   step lacks a check.
6. `plan-out-artifacts.md`: the harvest steps (batch one, batch two, five tool candidates, six areas) each carry a check already; confirm;
   lines 62, 67, 69, 84 of the verdict are the Decided and harvest lines, give each a check or make them context lines. Check: no `- [ ]`
   without a check.
7. `plan-bounded-folder-enumeration.md` line 50 region ("Done, and why" leftover) and `plan-layers-vocabulary-rename-contracts.md` line 88,
   `plan-module-kinds-tracks.md` line 85: give each a check or demote to context. Check: no `- [ ]` without a check.
8. `plan-adr-ai.md`: the first paragraph repeats "plan-intake, plan-decide" twice; drop the repeat. Check: the names appear once.
9. `plan-minimal-robots.md`: it was skipped in the verdict pass; judge it against plan-shape (head keys present; open steps carry checks; no
   out/ provenance path to an absent file). Check: a verdict line in `plan-clear-actions.md` and Test-Links clean.
10. Glossary wording in plan text (Test-Glossary flags "full suite", "gate", "phase", "layer", "source", "slot" as bare terms; about 195
    findings): no sweep. Record in `plan-clear-actions.md` one step per plan file flagged, to be done when that plan is next edited. Check:
    the step list exists; nothing else changed.
11. Tick the matching verdict lines in `plan-clear-actions.md`. Check: Test-Links clean on it.

## Report

As report-fixed: files touched, checks run verbatim, left undone with reasons.
