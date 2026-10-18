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
- [x] `Invoke-TestRun.ps1` builds the type instead of the `pscustomobject`; every caller's reads unchanged (check: `Invoke-TestRun`'s and
      `Test-Automation`'s test files pass under Invoke-TestFile; no `Test-Automation` over the tree). Decided 2026-10-18 by the
      orchestrator (delegated; one shape, one living version): `ExcludedTests` is always present, empty without `-OptOutTag`, so
      `Invoke-TestRun.Tests.ps1:259` asserts a count of 0 instead of an absent property. `Test-CatzcBuild` keeps adding its `Build` note
      property to the typed result. Landed by catzc-b4: "[Invoke-TestFile] Passed Invoke-TestRun.Tests (out/test-file/20261018-194450-67fe89),
      Test-Automation.Tests (20261018-194507-29b7b2), Test-CatzcBuild.Tests (20261018-194540-89bb70)".
- [x] `IsolationRunResult` for `Test-InIsolation`, the same way (check: its test file passes). Landed 2026-10-18 by catzc-b4:
      `pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs` (`Success` is `Failed == 0`; `Failed` is unbounded, since a Process run with
      no results file counts the child's exit code); "[Invoke-TestFile] Passed IsolationRunResult.Tests
      (out/test-file/20261018-194620-8d6ec4), Test-InIsolation.Tests (20261018-194633-74ecad)".
- [x] The three runners' command contracts, if the grammar states them (check: Test-Contracts clean; the lookup regenerated). Landed
      2026-10-18 by catzc-b4: `Test-Automation`, `Test-CatzcBuild` and `Test-InIsolation` in
      `contracts/catzc/0.0.0/Catzc.Base.QualityGates/` (Test-InIsolation with its two sets), and `Test-Automation` and `Test-CatzcBuild`
      declare `[OutputType([Catzc.Base.Reports.TestRunResult])]`; "Test-Contracts: No contracts issues found; importer-commands.sh and
      docs/references/contracts regenerated; [Invoke-TestFile] Passed Get-ContractCheckResults.Assets.Tests
      (out/test-file/20261018-194715-67a147), New-CatsCommandLookup.Tests (20261018-194825-cffd19); Test-GeneratedFiles (Build-ContractReference,
      Build-RootConfig): No generated-files issues found".
- [x] Delete this plan (check: no file in .claude/plans names it). Listed 2026-10-18 by catzc-b4: no other file in .claude/plans or docs
      names it; its `git rm` line is in `out/delete-done-plans.ps1`, the user's run.
