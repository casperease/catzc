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
- `out/test-automation/durations.json` was dated 2026-10-30 until 2026-11-03 14:45: a killed run recorded no duration, so every new greedy
  file stayed unmeasured and the scheduler dealt the shards from stale weights (closed 2026-11-03: the workers save the finished shards'
  durations when the runner times out, and the apart chain is submitted first, `Select-GreedyFileOrder`).
- `pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1` took 268 s alone on 2026-11-03 against 2.8 s on 10-30: its per-file result cache
  (`out/cache/script-analyzer.json`, 2280 entries) is stamped on the settings and every rule file, so one rule edit cools it whole, and the
  cache is saved only after every shard finishes, so a run killed at its roof never warms it again. One solo run at 14:44 warmed it.

## Decided

- The roof stays at 360 s; each step below makes one file faster by the ADR-AUTO-TEST speed rules without losing a test or an assertion
  (`test-speed`), measured by `Invoke-TestFile -PassThru` and the file's suite time in the results XML.
- A killed run still records the durations of the shards that finished, so the next run schedules from fresh weights.

## Open steps

- [ ] `pwsh/Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1`: save each pass's result cache as every shard finishes, not once
      after all of them, so a run killed at its roof keeps the files the analyzer already found clean and the next run starts warm (check:
      `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1 -PassThru` passes with a new case whose
      second shard throws and whose first shard's files are in the saved cache).
- [ ] `pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1`: the eleven cases spawn a worker import each; the cases that only read a
      run's output share one run from `BeforeAll` (check:
      `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1     -PassThru` passes and the file's suite time in
      `results-shard-0.xml` reads under 60 s).
- [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1`: measured alone 2026-11-03, 193 s before and 145 s once the second consumer root
      installs the first root's build (`New-ConsumerRoot -Source`); ten fresh pwsh imports of about 4.5 s remain, so the two tool installs
      (9 s and 8 s) join the session import, the `Build-RootConfig` restore (7.6 s) runs inside the render child, and the consumer's
      `Test-Automation` (20 s) runs in the session import too (check:
      `Invoke-TestFile -Path pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1 -PassThru` passes with 29 tests and the suite time reads under
      120 s).
- [ ] `pwsh/Base.Exporter/Build-Modules.ps1`: measured 2026-11-03 per bundle, full 35 s, azure 26 s, tooling 15 s, base 12 s, minimal 3 s,
      each repeating the closure proof, the types DLL copy and the copy of 750 to 920 files; the bundles built in one session share the
      closure proof and the DLL copy where their selections agree, so `pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1` (222 s
      alone before, 107 s once its five loads overlap the builds on thread jobs) drops under its target (check:
      `Invoke-TestFile -Path pwsh/Base.Exporter/tests/Build-Modules.Tests.ps1 -PassThru` passes, and
      `Invoke-TestFile -Path pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1 -PassThru` passes with 15 tests and a suite time under
      90 s).
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
