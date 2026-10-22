---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      pwsh/Catzc.Base.QualityGates/tests,
      pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1,
      pwsh/Catzc.Base.Globs/tests/Test-FileKindReachability.Tests.ps1,
      pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1,
    ]
---

# Debt red run: the failing test files of the last full run, rerun one at a time

The full run `out/test-automation/20261021-032407` failed 338 tests in 15 files. The orchestrator owns the order and the memory queue: one
file per queue turn, each rerun alone with `Invoke-TestFile -PassThru` in its own background call. A red file reports its cause and the
proposed fix before any edit. Groups A and B (the `python/Catzc.Diagrams/tests` folder, `Test-PythonLint`, `Test-PythonTypes`) belong to
another session's chunk and are not here.

## Open steps

1. [ ] Group C, head and help drift: rerun `Format-FileMeta.Contract.Tests.ps1` (the run expected the edge `docs` and found `page`;
       `file-meta.yml` names `docs` today), `Test-Links.Repository.Tests.ps1` (files the formatter changed), and `Test-Formatting.Tests.ps1`
       (comment pages without `## help`). Check: each green alone, or its cause reported.
2. [ ] Group E: rerun `pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1` (Facts['Modules'] was 0). Check: green alone, or its
       cause reported.
3. [ ] Group D, shared configs, always reported before an edit: rerun `Test-FileKindReachability.Tests.ps1` (`slides-kit` and `drawio-kit`
       overlap in `globs.yml`), `ManualTestPlan-Coverage.Tests.ps1` (missing manual-test-plan rows), and `Test-Glossary.Tests.ps1`
       (4 findings, one the G6 "contracts gate" in `docs/how-to/pwsh/add-a-command-contract.md:44`). Check: each green alone, or its cause
       and the shared-file entry reported.
