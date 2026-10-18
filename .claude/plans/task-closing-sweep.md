---
task:
  status: open
  plans: [value-of-plan, plan-clear-actions, plan-master]
  value: highest
  blocked_on: every other task that ticks a plan's last step
  targets: [.claude/plans]
---

# Task: the closing sweep

ADR-REPO-PLANS-DONEPLANDELETED: a plan with no open step is deleted; git holds why. This task runs after any batch of tasks lands, as often
as needed, and last of all. `git rm` is the user's (the permission layer blocks it for sessions); the sweep lists.

## Steps

1. `grep -c '\- \[ \]' .claude/plans/plan-*.md`: every plan at zero is a delete candidate; read it once more for an open question or a
   "waits_on" that is not a checkbox (an open question keeps the plan). Check: a candidate list with one line per plan and its reason.
2. For each candidate: its row removed from the value table, and its `git rm` line (with its prompt and task companions) added to
   `out/delete-done-plans.ps1`. Check: Test-Links clean on value-of-plan.md.
3. `out/delete-done-plans.ps1`: the `git rm` lines, nothing else; the user runs it. Check: the files are gone.
   After the six questionnaire and decisions files are removed: `Build-Diagrams -Path` over each folder in
   `out/minimap-rebuild-after-rm.txt`, since their generated grid/tree/chain pages link to those files. Check: Test-Links over
   docs/explanation clean. Done 2026-10-18 by catzc-b4: "Build-Diagrams -Path all stages clean on all 25 folders, 0 W_ lines; grep of
   the six names under docs/ finds nothing; Test-Links on the 25 folders: No links issues found (out/test-links/20261018-201014)".
4. `plan-master.md`: each pointer line whose task is complete is marked (done); when every chunk is done, the master itself has no open
   chunk and is deleted with the task files, leaving the plans folder with only live plans and value-of-plan.md. Check: Test-Plans and
   Test-Links clean on the folder.
5. `plan-clear-actions.md`: its last verdict lines ticked (the out/test-links report folders cleared with the user's yes). Check: grep
   `- [ ]` counts zero, then it is itself a candidate of step 1.
6. The last sweep runs only after the final session's full run (task-user-runs-and-commits, last step), since the plans that close on green
   close on that run alone; it is the one place the whole repository is tested. Check: that run's report exists in `out/test-automation` and
   is newer than every task file.

## Report

As report-fixed; the candidate list verbatim.
