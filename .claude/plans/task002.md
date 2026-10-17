---
task:
  id: "002"
  status: done
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

## Correction (2026-10-17)

Steps 5 to 7 rested on single-line greps: every open step they name already carries its "(check: ...)" on a wrapped continuation line, so
no edit was needed there. Each file's `Test-Links` verdict below is `[Write-QualityGateReport] No links issues found.`; `Format-FileMeta`
re-stamped every edited head.

## Steps

1. [x] `plan-fast-push-followups.md`: four `- [ ]` steps, the vocabulary item split from the registry item, the last marked the user's; the
   `blocked_on` line reworded to match. Check: grep counts 4; `out/test-links/20261017-055059-2`.
2. [x] `plan-idle-compaction.md`: two `- [ ]` steps; Q1 stays the open question (D06) and names the line its answer lands on. Check: grep
   counts 2; `out/test-links/20261017-055042`.
3. [x] `plan-csproj-xml-head.md`: Q1 and Q2 are `- [ ]` steps with their checks; the DLL line is marked context. Check: grep counts 2;
   `out/test-links/20261017-055059`.
4. [x] `plan-skip-unchanged-generators.md`: six `- [ ]` steps, each with the check its text implies; `value` and `targets` were already
   present. Check: grep counts 6; `out/test-links/20261017-055142`.
5. [x] `plan-file-head-immutable-edges-classes.md`: no edit; both remaining open steps (lines 145, 184) carry a check on their continuation
   lines. Check: a grep over wrapped `- [ ]` items finds none without "check".
6. [x] `plan-out-artifacts.md`: no edit; the four harvest steps carry their checks on continuation lines. Check: same grep, none without.
7. [x] `plan-bounded-folder-enumeration.md`, `plan-layers-vocabulary-rename-contracts.md`, `plan-module-kinds-tracks.md`: no edit; no open
   step lacks a check. Check: same grep, none without.
8. [x] `plan-adr-ai.md`: the repeat dropped in both sentences that had it (lines 36 and 83). Check: "plan-intake, plan-decide" appears once
   per sentence; `out/test-links/20261017-055215`.
9. [x] `plan-minimal-robots.md`: judged, verdict keep (head keys present, three open steps with checks, `out/drawio/token-count.md` exists);
   `reviewed` re-stamped 2026-10-17; verdict row in `plan-clear-actions.md`. Check: `out/test-links/20261017-055215-2`.
10. [x] Vocabulary: a "Vocabulary steps, one per flagged file" section in `plan-clear-actions.md` from report
    `out/test-glossary/20261017-012431` (196 issues, 33 plan-folder files), one checkbox per file with its count; nothing else changed.
11. [x] `plan-clear-actions.md`: verdict lines ticked (minimal-robots, adr-ai, the four plan-shape plans, the checks-on-open-steps line),
    the "give a check" clauses removed from the trim lines. Check: `Test-Links` clean (`out/test-links/20261017-055333`).

## Report

As report-fixed: files touched, checks run verbatim, left undone with reasons.
