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
- Decided by the orchestrator, 2026-10-18 (one living version, no fake read, no suppression): `-DiagnoseBlocking` leaves `Invoke-Importer`,
  `Invoke-TestRun` and `Test-Automation` with their help, contract, lookup and the watchpoint test context, since no watchpoint stands;
  ADR-PWSH-ASSERT-WATCHBLOCKINGBEHINDSWITCH says the switch is added with the next watchpoint and deleted with the last one.
- Decided by the orchestrator, 2026-10-18 (one living version: generate equals format): `Build-Glossary` writes its `**Defined by:**` line
  through `Format-MarkdownParagraph` like its other lines, so a rule link longer than a line moves to its continuation line as prettier puts
  it.

## Open steps

- [x] Read the final session's full run (`out/test-automation`), no run started for it: its wall clock and phase table against 347 s, phases
      B and C overlapping A, and `Invoke-TestFile.Tests.ps1` apart from `Test-Formatting.Tests.ps1` (task-test-run-budget step 1) (check:
      the table and the verdict recorded here). The box stays open: the run read so far crashed, and a crashed run is no final run.
  - Read 2026-10-18 (orchestrator, from catzc-c4's reading): the user's final run `out/test-automation/20261018-205956` finished in 221.05
    s, no crash. The budget it enforces is 180 s (`TestRunDefaultSeconds` in `TimeoutsConfig.cs:27`, failed by `Test-TestRunOverBudget`);
    `timeouts.yml` has no `run_seconds` key and 360 s is the pwsh roof. The 347 s figures below are the older baseline. Get-AdrUsage.Tests
    went 34 s to 15 s (6 of 6 kept, `out/test-file/20261018-211459-238c40`); the Invoke-TestFile real-worker file stays at 25 s, its cost
    being what it proves.
  - The user's run `out/test-automation/20261018-194315` crashed on the roof, "PesterRunner timed out after 360s with 1 worker(s)
    unfinished: shard-20", the whole run passing its wall clock (371 s against 360 s); shards 0 to 19 wrote results, and shard-20, the last
    scheduled (`python/tests/catzc-base-repository`), runs in 9 s alone. Read with `out/analyze-run.py` (a shard's start from its results
    XML, its end from the XML's mtime).
  - Phase A (shards 0 to 4): 114 s in the 347 s run, +15 to +236 s here; the driver is shard 0, Test-Formatting.Tests 202.6 s (failed).
  - Phase B (shards 5 and 6): 135 s in the 347 s run, +140 to +332 s here, overlapping A; the driver is shard 5,
    `.internal/tests/Test-ScriptAnalyzer.Tests` 191.2 s (failed).
  - Phase C (shards 7 to 20, greedy): 88 s in the 347 s run, +195 s to the roof here, overlapping A and B; the greedy files still run one
    after another, and shard 20 never finished.
  - `Invoke-TestFile.Tests.ps1` (shard 6) and `Test-Formatting.Tests.ps1` (shard 0) sit in different shards, but their windows overlap (+142
    to +190 s inside +15 to +236 s).
  - The two drivers are not slow in themselves: alone, under `Invoke-TestFile`, Test-Formatting.Tests takes 35.1 s (its one real whole-tree
    format check, what it proves) and `.internal/tests/Test-ScriptAnalyzer.Tests` 25.4 s, against 202.6 s and 191.2 s in the run; the cost
    is cold format and analyzer caches after the day's churn plus four shards competing, and neither file has a lever inside it.
  - One file made faster: `Get-ContractCheckResults.Assets.Tests.ps1`, 47.5 s to 30.6 s alone, 241 of 241 passed both times
    (`out/test-file/20261018-200945-a639fa`, `out/test-file/20261018-201140-ddabc7`). `Get-Contract` costs 227 ms a call against 11.7 ms for
    the check, and its 127 asset cases share 22 unit, version and module groups, so each group is looked up once with the same filtered call
    (ADR-AUTO-TEST-SETUPONCE). Its command cases (22.3 s) keep one `Get-CommandContract -Name` call each, since the call proves the name
    filter.
  - The two failing drivers, made green 2026-10-18. With `-DiagnoseBlocking` removed (see Decided) and `importer.ps1`,
    `importer-commands.sh` and the contract reference regenerated, under `Invoke-TestFile`: `.internal/tests/Test-ScriptAnalyzer.Tests`
    "Passed" (`out/test-file/20261018-202830-8588d7`), `Invoke-TestRun.Tests` "Passed" (`20261018-202757-524a41`), `Test-Automation.Tests`
    "Passed" (`20261018-202809-a020c2`); Test-Contracts 0, Test-AgentDefinitions 0, Test-AdrRegistry 0 and Test-Links 0 on the ADR. The four
    files and nine YAML configs the format check named are formatted, each config test passing.
  - The markdown findings: `Test-Formatting.Tests` then listed 629 Markdown files whose lines the code-language rename made longer than 140,
    so prettier re-wraps them. No earlier run passed them: the 20:07 run's integrity case failed on 627 files too (catzc-a2,
    `out/formatting-cache-pass-cause.md`); its error message was only read in part. `links.yml` is no input of the markdown stamp
    (`.prettierrc.yml`, `.prettierignore`, `.editorconfig`, `tools.yml#prettier`, `tools.yml#node_js`).
  - Formatted in folder batches, each checked before the next: `docs/adr` 127 (Test-Links 0, Test-AdrRegistry 0), `docs/` outside `docs/adr`
    and every `.assets/` 327 (Test-Links 0), `.claude/skills` and `.claude/agents` 4 (Test-Links 0, Test-AgentDefinitions 0),
    `.claude/plans` 18 (Test-Links 0, Test-Plans 0). `Test-Formatting.Tests` then lists 152 (`out/test-file/20261018-203822-88430d`): 151
    inside the slide folders catzc-b4 and catzc-a2 hold, and `docs/adr/glossary.md`.
  - The glossary: `Build-Glossary.Tests` "Passed" with a case pinning the wrap (`out/test-file/20261018-204120-31c271`); regenerated, a
    `Format-Code -DryRun` on the glossary changes 0 files, and `Test-GeneratedFiles -Generator Build-Glossary` reports 0.

- [x] One engine start of a black-box test is bounded under the shard roof (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT): the Python and Go tests
      bounded each of their two starts at 300 s, so the inner bound could never fire before the 360 s roof. `tests.engine_start_seconds`
      (150, `timeouts.yml` and the default on `TimeoutsConfig`) reaches every engine through `Get-EngineContract` as
      `CATZC_ENGINE_TIMEOUT_SECONDS`, and `test_repository.py` and `repository_test.go` read it (check: TimeoutsConfig.Tests and
      Get-EngineContract.Tests pass under Invoke-TestFile; the Python and Go folders pass alone; the user's next full run is the proof).
      Proven 2026-10-18 by the user's full run `out/test-automation/20261018-214701`: 155.8 s, under the 180 s budget, 7217 passed; its one
      failure, the two scheduler functions' missing help pages, is fixed (pages written, both test files Passed, Format-Code 0).

- [x] Bring the full run under its 180 s budget (221.05 s on 2026-10-18), one slow file at a time as test-optimization does, every test kept
      and no limit raised; the next candidates are the slowest tests in the run's `summary.md` (check: the user's next full run reports no
      budget overrun). Proven 2026-10-18 by the user's full run `out/test-automation/20261018-214701`: 155.8 s, under the 180 s budget, 7217
      passed; its one failure, the two scheduler functions' missing help pages, is fixed (pages written, both test files Passed, Format-Code
      0).
  - Round 1 (catzc-c4, 2026-10-18): Invoke-Executable's post-exit drain waited 5 s per pipe; `CliRunner.cs` Supervise now shares one 5 s
    deadline across stdout and stderr, the test 10.3 s to 5.25 s, Invoke-Executable.Tests 59 Passed
    (`out/test-file/20261018-211713-ad2558`). Left, their cost being what they prove: the real markdownlint run (13.1 s, already skipped on
    an unchanged glob set) and the full-build load of Import-Catzc (11.2 s).
  - Round 2 (catzc-c4, 2026-10-18; before = full-run timings under load, after = one file alone): Markdown titles 4.9 s to 3.5 s
    (`Get-MarkdownHeadingFinding` skips a line that cannot start a heading before its regexes); the declared graph 4.4 s to 1.44 s
    (`Get-CSharpTypeDependency`'s token regex anchored to the module names, 43 edges byte-identical with HEAD); Build-RootConfig's real
    rootconfig Describe 4.2 s to 1.59 s (one dry-run render in BeforeAll instead of three). Every test kept; each file Passed. The user's
    next full run is the measure.
  - Run 2026-10-18 21:22 (`out/test-automation/20261018-212253`): 188.0 s against 180 s. Decided by the user: close the last 8 s by
    scheduling, not by raising the budget: the long proving files (the Invoke-TestFile real worker 25 s, the markdownlint run 13 s, the
    full-build load 11 s) start first in shards of their own so they overlap the rest; no test weakened, no limit raised.
  - Landed 2026-10-18 (catzc-c4): the pool is the parallel shards plus min(greedy_group_size, greedy files) (`Get-TestPoolSize`), so the
    longest greedy files start at t=0 beside the 5 shards; a one-file greedy shard keys its duration history by its own file
    (`Get-TestDurationKey`), so the bridged go/python shards stop sharing one zero-weight key; ADR-AUTO-TEST's greedy rule describes the
    extra workers. Both new test files failed first and Passed; Test-Links, Test-Glossary, Test-GeneratedFiles, Test-Comments,
    Test-AdrRegistry and Test-FunctionDependency 0; ManualTestPlan-Coverage Passed. Modelled 119 s (about 140 s with the model's gap); the
    user's next full run is the proof. The bridged shards get their own weight from the run after next.

## Refs

- pwsh/Catzc.Base.Timeouts/configs/timeouts.yml
- docs/adr/repository/uniform-formatting.md
