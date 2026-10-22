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
       test case (catzc-e3's finding: an indented block slipped past it). All seven files and every module are done, each module green under
       `Test-Formatting -Path` (2026-10-22); left: the whole test file. Check: `Invoke-TestFile` on `Test-Formatting.Tests.ps1` alone.
2. [ ] `Get-DynamicManifestContent.Tests.ps1`, still red on 2026-10-22 (`Facts['Modules']` is 0, `out/test-file/20261022-031430-d26183`): a
       count of 0 means `Build-Modules` threw or built nothing, and the test asserts the count before it shows the build issues; next is
       `Test-BuildArtifact -Facet Manifest -PassThru` alone to read them. Check: `Invoke-TestFile` on it alone.
3. [ ] `Test-FileKindReachability.Tests.ps1`, red on 2026-10-22: `drawio-kit` is shadowed by `slides-kit` (12 of 35) and `test` (9 of 35),
       so `file-kinds.yml` lists both pairs in `overlaps` (landed; the shadow finding is gone); left red only on the kind
       `asset-description`, which matches no tracked file (see the open question; `out/test-file/20261022-031859-d4dd28`). Check:
       `Invoke-TestFile` on it alone.
4. [ ] `ManualTestPlan-Coverage.Tests.ps1`, red on 2026-10-22 on one new integrity block with no manual-test-plan row
       (`ValidatePathGivenAttribute.Tests.ps1`), now row 36 in `repository-conventions.md` (landed); left: `Build-DrsIndex.Tests.ps1`'s block
       "generated ADR index" still has its row under "generated DRS index" (`adr-registry.md` line 11), so that cell is renamed to match
       (details `out/catzc-e3-full-run-4.md`). Check: `Invoke-TestFile` on it alone.
5. [ ] `Test-Glossary.Tests.ps1` (4 findings that day; `Test-Glossary` reports 0 today). Check: `Invoke-TestFile` on it alone.

## Open questions

- From catzc-e3's rerun (2026-10-22): the file kind `asset-description` in `file-kinds.yml` matches no tracked file. Retire it (its page
  first, since a removed key is never dropped silently), or keep it for files still to come? Recommendation: retire it, with its page.
