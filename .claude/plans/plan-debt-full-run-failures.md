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

- [ ] `Get-DynamicManifestContent.Tests.ps1`, still red on 2026-10-22 (`Facts['Modules']` is 0, `out/test-file/20261022-031430-d26183`):
       the cause (catzc-54, `out/catzc-54-full-run-2-5.md`) is a case-only rename git does not track, `pwsh/Catzc.Base.VSCode/*-VsCode*.ps1`
       on disk against `*-VSCode*.ps1` in the index, so the builder's case-sensitive index check drops every file and builds nothing. The
       fix is the user's (task-user-runs-and-commits). Check: `Invoke-TestFile` on it alone, after the rename is staged.
- [ ] `Test-FileKindReachability.Tests.ps1`, red on 2026-10-22: `drawio-kit` is shadowed by `slides-kit` (12 of 35) and `test` (9 of 35),
       so `file-kinds.yml` lists both pairs in `overlaps` (landed; the shadow finding is gone); left red only on the kind
       `asset-description`, which matches no tracked file (see the open question; `out/test-file/20261022-031859-d4dd28`). Check:
       `Invoke-TestFile` on it alone.
- [ ] The repository-integrity test of `Test-Markdownlint.Tests.ps1`, red on 2026-10-22 with 14 issues (catzc-e9): MD011 in
      `.claude/learnings/learned5555ec.md` lines 58 and 59; MD013 over 140 in `docs/drs/principles/cats-and-catzc.md` line 79, a
      `dora-explains.md` line 3, and `docs/drs/principles/one-living-version.md` lines 49 and 201; MD033 inline `<topic>`, `<Class>`, `<id>` in
      `docs/references/pwsh/catzc-base-quality-gates/New-Plan.ps1.md` lines 10, 18, 25 and
      `docs/references/pwsh/catzc-tooling-listen/New-DocNote.ps1.md` line 10; the four MD029 numbered plan steps are fixed (unnumbered).
      Each file fixed one at a time, the words kept. Check: `Test-Markdownlint -Path` on each file at 0, then `Invoke-TestFile` on
      `Test-Markdownlint.Tests.ps1`.
- [ ] `pwsh/Catzc.Base.Drs/types/DrsCodeForm.cs`: the `ToString` override the shipped-types test requires, red in HEAD (catzc-54,
      2026-10-22, `out/catzc-54-test-speed-import-csharp-types.md`); a type edit is import-path work, so it lands in a burst. Check: the
      shipped-types test file green under `Invoke-TestFile`, and one fresh full import.

## Open questions

- From catzc-e3's rerun (2026-10-22): the file kind `asset-description` in `file-kinds.yml` matches no tracked file. Retire it (its page
  first, since a removed key is never dropped silently), or keep it for files still to come? Recommendation: retire it, with its page.
