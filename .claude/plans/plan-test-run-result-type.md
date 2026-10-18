---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/.internal]
---

# Typed results for the test runners

Every gate returns a `QualityGateResult` and is contracted; the three test runners `Test-Automation`, `Test-CatzcBuild` and
`Test-InIsolation` still return an untyped `pscustomobject` (built in `Invoke-TestRun.ps1:212-227`). Decided by the orchestrator
2026-10-18 on the user's delegation (type-first): a C# `TestRunResult` type, and `IsolationRunResult` for `Test-InIsolation`, with no
grammar change. Source: `out/draft-contract-gate-results-and-sets.md`.

## Open steps

- [x] The `TestRunResult` C# type beside `QualityGateResult`, its properties exactly the keys `Invoke-TestRun.ps1:212-227` builds today
      (check: the type's L0 test passes in a fresh pwsh). Landed 2026-10-18 by catzc-b4: `pwsh/Catzc.Base.Reports/types/TestRunResult.cs`
      (TotalCount is the row count); "[Invoke-TestFile] Passed TestRunResult.Tests (out/test-file/20261018-194406-3c5a17)".
- [ ] `Invoke-TestRun.ps1` builds the type instead of the `pscustomobject`; every caller's reads unchanged (check: `Invoke-TestRun`'s and
      `Test-Automation`'s test files pass under Invoke-TestFile; no `Test-Automation` over the tree).
- [ ] `IsolationRunResult` for `Test-InIsolation`, the same way (check: its test file passes).
- [ ] The three runners' command contracts, if the grammar states them (check: Test-Contracts clean; the lookup regenerated).
- [ ] Delete this plan (check: no file in .claude/plans names it).
