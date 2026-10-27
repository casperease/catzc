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

| File                                       | Seconds | Cause                                                                     |
| ------------------------------------------ | ------: | ------------------------------------------------------------------------- |
| `Test-BicepTemplateCompliance.Tests.ps1`   |    54.3 | one L1 test, 53.8 s: `Build-Bicep` runs one bicep process per slot in turn |
| `Get-ContractCheckResults.Assets.Tests.ps1` |    27.1 | left to catzc-e9                                                         |
| `Wait-CatzcRunLock.Tests.ps1`              |    17.6 | real lock waits in whole seconds: the waits are what it proves             |
| `catzc-track-lamps.Tests.ps1`              |    13.5 | four L1 walks of the real repository, 1.8-3.9 s each                       |
| `Foundation.PrePost.Tests.ps1`             |    13.3 | its L1 `BeforeAll` compiles foundation again (tests sum 117 ms)            |
| `Test-FileLimits.Tests.ps1`                |    12.2 | one L1 pass over every tracked file, under its 30 s roof                   |
| `SourceConventionScan.Tests.ps1`           |    12.0 | one L1 test over every PowerShell file, 11.3 s                             |

## Open steps

- [ ] Measure what the shared import costs each test run a second time: a lone `Invoke-TestFile` run's `run.json` `durationSeconds` against
      its `files-shard-0.json` `DurationMs` is the worker's start, import and Pester load. The first sample, `Test-BicepTemplateCompliance`
      alone in place (`out/test-file/20261027-160116-0cf782`), is 52.4 s against 46.6 s: 5.8 s per worker, so about 70 s of the run's 12
      workers. Check: a second lone run of one small file, its number recorded here.
- [ ] `Build-Bicep` runs every slot's `bicep build-params` and the `main.bicep` build one after another, each a full compile of the template
      in its own bicep process; send them through `Invoke-ExecutableParallel` (`CliRunner.RunMany`, the throttle of `timeouts.yml`
      `parallel.processes`), as `Build-Bicep.Integrity.Tests.ps1` already compiles its slots side by side. It speeds every caller,
      `Test-BicepTemplateCompliance.Tests.ps1` (53.8 s) and `Foundation.PrePost.Tests.ps1` (13.3 s) first. The seven `Build-Bicep*.Tests.ps1`
      files mock `Invoke-Executable` for the build-params calls and move to a mock of `Invoke-ExecutableParallel`, and
      `private/Invoke-BicepParamsBuild.ps1` goes, its existence assert kept in `Build-Bicep`. Check: both files twice with `Invoke-TestFile`,
      the same test names and `Should` count, the compiled `main.json` and parameter files identical to a serial build, and
      `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [ ] `catzc-track-lamps.Tests.ps1` (13.5 s): measure whether its four L1 walks of the real repository can share one walk in `BeforeAll`
      (ADR-AUTO-TEST-SETUPONCE) without changing what each proves.
- [ ] `SourceConventionScan.Tests.ps1` (12.0 s): measure the one test that parses every PowerShell file, and whether a parse is repeated.

## Decided

- No `out/` janitor, and the track lamps' walk keeps walking `out/` (the orchestrator, 2026-10-26): the walk took 494 ms over 25,405 files,
  10,405 of them under `out/` (catzc-f4), and the one test that walks the repository walks once, so skipping `out/` saves about 0.2 s; the
  out lamp hides and counts the run output file by file, so a skip would change the lamp language for it.
- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
