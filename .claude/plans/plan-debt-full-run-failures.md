---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/tests, pwsh/Catzc.Base.Globs/tests, pwsh/.internal/tests]
---

# Debt full-run failures: the failing files of the last full run, rerun one at a time

The last full run (`out/test-automation/20261021-032407`) failed 338 tests in 15 files. Seven were fixed or found stale and proven on
2026-10-22 (`Test-ScriptAnalyzer`, `Test-Spelling`, `Test-Automation`, `Test-PythonLint`, `Test-PythonTypes`, `Format-FileMeta.Contract`,
`Test-Links.Repository` green alone). The rest are listed here, each rerun alone, one heavy run at a time on the machine (memory ran short
on 2026-10-22 with five sessions running tests). A red file has its cause reported before its fix; a file touching a shared config
(`globs.yml`, the manual test plan) is always reported first. The kit's whole L2 folder (321 tests, a parent setup fall under its old name
`python/Catzc.Diagrams`) is left to the user's full run: the kit was renamed after that run, and its live pytest run passes 149.

## Open steps

1. [ ] `Test-Formatting.Tests.ps1`, red on 2026-10-22 with 54 findings (catzc-e9, `out/test-file/20261022-021951-043abe`): (a) seven files
       changed today and not formatted (`Get-GlossarySourceViolations.Tests.ps1`, `GlossaryConfig.Tests.ps1`,
       `Get-RelativeEdgesFileMetaFact.ps1` and its test, `file-meta.yml` under a HOLD since every import reads it, and two plan files); (b)
       47 function helps that need a hand edit: 38 functions with no comment page, 6 pages with no `## help` section, 2 parameters with no
       `###` subsection (`CarrierMap`, `Pages`), 1 help line that is only a citation. Each is written from its code, one module at a time
       (Maps, Contracts, Slides, Azure.Templates, QualityGates, Docs, TypesSystem, CodeMeta, Flow, Languages, ModuleSystem, Objects, then
       Tooling.Listen), `Test-Formatting -Path` on the module after each. An inline help block left in a `.ps1` is removed once its page
       holds the help (ADR-REPO-HELP-HELPONCOMMENTPAGE), and `Get-HelpPageFinding`'s legacy-help check also matches indented help, with a
       test case (catzc-e3's finding: an indented block slipped past it). Check: `Invoke-TestFile` on `Test-Formatting.Tests.ps1` alone.
2. [ ] `Get-DynamicManifestContent.Tests.ps1` (`Facts['Modules']` was 0). Check: `Invoke-TestFile` on it alone.
3. [ ] `Test-FileKindReachability.Tests.ps1` (`slides-kit` and `test` overlapping `drawio-kit` in `globs.yml`, a shared file). Check:
       `Invoke-TestFile` on it alone.
4. [ ] `ManualTestPlan-Coverage.Tests.ps1` (integrity tests with no manual-test-plan row, a shared file). Check: `Invoke-TestFile` on it
       alone.
5. [ ] `Test-Glossary.Tests.ps1` (4 findings that day; `Test-Glossary` reports 0 today). Check: `Invoke-TestFile` on it alone.
