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
      wait on the VSCode case-only rename, the step above): `catzc-track-lamps.Tests.ps1` (102.4 s),
      `Get-BicepParameterModel.Shipped.Tests.ps1` (93.4 s), `Invoke-TestFile.Tests.ps1` (77.4 s), `Wait-CatzcRunLock.Tests.ps1` (30.6 s),
      `Build-Bicep.L2.Tests.ps1` (29.9 s), `Build-Bicep.Integrity.Tests.ps1` (22.9 s), `Test-Spelling.Tests.ps1` (18.5 s, 1 test red before
      any change), `Test-Formatting.Tests.ps1` (17.6 s, 1 test red before any change), `Get-RepositoryFilter.Tests.ps1` (16.1 s) and
      `Test-Automation.Tests.ps1` (15.6 s). A red file is made green by its owner before its speed is touched, and a file measured with no
      safe gain is recorded as left as it is. Check: `Invoke-TestFile` twice per file, the same test names and `Should` count, an A/B of
      each cause with identical output, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Decided

- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
