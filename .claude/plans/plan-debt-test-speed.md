---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1]
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-optimization role ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s
summed). `Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left
out: `Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Open steps

- [ ] `Import-Catzc.Tests.ps1` (22.1 s), measured and fixed one cause at a time once it can pass: it waits on the VSCode case-only rename
      (plan-debt-full-run-failures, the `Get-DynamicManifestContent` step, the user's), its full-build test failing in 2 to 3 s on
      "Catzc.Base.VSCode has no function files" (the reduced-build test alone is about 7 s). Check: `Invoke-TestFile` twice, the same test
      names and `Should` count, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [ ] The ten slowest test files, each measured alone and fixed one cause at a time, slowest first (ranked 2026-10-26 by catzc-2f from the
      2026-10-25 sharded run's `durations.json`, its top 16 re-timed alone; `Import-Catzc.Tests.ps1` and `Test-CatzcBuild.Parity.Tests.ps1`
      wait on the VSCode case-only rename, the step above): `Invoke-TestFile.Tests.ps1` (77.4 s), `Test-Spelling.Tests.ps1` (18.5 s, 1 test
      red before any change), `Test-Formatting.Tests.ps1` (17.6 s, 1 test red before any change), `Get-RepositoryFilter.Tests.ps1` (16.1 s)
      and `Test-Automation.Tests.ps1` (15.6 s). A red file is made green by its owner before its speed is touched, and a file measured with
      no safe gain is recorded as left as it is. Check: `Invoke-TestFile` twice per file, the same test names and `Should` count, an A/B of
      each cause with identical output, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Open questions

- Should `Build-Bicep` call the bicep binary directly instead of through `Invoke-AzCli`? Each az call pays about 1.7 s of Python start
  (measured by catzc-68, 2026-10-26: `az bicep version` 1.99 s, `bicep --version` 0.31 s), once per slot plus once for main. Recommendation:
  measure first, the start cost times the slots of a real build, before deciding.
- Should a janitor keep `out/` to a retention (old `test-file/`, `burst/` journals, drone scratch)? Every test that walks the disk pays for
  it: on 2026-10-26 the track lamps' walk held 51,471 files, 36,678 under `out/` (`test-file` 8,788, `drone27-pre` 6,089, `burst` 4,979,
  `test-generated-files` 2,670, `minimaps` 2,296, `slides` 1,748), measured by catzc-2b. Undecided.

## Decided

- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
