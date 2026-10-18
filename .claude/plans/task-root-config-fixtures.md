---
task:
  status: open
  plans: [plan-fast-push-followups]
  value: medium
  blocked_on: step 1 is the user's by hand
  targets: [pwsh/Catzc.Base.Git/Push-Dirty.ps1]
---

# Task: the real Push-Dirty run

The root-config fixture tests pass and the PropertyHead docs name both carriers. The fast-push plan's last item is the user's.

## Steps

1. By hand, the user's: a keybinding for the "Push dirty" task (`workbench.action.tasks.runTask`, args `Push dirty`) in the user
   keybindings; one real `Push-Dirty` run against the remote (the tests mock every git call). Check: the user reports the run.
2. Tick plan-fast-push-followups' last step; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
