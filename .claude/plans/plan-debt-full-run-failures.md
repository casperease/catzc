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
      the user's (task-user-runs-and-commits). The same rename keeps `Test-CatzcBuild.Parity.Tests.ps1` red (Catzc.Base.Asserts exports
      `Assert-IsRunningInVsCode` while the build lists VSCode), now that the bundle types-hash defect is fixed (catzc-46, 2026-10-23).
      Check: `Invoke-TestFile` on both alone, after the rename is staged.
- [ ] The pytest cache and the Python bytecode cache moved to `out/pytest-cache` and `out/pycache` (2026-10-25), and the `.pytest_cache` and
      `__pycache__` exceptions left `globs.yml`, `generated.yml`, `folder-walk.yml`, `gitignore.yml`, `vscode-settings.yml` and
      `terminology.yml`. Only `Invoke-PythonTest` and `Get-PythonTestCases` were run; the shared configs were not. Check: `Build-RootConfig`
      regenerates `.gitignore` and `.vscode/settings.json` without drift, then `Invoke-TestFile` on `Get-ModuleGlobSet.Tests.ps1`,
      `New-VsCodeSettings.Tests.ps1`, `Test-Terminology` and `Test-Markdownlint` alone, globs first.
