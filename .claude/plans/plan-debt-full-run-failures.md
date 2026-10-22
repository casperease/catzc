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
       `Test-Formatting -Path` (2026-10-22). The whole file was left red on 2 findings (catzc-a0): `Invoke-CatzcCommand.ps1` not formatted
       after the run-lock change (`Format-Code -Path` on it, when catzc-e9 has finished with it), and the `Start-ClaudeWorker` page
       documenting `[string]` (fixed to `[string[]]` by the orchestrator). `Invoke-CatzcCommand.ps1` is formatted (catzc-e9, "0 of 1 file(s)
       changed"); the rerun is red on 27 committed files with stale heads from the commits since 03:00 without a re-imprint (the plan-counts
       imprint step, `out/test-file/20261022-033238-28ca2c`), re-imprinted by `Format-Code -Path` on those files in one burst (catzc-e9; the
       re-imprint is rule-required, decided by the orchestrator as delegated). Rerun at 03:41 (`out/test-file/20261022-034119-6dd7fc`): 0
       stale files left, 4 live edits of working sessions only; the rerun that closes the step runs in a quiet window, after the plan-counts
       imprint fix (plan-debt-agent-traffic), since that step leaves the master and the value file unformatted after any plan edit. Check: `Invoke-TestFile` on `Test-Formatting.Tests.ps1`
       alone.
2. [ ] `Get-DynamicManifestContent.Tests.ps1`, still red on 2026-10-22 (`Facts['Modules']` is 0, `out/test-file/20261022-031430-d26183`):
       the cause (catzc-54, `out/catzc-54-full-run-2-5.md`) is a case-only rename git does not track, `pwsh/Catzc.Base.VSCode/*-VsCode*.ps1`
       on disk against `*-VSCode*.ps1` in the index, so the builder's case-sensitive index check drops every file and builds nothing. The
       fix is the user's (task-user-runs-and-commits). Check: `Invoke-TestFile` on it alone, after the rename is staged.
3. [ ] `Test-FileKindReachability.Tests.ps1`, red on 2026-10-22: `drawio-kit` is shadowed by `slides-kit` (12 of 35) and `test` (9 of 35),
       so `file-kinds.yml` lists both pairs in `overlaps` (landed; the shadow finding is gone); left red only on the kind
       `asset-description`, which matches no tracked file (see the open question; `out/test-file/20261022-031859-d4dd28`). Check:
       `Invoke-TestFile` on it alone.

## Open questions

- From catzc-e3's rerun (2026-10-22): the file kind `asset-description` in `file-kinds.yml` matches no tracked file. Retire it (its page
  first, since a removed key is never dropped silently), or keep it for files still to come? Recommendation: retire it, with its page.
