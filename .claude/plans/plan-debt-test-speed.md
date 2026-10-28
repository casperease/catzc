---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh]
  blocked_on: task-user-runs-and-commits, the final full run, whose results the ranking reads
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-speed job ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s summed).
`Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left out:
`Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Ranking

The L0-L1 run `out/test-automation/20261027-081457` (snapshot, 1033 files, 568.7 s summed, 166.1 s wall on 12 shards) ranks the files; the
run `20261027-080753` (491.7 s summed, 140.3 s wall) agrees but for the two Bicep files, whose L1 tests failed there before compiling.

| File                                        | Seconds | Cause                                                                      |
| ------------------------------------------- | ------: | -------------------------------------------------------------------------- |
| `Test-BicepTemplateCompliance.Tests.ps1`    |    54.3 | one L1 test, 53.8 s: `Build-Bicep` runs one bicep process per slot in turn |
| `Get-ContractCheckResults.Assets.Tests.ps1` |    27.1 | left to catzc-e9                                                           |
| `Wait-CatzcRunLock.Tests.ps1`               |    17.6 | real lock waits in whole seconds: the waits are what it proves             |
| `catzc-track-lamps.Tests.ps1`               |    13.5 | four L1 walks of the real repository, 1.8-3.9 s each                       |
| `Foundation.PrePost.Tests.ps1`              |    13.3 | its L1 `BeforeAll` compiles foundation again (tests sum 117 ms)            |
| `Test-FileLimits.Tests.ps1`                 |    12.2 | one L1 pass over every tracked file, under its 30 s roof                   |
| `SourceConventionScan.Tests.ps1`            |    12.0 | one L1 test over every PowerShell file, 11.3 s                             |

## Open steps

- [x] Second sample (drone-opus, 2026-10-27): `Build-Bicep.SampleSubscription.Tests.ps1` alone (`out/test-file/20261027-161502-bbdc9b`) is
      8.05 s against 1.67 s, 6.4 s per worker, and two `Test-BicepTemplateCompliance` runs give 5.7 s and 5.9 s: about 6 s per worker start,
      import and Pester load. Measure what the shared import costs each test run a second time: a lone `Invoke-TestFile` run's `run.json`
      `durationSeconds` against its `files-shard-0.json` `DurationMs` is the worker's start, import and Pester load. The first sample,
      `Test-BicepTemplateCompliance` alone in place (`out/test-file/20261027-160116-0cf782`), is 52.4 s against 46.6 s: 5.8 s per worker, so
      about 70 s of the run's 12 workers. Check: a second lone run of one small file, its number recorded here.
