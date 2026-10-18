---
task:
  status: open
  plans: [plan-assert-wait]
  value: medium
  blocked_on: step 1 waits on the user's git mv of FileKindReachability.Tests (task-user-runs-and-commits step 2)
  targets: [pwsh/Catzc.Base.Globs/tests]
---

# Task: Assert-Wait, the last suite check

`Watch-Blocking`, its config read, the measured run and the ADR pair are in the tree. One check is left: `Test-Automation.Tests.ps1`
fails its source-conventions case on one finding, the file name `Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1`, whose rename to
`Test-FileKindReachability.Tests.ps1` is a `git mv`, the user's.

## Steps

1. After the user's `git mv`: run `Test-Automation.Tests.ps1` under `Invoke-TestFile`, then tick the plan's last step; the plan is deleted
   in task-closing-sweep. Check: the file passes; grep `- [ ]` counts zero in plan-assert-wait.

## Report

As report-fixed.
