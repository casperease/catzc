---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/tests, pwsh/Catzc.Base.Build/tests, python/catzc_diagrams/tests]
---

# Debt full-run failures: the failing files of the last full run, rerun one at a time

The last full run (`out/test-automation/20261021-032407`) failed 338 tests in 15 files. Three were fixed and proven on 2026-10-22
(`Test-ScriptAnalyzer`, `Test-Spelling`, `Test-Automation` green alone). The rest are listed here, each rerun alone, one heavy run at a time on
the machine (memory ran short on 2026-10-22 with five sessions running tests). A red file has its cause reported before its fix; a file
touching a shared config (`globs.yml`, the manual test plan) is always reported first. The kit's whole L2 folder (321 tests, a parent setup
fall under its old name `python/Catzc.Diagrams`) is left to the user's full run: the kit was renamed after that run, and its live pytest run
passes 149.

## Open steps

1. [ ] `Test-PythonLint.Tests.ps1` (RUF100 at `test_minimap_contract.py:16`, a line that changed since). Check: `Invoke-TestFile` on it alone.
2. [ ] `Test-PythonTypes.Tests.ps1` (reportOptionalMemberAccess at `test_declaration.py:861`, a line that changed since). Check:
       `Invoke-TestFile` on it alone.
3. [ ] `Format-FileMeta.Contract.Tests.ps1` (edge keys `docs` against `page`). Check: `Invoke-TestFile` on it alone.
4. [ ] `Test-Links.Repository.Tests.ps1` (the committed tree not formatter-stable). Check: `Invoke-TestFile` on it alone.
5. [ ] `Test-Formatting.Tests.ps1` (a function help needing a `## help` section on its comment page). Check: `Invoke-TestFile` on it alone.
6. [ ] `Get-DynamicManifestContent.Tests.ps1` (`Facts['Modules']` was 0). Check: `Invoke-TestFile` on it alone.
7. [ ] `Test-FileKindReachability.Tests.ps1` (`slides-kit` and `test` overlapping `drawio-kit` in `globs.yml`, a shared file). Check:
       `Invoke-TestFile` on it alone.
8. [ ] `ManualTestPlan-Coverage.Tests.ps1` (integrity tests with no manual-test-plan row, a shared file). Check: `Invoke-TestFile` on it alone.
9. [ ] `Test-Glossary.Tests.ps1` (4 findings that day; `Test-Glossary` reports 0 today). Check: `Invoke-TestFile` on it alone.