- [x] Verdict (drone-opus, 2026-10-27): `Test-BicepTemplateCompliance.Tests.ps1` alone went from 44.5 s Pester / 50.6 s wall
      (`out/test-file/20261027-161103-a2a1b1`) to 17.3 s / 23.0 s and 18.3 s / 24.1 s (`20261027-161527-4fbfad`, `20261027-161754-83337d`),
      11 tests passing each; the `foundation` build is byte-identical to a serial compile (7 of 7 JSON files). `Build-Bicep` runs every
      slot's `bicep build-params` and the `main.bicep` build one after another, each a full compile of the template in its own bicep
      process; send them through `Invoke-ExecutableParallel` (`CliRunner.RunMany`, the throttle of `timeouts.yml` `parallel.processes`), as
      `Build-Bicep.Integrity.Tests.ps1` already compiles its slots side by side. It speeds every caller,
      `Test-BicepTemplateCompliance.Tests.ps1` (53.8 s) and `Foundation.PrePost.Tests.ps1` (13.3 s) first. The seven
      `Build-Bicep*.Tests.ps1` files mock `Invoke-Executable` for the build-params calls and move to a mock of `Invoke-ExecutableParallel`,
      and `private/Invoke-BicepParamsBuild.ps1` goes, its existence assert kept in `Build-Bicep`. Check: both files twice with
      `Invoke-TestFile`, the same test names and `Should` count, the compiled `main.json` and parameter files identical to a serial build,
      and `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [x] Verdict (drone-opus, 2026-10-27): `TrackLamps.Tests.ps1` went from 25.0 s / 23.3 s Pester (`out/test-file/20261027-163210-4b28be`,
      `20261027-163317-379c22`) to 18.4 s / 20.1 s (`20261027-163728-886a3d`, `20261027-163753-acf387`), 7 tests passing, the test file
      unchanged. Only two node processes walk the disk, once each (0.5 s over 31,000 files); the cost was each lamp state's `hiddenEntries`
      (205 ms) and census `entryClaimer` (150 ms), every file walking its folders up. The lever was product code in `js/track-lamps`: the
      walks up stop at a folder already added, and a folder's dead and claimed verdicts are kept per call. The census test went from
      11.7-12.8 s to 7.6-8.5 s and the roof test from 5.2-5.6 s to 3.8-4.1 s; the old and new engine agree on 60 real states and 256 toy
      trees, and the 39 node tests pass. The rest is one evaluate and one `hiddenEntries` per lamp state, the work the tests prove.
- [x] Verdict (drone-opus, 2026-10-27): `SourceConventionScan.Tests.ps1` went from 12.6 s / 13.2 s Pester
      (`out/test-file/20261027-163241-906b79`, `20261027-163346-89988c`) to 2.4 s / 2.2 s (`20261027-163552-dfac5c`,
      `20261027-163601-1d9516`), 3 tests passing, the same names and `Should` count. No parse was repeated (2163 files parsed in 0.2-0.3 s,
      the scan 0.03 s): the three `FindAll` predicates were script blocks called per node (4.2-5.5 s) and the extent keys a `ForEach-Object`
      pipeline per node (2.3-3.7 s). The predicates are compiled expression trees now and the lists compare by `SequenceEqual` on the nodes
      themselves, which holds every extent equal too.
- [x] Verdict (drone-opus, 2026-10-27): `Get-ContractCheckResults.Assets.Tests.ps1` went from 28.3 s / 26.9 s Pester
      (`out/test-file/20261027-192652-98b9be`, `20261027-192729-5c43a2`) to 6.5 s / 6.2 s (`20261027-193511-22fd00`,
      `20261027-193525-d183d8`), 371 tests, the same names and `Should` count, the one failure unchanged (a peer's:
      `test_drs_engine_neutrality.command.yml`, its description not the synopsis). Every `Get-Contract` call resolves the whole tree
      whatever its filter (553 ms all, 401 ms one group), and the file made one per group, 50 of them; one call in `BeforeAll` keyed by
      root, version and group now serves every case (ADR-AUTO-TEST-SETUPONCE).
- [x] Verdict (drone-opus, 2026-10-27): `Invoke-TestRun.Tests.ps1` went from 12.1 s / 11.1 s Pester (`out/test-file/20261027-192849-4c54d9`,
      `20261027-192908-bce471`) to 5.5 s / 5.5 s (`20261027-194404-d704c8`, `20261027-194417-17ae3a`), 22 tests passing, the same names and
      `Should` count. The mocks cost 40 ms a test; each run listed the real repository's language test folders through
      `Get-TestAutomationTestFiles` (`Get-LanguageTestFolders`, 250 ms a call), which no fixture path is; one mock in `BeforeAll` returns
      none. The rest, about 200 ms a run, is `Invoke-TestRun` itself under its mocks.
- [x] No lever (drone-opus, 2026-10-27): `Test-FileLimits.Tests.ps1` alone is 2.4 s / 1.4 s Pester (`out/test-file/20261027-192829-e65010`,
      `20261027-192840-286525`) against 12.2 s in the 12-shard snapshot run; its cost there is the shared machine, not the file.
- [x] Measured, not fixed (drone-opus, 2026-10-27): `Foundation.PrePost.Tests.ps1` alone is 5.7 s / 5.8 s Pester
      (`out/test-file/20261027-192804-92f162`, `20261027-192816-018530`), down from 13.3 s by the parallel `Build-Bicep`; the rest is its L1
      `BeforeAll` compiling `foundation` (tests sum 117 ms), product code in `pwsh/Azure.Templates`, which peers are editing.

## Decided

- No `out/` janitor, and the track lamps' walk keeps walking `out/` (the orchestrator, 2026-10-26): the walk took 494 ms over 25,405 files,
  10,405 of them under `out/` (catzc-f4), and the one test that walks the repository walks once, so skipping `out/` saves about 0.2 s; the
  out lamp hides and counts the run output file by file, so a skip would change the lamp language for it.
- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
