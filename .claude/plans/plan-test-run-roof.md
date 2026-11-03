---
plan:
  status: active
  value: high
  reviewed: 2026-11-03
  class: feature
  targets:
    [
      pwsh/Base.QualityGates,
      pwsh/Base.Overlay/tests,
      pwsh/Base.Exporter/tests,
      pwsh/.internal/tests,
      pwsh/Base.Languages/tests,
      pwsh/Base.VSCode/tests,
      pwsh/Azure.Templates/tests,
    ]
---

# The full test run within its roof

`Test-Automation -Level 2` has a 360 s roof (`TimeLimit` on the command, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT), and the roof is never raised: a
run past it means the tests get faster (the user, 2026-10-28; `test-speed`). On 2026-10-30 the full run ended in 190 s; on 2026-11-03 three
runs in a row were killed at the roof with 19 to 31 greedy shards unfinished. Measured from the run folders (`rows-shard-*.json`, the shard
scripts and the results' start stamps), 2026-11-03 13:01 against 2026-10-30 13:02:

- The phase before the first shard starts grew from 47 s to 91 s (the bicep prewarm and the discovery pass run there).
- Every parallel shard grew from 115-145 s to 212-272 s of suite time, while files that spawn nothing (`Wait-CatzcRunLock`,
  `Invoke-CatzcCommand`) kept their 17 s, so the growth is in the files, not the machine.
- The greedy queue holds 45 files behind 6 slots; 26 finished, the rest never started or were killed.
- Files that grew (suite seconds, 10-30 to 11-03): `Invoke-TestFile.Tests` 87 to 146, `Test-Spelling.Tests` 20 to 60,
  `New-TestAutomationShardScript.Tests` 25 to 55, `Get-DynamicManifestContent.Tests` 20 to 51, `Test-Formatting.Tests` 20 to 45,
  `Get-FileLanguage.Tests` 13 to 40, `TrackLamps.Tests` 62 to 100, `Export-Catzc.Install.Tests` 54 to 110, `Import-Catzc.Tests` 42 to 147
  (63 + 27 once the build probe stopped running the consumer writers, 2026-11-03).
- New greedy files since 10-30: `Consumer.L2.Tests`, `Build-Modules.Languages.Tests` (87 s), `Build-Modules.Bundles.Tests` (killed before it
  finished in every run).
- `out/test-automation/durations.json` is dated 2026-10-30: a killed run records no duration, so every new greedy file stays unmeasured and
  the scheduler deals the shards from stale weights.

## Decided

- The roof stays at 360 s; each step below makes one file faster by the ADR-AUTO-TEST speed rules without losing a test or an assertion
  (`test-speed`), measured by `Invoke-TestFile -PassThru` and the file's suite time in the results XML.
- A killed run still records the durations of the shards that finished, so the next run schedules from fresh weights.

## Open steps

- [ ] `pwsh/Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1`: when `Wait-PesterRunner` throws its timeout, save the finished
      shards' durations (`Save-TestShardDurations`, as the happy path does after the wait) before the throw travels on, so a killed run
      leaves fresh weights (check: `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Invoke-TestRun.Tests.ps1 -PassThru` passes with a new
      case whose runner times out and whose finished shard's file is in the written `durations.json`).
- [ ] `pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1`: the eleven cases spawn a worker import each; the cases that only read a
      run's output share one run from `BeforeAll` (check:
      `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1     -PassThru` passes and the file's suite time in
      `results-shard-0.xml` reads under 60 s).
- [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1`: measure the file alone; the `BeforeAll` installs the python workspace and the
      TypeScript declarations on every run, so a cached install under `out/` or one shared fixture cuts it (check:
      `Invoke-TestFile -Path     pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1 -PassThru` passes and the suite time reads under 120 s).
- [ ] `pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1`: measure the file alone; it builds and loads every declared bundle, so the
      bundles share the one types DLL and one closure proof (check:
      `Invoke-TestFile -Path     pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1 -PassThru` passes and the suite time reads under
      120 s).
- [ ] `pwsh/Base.Exporter/tests/Export-Catzc.Install.Tests.ps1`: one export per `Describe` instead of one per case (check:
      `Invoke-TestFile     -Path pwsh/Base.Exporter/tests/Export-Catzc.Install.Tests.ps1 -PassThru` passes and the suite time reads under 60
      s).
- [ ] `pwsh/Base.QualityGates/tests/Test-Spelling.Tests.ps1`: the cases that spell the real tree share one gate run (check:
      `Invoke-TestFile     -Path pwsh/Base.QualityGates/tests/Test-Spelling.Tests.ps1 -PassThru` passes and the suite time reads under 25
      s).
- [ ] `pwsh/Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1`: the shard scripts the cases render are rendered once per
      `Describe` (check: `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1 -PassThru` passes and
      the suite time reads under 30 s).
- [ ] `pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1`: the formatter-stability cases format one built manifest set (check:
      `Invoke-TestFile -Path pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1 -PassThru` passes and the suite time reads under 25
      s).
- [ ] `pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1`: the real-tree case runs the gate once and the other cases assert on fixtures
      (check: `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1 -PassThru` passes and the suite time reads under
      25 s).
- [ ] `pwsh/Base.Languages/tests/Get-FileLanguage.Tests.ps1`: the ten cases tripled since 10-30; the registry read moves to `BeforeAll`
      (check: `Invoke-TestFile -Path pwsh/Base.Languages/tests/Get-FileLanguage.Tests.ps1 -PassThru` passes and the suite time reads under
      15 s).
- [ ] `pwsh/Base.VSCode/tests/TrackLamps.Tests.ps1`: the seven end-to-end cases share one extension build (check:
      `Invoke-TestFile -Path     pwsh/Base.VSCode/tests/TrackLamps.Tests.ps1 -PassThru` passes and the suite time reads under 60 s).
- [ ] `pwsh/Azure.Templates/tests/BicepBuildCache.Prewarm.ps1`: measure the phase before the first shard; the prewarm builds only the
      templates the run's bicep tests read, from the build cache when it is warm (check: in the next full run's folder, the first
      `results-shard-*.xml` start stamp is within 50 s of the folder's stamp).

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-FAILFAST
  ([fail-fast-with-asserts](../../docs/drs/automation/fail-fast-with-asserts.md)), the `test-speed` skill.
- The measurements: `out/test-automation/20261103-130114` against `out/test-automation/20261030-130223`, summed from their
  `rows-shard-*.json` and read from each shard's results start stamp.
