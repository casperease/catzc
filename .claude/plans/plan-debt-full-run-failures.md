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

- [ ] `Get-DynamicManifestContent.Tests.ps1`, still red on 2026-10-22 (`Facts['Modules']` is 0, `out/test-file/20261022-031430-d26183`): the
      cause (catzc-54, `out/catzc-54-full-run-2-5.md`) is a case-only rename git does not track, `pwsh/Catzc.Base.VSCode/*-VsCode*.ps1` on
      disk against `*-VSCode*.ps1` in the index, so the builder's case-sensitive index check drops every file and builds nothing. The fix is
      the user's (task-user-runs-and-commits). Check: `Invoke-TestFile` on it alone, after the rename is staged.
- [ ] `Build-AgentHook.Tests.ps1` red twice on 2026-10-22 inside catzc-a0's bursts, a different hook's `BeforeAll` each time
      (`Assert-BashTimeout`, then `Record-AgentWrite`), with no error text; `Invoke-TestFile` now prints a failed `BeforeAll`'s error, and
      the file ran green three times alone (catzc-27, 2026-10-23, `out/test-file/20261023-092121-2054e4` and the two after it). Left: the
      same three runs through `Invoke-CatzcCommand`, and the fix decided from the real error if one turns red; the run lock now serialises
      every import, so "while another session imports" is no longer a state a run can meet (decided by the orchestrator as delegated,
      2026-10-23). The real error (catzc-27, 2026-10-23, `out/test-file/20261023-093629-59a2f1`, one red in three): `dotnet publish` exits 0
      while a child it started holds its output open past 5 s; one child is NuGet's credential plugin, started because the implicit restore
      reads the user-level NuGet sources (a private feed among them); a second is not yet named. Nothing may contact a package manager
      outside the tooling system, and the config that makes the hook build offline (sources cleared, audit off) is a generated file (the
      user, 2026-10-23); `--source nuget.org` was tried and reverted. The design (generator, place, scope that keeps `dotnet tool restore`
      working) is reported to the orchestrator before any edit. (check: `Invoke-TestFile` on `Build-AgentHook.Tests.ps1` green three times
      in a row)
