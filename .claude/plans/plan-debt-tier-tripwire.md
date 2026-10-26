---
plan:
  status: active
  value: high
  reviewed: 2026-10-23
  class: debt
  targets:
    [pwsh/.internal/assets, pwsh/Base.Languages/Format-GeneratedFileHead.ps1, pwsh/Base.QualityGates/private/Get-GitAttributeValue.ps1]
---

# Debt tier tripwire: L0 and L1 tests that launch git, invisible to every run but a tier-filtered one

catzc-5d ran L0 and L1 alone on 2026-10-23 and found 165 failures (`out/catzc-5d-tier-triage.md`, reports
`out/test-automation/20261023-131510` and `-131723`). `Invoke-TestRun.ps1:156-161` arms the real-process tripwire only when `-MaxLevel` is
below 2, so a default run, `Invoke-TestFile` and every single-file run never arm it, and a real `git` launch in an L0 or L1 test is caught
only by a tier-filtered run (ADR-AUTO-TEST-PROCESSTRIPWIRE). The cause is in the tests and their seams, not in the filtered run.

## Decided (the orchestrator as delegated, 2026-10-23)

- A git call an L0 or L1 test reaches goes through a seam the test mocks, so the fast tiers stay fast; a test whose point is the real
  process moves to L2 with its tool self-skip. Mocking is the default; re-tiering is for a test that proves the launch itself.
- The tripwire must catch a violation in every run, not only a filtered one: it is armed per test container by the tier its outermost
  Describe carries, not once per run.

## Open steps

1. [ ] `ConvertTo-NormalName.Tests.ps1` stays red in every run until the user stages the case-only renames (VSCode to VsCode, PS to Ps;
       task-user-runs-and-commits item 18): git still tracks the old spelling while the disk holds the new one. The other four non-launch
       failures landed (catzc-6b, 2026-10-23). Check: `Invoke-TestFile` on it green after the staging.

Landed 2026-10-23 (catzc-46): the per-Describe tripwire. L0 alone 7094 passed, 0 failed; L1 alone 667 passed, 1 failed (the rename of step
1); a default run of QualityGates, Contracts and Execution with no tripwire hit.
