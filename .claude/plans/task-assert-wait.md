---
task:
  status: open
  plans: [plan-assert-wait]
  value: medium
  blocked_on: nothing; step 1 landed, the plan's tick is catzc-bc's
  targets: [pwsh/Catzc.Base.Globs/tests]
---

# Task: Assert-Wait, the last suite check

`Watch-Blocking`, its config read, the measured run and the ADR pair are in the tree. The one source-conventions finding of
`Test-Automation.Tests.ps1`, the file name `FileKindReachability.Tests.ps1`, is renamed to `Test-FileKindReachability.Tests.ps1` (staged).

## Steps

1. [x] Run `Test-Automation.Tests.ps1` under `Invoke-TestFile`, then tick the plan's last step; the plan is deleted in
       task-closing-sweep. Check: the file passes; grep `- [ ]` counts zero in plan-assert-wait. "Invoke-TestFile Test-Automation.Tests.ps1:
       Passed (out/test-file/20261018-193451-b6ff7c)", after the Test-AdrRegistry.Tests neutral_codes exemption (SourceConventionsConfig.Tests
       Passed, out/test-file/20261018-193446-27d0f5). The plan's tick is catzc-bc's.

## Report

As report-fixed.
