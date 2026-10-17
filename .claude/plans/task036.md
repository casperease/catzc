---
task:
  id: "036"
  status: open
  plans: [value-of-plan, plan-clear-actions, plan-master]
  value: highest
  blocked_on: every earlier task that ticks a plan's last step
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: "353155951124"
    repo_status: clean
    path: ".claude/plans/task036.md"
    folder: plans
    name: task036
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task036: the closing sweep

ADR-REPO-PLANS#5 (task010): a plan with no open step is deleted and value-of-plan.md keeps one "deleted, why" line. This task runs after any
batch of tasks lands, as often as needed, and last of all. `git rm` is the user's; the sweep lists.

## Steps

1. `grep -c '\- \[ \]' .claude/plans/plan-*.md`: every plan at zero is a delete candidate; read it once more for an open question or a
   "waits_on" that is not a checkbox (an open question keeps the plan). Check: a candidate list with one line per plan and its reason.
2. For each candidate: one "deleted, why" line in `value-of-plan.md` under "Deleted", its row removed from the value table, its
   `prompt-*-continue.md` companions listed with it. Check: Test-Links clean on value-of-plan.md.
3. `out/delete-done-plans.ps1`: the `git rm` lines, nothing else; the user runs it. Check: the files are gone.
4. `plan-master.md`: each pointer line whose task is complete is marked (done); when every chunk is done, the master itself has no open
   chunk and is deleted with the task files, leaving the plans folder with only live plans and value-of-plan.md. Check: Test-Plans and
   Test-Links clean on the folder.
5. `plan-clear-actions.md`: its last verdict lines ticked (the out/test-links report folders cleared with the user's yes). Check: grep
   `- [ ]` counts zero, then it is itself a candidate of step 1.

## Report

As report-fixed; the candidate list verbatim.
