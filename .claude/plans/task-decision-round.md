---
task:
  status: open
  plans:
    [
      plan-promotion-ladder,
      plan-layers-vocabulary-rename-contracts,
      plan-diagram-folders,
      plan-clear-actions,
      plan-out-artifacts,
      plan-assets-gallery-pdf,
      plan-automation-word-residue,
    ]
  value: high
  blocked_on: nothing; the round itself is the step
  targets: [.claude/plans]
---

# Task: the decision round of 2026-10-19

Seven plans hold a question only the user can answer, and two of them (plan-promotion-ladder, plan-diagram-folders) are blocked on nothing
else. One round through `plan-decide` asks them all: a questionnaire file, four items per ask with the recommendation first, every answer
recorded with its projected outcome, then folded into the owning plan (ADR-REPO-PLANS#9: a constraining decision becomes an ADR rule in the
change that lands it). The questions, with the plan that owns each:

- plan-promotion-ladder Q1 to Q4: where main-uat lives; what certifies RC and RBC; pre-prod a new subscription or a staging slot; whether
  DEPLOY takes the CI artifact by run id or tag. Answered 2026-10-18: every recommendation (the plan's Decided section).
- plan-layers-vocabulary-rename-contracts P7: the twelve exported functions nothing calls and the 139 only docs name: contract, make
  internal, or delete each set (the frozen set then holds Test-Contracts clean).
- plan-diagram-folders: approve the out/ pilot (`out/diagram-pilot/configuration/.assets/`, `out/diagram-pilot/sidebar-old-vs-new.png`) so
  the 150 diagrams move; or name what the pilot must change first. Answered 2026-10-18: approved.
- plan-clear-actions: a yes to clear the 36 `out/test-links/20261016-2012*` report folders. Answered 2026-10-18: yes.
- plan-out-artifacts: a yes for probe batch two (13 files), if not already given in task-user-runs-and-commits step 3. Answered
  2026-10-18: yes; the user runs it (task-user-runs-and-commits step 3).
- plan-assets-gallery-pdf: whether the drawio kit gets a test home (`.claude/drawio/tests/`) so the two-PNG fixture step can land, or the
  step is dropped and the plan deleted. Answered 2026-10-18: yes, `.claude/drawio/tests/`.
- plan-automation-word-residue, its two open questions: whether the how-to folders named `automation` (`docs/how-to/automation/`,
  `docs/how-to/getting-started/automation/`) keep the name as cross-track pages (recommended) or move; and whether the 31 test fixtures
  shaped like the old folder (`C:\repo\automation\M\...`) are renamed only when each test is next edited (recommended) or in one pass.
  Decided 2026-10-18 by the orchestrator on the user's delegation: both recommendations (the how-to folders keep the name; fixtures are
  renamed when each test is next edited).
- plan-layers-vocabulary-rename-contracts P7: answered by D26 and D27 (task-command-contracts step 7).

## Steps

1. `questionnaire-2026-10-19.md`: one item per question above, context, options, the recommendation first, an empty Decision line. Check:
   `Test-Plans -Path .claude/plans` clean; every owning plan's open question has an item.
2. Ask, four items per ask (`plan-decide`), recording each answer with its projected outcome in `decisions-2026-10-19.md` (the table form of
   `decisions-2026-10-18.md`). Check: no item without a Decision line, or an explicit "stays open".
3. Fold each decision into its owning plan: a Decided line, the open step reworded or unblocked, `blocked_on` cleared where the answer
   clears it. One plan file per edit, `Test-Links -Path <file>` after each. Check: `grep -n blocked_on .claude/plans/plan-*.md` names only
   plans with a question still open.
4. `plan-master.md`: the chunks the answers unblock lose their "waits for" wording (promotion-ladder, diagram-folders, command-contracts).
   Check: `Test-Plans` clean.

## Report

As report-fixed: the decisions taken, the ones left open, and the chunks unblocked.
