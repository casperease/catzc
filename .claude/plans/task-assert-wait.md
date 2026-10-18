---
task:
  status: open
  plans: [plan-assert-wait]
  value: medium
  blocked_on: step 1 is reported, unverified; catzc-bc runs its check
  targets: [pwsh/Catzc.Base.Globs/tests]
---

# Task: Assert-Wait, the last suite check

`Watch-Blocking`, its config read, the measured run and the ADR pair are in the tree. The one source-conventions finding of
`Test-Automation.Tests.ps1`, the file name `FileKindReachability.Tests.ps1`, is renamed to `Test-FileKindReachability.Tests.ps1` (staged).

## Steps

1. Run `Test-Automation.Tests.ps1` under `Invoke-TestFile`, then tick the plan's last step; the plan is deleted in task-closing-sweep.
   Check: the file passes; grep `- [ ]` counts zero in plan-assert-wait. Reported, unverified: catzc-bc runs the check.

## Report

As report-fixed.
