---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [pwsh/Catzc.Base.Timeouts, pwsh/.internal/Catzc.Internal.Importer.psm1, pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1]
---

# Watch-Blocking: a watchpoint for a suspected block

`Watch-Blocking` stands behind the `-DiagnoseBlocking` switch of `importer.ps1`, `Test-Automation` and `Invoke-TestRun`
(ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND, ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH). One proof is left: the test-automation suite green with
the switch in place.

## Why its value is medium

A hang shows nothing about where it stopped (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT); the watchpoint finds the place so a limit can be put there.
Its lasting value is the limits it leads to, so the last step only proves the switch leaves `Test-Automation` sound.

## Open steps

- [x] Done 2026-10-18 (catzc-b4: a `neutral_codes.exempt` entry for the file in source-conventions.yml): "Invoke-TestFile
      Test-Automation.Tests.ps1: Passed (out/test-file/20261018-193451-b6ff7c)". Run
      `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` green. Its one failing check is the source-conventions check, whose six
      findings are L0 fixture lines in `pwsh/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1` (147, 177-180, 197) that use real
      `ADR-REPO-ADRCODE-*` codes; each takes a neutral widget code (ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES) (check: the file passes under
      `Invoke-TestFile`).

## Refs

- docs/adr/automation/fail-fast-with-asserts.md (ADR-AUTO-FAILFAST-WATCHPOINTTHENBOUND, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT)
- docs/adr/pwsh/assert-idioms.md (ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH)
