---
task:
  status: open
  plans: [plan-module-model-closeout]
  value: high
  blocked_on: step 1 is the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.Modules, docs/adr/automation/module-model.md]
---

# Task: module model close-out

The model, its decisions D01 to D05 and rule 6's enforcement (checks and tests resolved through `languages.yml`) are in the tree. Two
real-repo failures an agent reported wait on the final full run.

## Steps

1. The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; this task runs nothing larger
   than one test file) reads the drawio.yml live-yaml test and RootConfig New-GitAttributes failures. Check: that run's report lists
   neither; recorded in the plan.
2. `plan-module-model-closeout.md`: tick each step; when all are ticked and the decisions are in ADR-AUTO-MODULE, the plan is deleted in
   task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
