---
task:
  status: open
  plans: [plan-bounded-folder-enumeration]
  value: medium
  blocked_on: step 1 is the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.Folders, pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1, docs/adr/pwsh/bounded-enumeration.md]
---

# Task: bounded enumeration closed

Everything is built and migrated: Catzc.Base.Folders (FolderWalker, Get-ChildPath, depth 2 by default), the analyzer rule, ADR-PWSH-ENUM.
The level-2 gate and the feature's three test files pass. The plan is deleted on green.

## Steps

1. The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; nothing here runs it earlier).
   Check: that run's report shows no finding from this feature.
2. On green: `plan-bounded-folder-enumeration.md` and `prompt-bounded-folder-enumeration-continue.md` are deleted (their `git rm` lines in
   `out/delete-done-plans.ps1`, the user's run; the row leaves value-of-plan.md); `out/run-folders-tests.ps1` and `run-folders-verify.ps1`
   listed for the next probe batch. Check: both files gone; Test-Links clean on `.claude/plans`.

## Report

As report-fixed.
