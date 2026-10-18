---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  blocked_on: the user's git mv of FileKindReachability.Tests (task-user-runs-and-commits step 2), the one open step
  targets: [pwsh/Catzc.Base.Timeouts, pwsh/.internal/Catzc.Internal.Importer.psm1, pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1]
---

# Watch-Blocking: a watchpoint for a suspected block

`Watch-Blocking` stands behind the `-DiagnoseBlocking` switch of `importer.ps1`, `Test-Automation` and `Invoke-TestRun`
(ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND, ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH). One proof is left: the test-automation suite green
with the switch in place.

## Why its value is medium

A hang shows nothing about where it stopped (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT); the watchpoint finds the place so a limit can be put
there. Its lasting value is the limits it leads to, so the last step only proves the switch leaves `Test-Automation` sound.

## Open steps

- [ ] Run `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` green. Its one failing check is the source-conventions check,
      whose only finding is the file name `Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1`; the `git mv` to
      `Test-FileKindReachability.Tests.ps1` is the user's (check: the file passes under `Invoke-TestFile` after that move).

## Refs

- docs/adr/automation/fail-fast-with-asserts.md (ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT)
- docs/adr/pwsh/assert-idioms.md (ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH)
