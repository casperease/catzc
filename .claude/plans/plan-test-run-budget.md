---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Engines, pwsh/Catzc.Base.Timeouts/configs]
---

# The full test run under its 180 s roof

The per-engine format cache stamp (ADR-REPO-FORMAT-CONFIGUREDFORMATTERS), greedy groups, the decayed duration maximum and the scheduler that
starts shards 5 and 6 and the greedy pairs as soon as phase A frees a slot are in the tree. The user's last full run took 347 s against the
180 s `tests.run_seconds` budget; the effect of the scheduler is read from the next full run.

## Why its value is medium

The roof is a rule, not a target, so the value is a suite that proves the same in less time. The user runs full suites; this plan proposes
none.

## Decided

- The snapshot test (`Invoke-TestFile`) and the config conventions test (0.77 s against 400 ms) stay as they are; what each spends is what
  it proves, and scheduling, not the files, is the lever. The user may decide otherwise.
- `Test-MarkdownTitle.Repository.Tests.ps1` (L1, integrity) takes 2.45 s warm and 3.68 s cold against the 2 s L1 limit, its one test reading
  every in-scope Markdown file, which is what it proves; the over-limit line is report-only. A stated per-test limit with its reason is the
  user's choice; nothing changes until then.
- The three costliest files (about 14 s alone each) have no lever inside them: each test is one real build; about half of their full-run
  figure is contention between build-heavy greedy files.
- Watch: a first `Invoke-TestFile` of `Get-TimeoutSeconds.Repository.Tests` and `Get-EngineCaseTable.Tests` once crashed after 3 s with
  empty stderr before any test ran; a second run passed (likely an import race).

## Open steps

- [ ] Read the final session's full run (`out/test-automation`), no run started for it: its wall clock and phase table against 347 s, phases
      B and C overlapping A, and `Invoke-TestFile.Tests.ps1` apart from `Test-Formatting.Tests.ps1` (task-test-run-budget step 1) (check:
      the table and the verdict recorded here). Data so far: the user's run `out/test-automation/20261018-194315` crashed on the roof,
      "PesterRunner timed out after 360s with 1 worker(s) unfinished: shard-20", the whole run passing its wall clock (371 s against
      360 s); shards 0 to 19 wrote results, and shard-20, the last scheduled (`python/tests/catzc-base-repository`), runs in 9 s alone.
      Read 2026-10-18 (`out/analyze-run.py`: a shard's start from its results XML, its end from the XML's mtime). The box stays open: a
      crashed run is no final run.

      | Phase (shards)  | 347 s run | this run, 371 s                  | Driver in this run                                                  |
      | --------------- | --------- | -------------------------------- | ------------------------------------------------------------------- |
      | A: 0-4          | 114 s     | +15 to +236 s                    | shard 0, Test-Formatting.Tests 202.6 s (failed)                     |
      | B: 5 and 6      | 135 s     | +140 to +332 s, overlapping A    | shard 5, `.internal/tests/Test-ScriptAnalyzer.Tests` 191.2 s (failed) |
      | C: 7-20 greedy  | 88 s      | +195 to roof, overlapping A and B | greedy files still one after another; shard 20 unfinished         |

      `Invoke-TestFile.Tests.ps1` (shard 6) and `Test-Formatting.Tests.ps1` (shard 0) sit in different shards, but their windows overlap
      (+142 to +190 s inside +15 to +236 s). The two drivers are not slow in themselves: alone, under `Invoke-TestFile`,
      Test-Formatting.Tests takes 35.1 s (its one real whole-tree format check, what it proves) and
      `.internal/tests/Test-ScriptAnalyzer.Tests` 25.4 s, against 202.6 s and 191.2 s in the run; the cost is the run's cold format and
      analyzer caches after the day's churn plus four shards competing, and neither file has a lever inside it. Both also fail on findings
      that are not speed: unformatted files and a help page (Test-Formatting), and analyzer findings in `Catzc.Internal.Importer.psm1`
      and `Get-GlossaryEnforcementViolations.Tests.ps1`.
      One file made faster: `Get-ContractCheckResults.Assets.Tests.ps1`, 47.5 s to 30.6 s alone, 241 of 241 passed both times
      (`out/test-file/20261018-200945-a639fa`, `out/test-file/20261018-201140-ddabc7`). `Get-Contract` costs 227 ms a call against 11.7 ms
      for the check, and its 127 asset cases share 22 unit, version and module groups, so each group is looked up once with the same
      filtered call (ADR-AUTO-TEST-SETUPONCE). Its command cases (22.3 s) keep one `Get-CommandContract -Name` call each, since the call
      proves the name filter.
- [ ] One engine start of a black-box test is bounded under the shard roof (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT): the Python and Go tests
      bounded each of their two starts at 300 s, so the inner bound could never fire before the 360 s roof. `tests.engine_start_seconds`
      (150, `timeouts.yml` and the default on `TimeoutsConfig`) reaches every engine through `Get-EngineContract` as
      `CATZC_ENGINE_TIMEOUT_SECONDS`, and `test_repository.py` and `repository_test.go` read it (check: TimeoutsConfig.Tests and
      Get-EngineContract.Tests pass under Invoke-TestFile; the Python and Go folders pass alone; the user's next full run is the proof).

## Refs

- pwsh/Catzc.Base.Timeouts/configs/timeouts.yml
- docs/adr/repository/uniform-formatting.md
