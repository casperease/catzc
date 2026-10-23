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
- [ ] `Test-FileKindReachability.Tests.ps1`, red on 2026-10-22: `drawio-kit` is shadowed by `slides-kit` (12 of 35) and `test` (9 of 35), so
      `file-kinds.yml` lists both pairs in `overlaps` (landed; the shadow finding is gone); left red only on the kind `asset-description`,
      which matches no tracked file (see the open question; `out/test-file/20261022-031859-d4dd28`). Check: `Invoke-TestFile` on it alone.
- [ ] `Build-AgentHook.Tests.ps1` red twice on 2026-10-22 inside catzc-a0's bursts, a different hook's `BeforeAll` each time
      (`Assert-BashTimeout`, then `Record-AgentWrite`), with no error text; `Invoke-TestFile` now prints a failed `BeforeAll`'s error, and
      the file ran green three times alone (catzc-27, 2026-10-23, `out/test-file/20261023-092121-2054e4` and the two after it). Left: the
      same three runs, through `Invoke-CatzcCommand`, while another session imports, and the fix decided from the real error if one turns
      red. (check: `Build-AgentHook.Tests.ps1` green three times in a row while another session imports)
- [ ] The file kind `asset-description` in `file-kinds.yml` matches no tracked file, so it is retired (decided by the orchestrator as
      delegated, 2026-10-22): its meaning and context first go to a page under `docs/references` (a removed key is never dropped silently),
      then the kind leaves `file-kinds.yml` and every reader or test that names it, `ListenConfig.cs`'s docs tier included, in one burst
      with a fresh full import (decided by the orchestrator as delegated, 2026-10-23, catzc-27). (check:
      `Test-FileKindReachability.Tests.ps1` green, and `asset-description` found only on that page by grep)

- [ ] `pwsh/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1`: each untagged test's line names its test file, and the message names
      the valid categories `logic` and `integrity` (decided by the orchestrator as delegated, 2026-10-23: finding a test's file took a grep,
      and one test used `integration`). (check: `Assert-TestTagGate.Tests.ps1` green with a case asserting the file and the categories)
