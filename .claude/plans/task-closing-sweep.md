---
task:
  status: open
  plans: [value-of-plan, plan-master]
  value: highest
  blocked_on: every other task that ticks a plan's last step
  targets: [.claude/plans]
---

# Task: the closing sweep

ADR-REPO-PLANS-DONEPLANDELETED: a plan with no open step is deleted; git holds why. This task runs after any batch of tasks lands, as often
as needed, and last of all. The sweep deletes from disk; git is the user's.

## Steps

1. `grep -c '\- \[ \]' .claude/plans/plan-*.md`: every plan at zero is a delete candidate; read it once more for an open question or a
   "waits_on" that is not a checkbox (an open question keeps the plan). Check: a candidate list with one line per plan and its reason.
2. For each candidate: its row removed from the value table, then the file deleted from disk with its prompt and task companions (the user,
   2026-10-19: done plans are deleted directly; the user commits the deletion). Check: Test-Links clean on value-of-plan.md and over
   docs/explanation, since generated minimap pages may link a removed plan.
3. The user commits the deletions with the next commit. Check: `git status --short .claude/plans` shows no `D` line after it.
4. `plan-master.md`: each pointer line whose task is complete is marked (done); when every chunk is done, the master itself has no open
   chunk and is deleted with the task files, leaving the plans folder with only live plans and value-of-plan.md. Check: Test-Plans and
   Test-Links clean on the folder.
5. The last sweep runs only after a full run of `Test-Automation` newer than every task file (the user's, in a fresh session), since the
   plans that close on green close on that run alone. Check: that run's report exists in `out/test-automation` and is newer than every task
   file.

## Report

As catzc-core's report; the candidate list verbatim.
