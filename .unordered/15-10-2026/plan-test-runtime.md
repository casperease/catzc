# out/plan-test-runtime.md

`Plan: a full devbox test run inside 3 minutes, so it fits the 6-minute window with room for the slow tiers`

Status: draft, 2026-10-14 (catzc-3b). Nothing built yet. **The user's call: the current values are roofs — `tests.run_seconds` 180 s, the
tier `level_ms`, and the 360 s background window are never raised; the suite is made to fit them by optimizing tests without removing what
they prove.** **T1 and T2 are built (uncommitted):** each shard writes `files-shard-<N>.json` (every file's whole Pester duration, set-up
included); the run merges them into `out/test-automation/durations.json` (648 files after one run); `Select-TestShardAssignment` deals the
parallel files longest first to the least-loaded worker, and the greedy files go to the pool longest first. Measured on an L0–L1 run
scheduled from that history: the five parallel workers finished in 54.0–56.8 s (within 5 %), where round-robin had spread 62–168 s on the
full run. **T3 is built (uncommitted), under the new ADR-AUTO-CACHE#10:** content-keyed result caches (shared `Get-ResultCache` /
`Split-CachedFile` / `Update-ResultCache` / `Get-ContentStamp`) for `Format-Code` (each engine's verdict inputs declared as `settings:` in
languages.yml; one engine run per engine; one-process `bicep format`) — whole repository cold 77 s, warm 2 s — and for the analyzer
(`Get-ScriptAnalyzerDiagnostics`, inputs in `Get-ScriptAnalyzerInputs`; the L2 analyzer test now calls that one engine instead of its own
copy) — cold 115.5 s, warm 5.1 s, the same issues both ways. **The glossary checks G4/G6 moved to C#** (`GlossaryProse`, `GlossaryScan`,
`GlossarySegment` in Catzc.Base.Docs): the real `Test-Glossary` takes 5–6 s where it took 29 s (63 s before the agent's first fix), with the
same issues. The repeatable per-file work (measure, isolate, diagnose, fix, prove) is the `test-optimization` agent
(`.claude/agents/test-optimization.md`); the scheduling and caching phases (T1–T3) are harness changes outside that agent.

## The budget

- **Devbox run budget: 180 s wall clock** for `Test-Automation` (L0–L3 in the working folder). `timeouts.yml` already declares it
  (`tests.run_seconds: 180`), but only reports against it.
- **Hard window: 360 s** for any background call (`limits.devbox.bash.background`). The run must leave room inside it for the slow work
  still to come (L3 against Azure, L4).
- **Today: over 360 s.** Run `20261014-214703` was stopped at 360 s with 655 files and 4,783 tests. The run before it (`054640`, 581 files)
  took 222 s. The suite grows about 12 % per day, so the run outgrows any fixed limit unless its cost stops scaling with the whole
  repository.

## Where the time goes

Measured from the shard results of runs `20261014-214703` and `20261014-054640` (`out/test-runtime-probe.ps1`).

### The cost is concentrated

- **875 s** of test time in total over 655 files, but **7 files take 451 s (52 %)**:

| File                                             |   s | What it does                                                         |
| ------------------------------------------------ | --: | -------------------------------------------------------------------- |
| `.internal/tests/Test-ScriptAnalyzer.Tests.ps1`  | 130 | PSScriptAnalyzer over the whole tree, every run                      |
| `QualityGates/tests/Test-Formatting.Tests.ps1`   |  88 | every formatter engine over every tracked file (one integrity test)  |
| `QualityGates/tests/Invoke-TestFile.Tests.ps1`   |  73 | 53 s is one snapshot test: copies the repository and imports it      |
| `Docs/tests/Test-Glossary.Tests.ps1`             |  53 | the glossary checks over every text file, twice (37 s + 15 s for G4) |
| `Azure.Templates/tests/Build-Bicep.L2.Tests.ps1` |  47 | three real `az bicep build` runs                                     |
| `.internal/tests/Import-Catzc.Tests.ps1`         |  31 | builds the bundle and loads it                                       |
| `.internal/tests/Import-AllModules.Tests.ps1`    |  31 | fresh imports of the whole system                                    |

- By module: QualityGates 296 s, `.internal` 230 s, Azure.Templates 96 s, Docs 68 s. Everything else together is under 200 s.

### The scheduler wastes what parallelism there is

- **Round-robin sharding is blind to duration.** The parallel phase's slowest shard took 168 s and its fastest 62 s, over the same ~128
  files each. The phase lasts as long as its slowest shard, so most workers sit idle for over a minute.
- **The greedy phase starts only after the parallel phase.** `Test-ScriptAnalyzer.Tests.ps1` (130 s) is greedy, so the run is about 168 s of
  parallel work, then 130 s of greedy work, plus the per-worker import, before anything else.
- **Every worker imports the whole system** (several seconds each) before its first test.

### The repository-wide checks run twice and see everything every time

- The integrity tests for formatting, analysis, glossary, spelling, markdownlint and links run the same quality gates a person runs before
  committing, over the **whole** tree, on every run, even when one file changed.

## Decisions

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R1  | **Schedule by measured duration.** Each run's rows (`rows-shard-*.json`) record each file's duration. The next run sorts files longest first and gives each to the least-loaded worker (longest-processing-time first), starting the greedy files at the same moment instead of after the parallel phase. A file with no history gets the median. The history is a gitignored per-machine file under `out/`, never committed. Expected: the 168 s shard drops to about 875 s ÷ workers + the longest file.                                                                                     |
| R2  | **Repository-wide checks become incremental.** Analysis, formatting, glossary, spelling and links each cache a result per file, keyed on the SHA-256 of the file's bytes plus the hash of the settings that decide the result (the analyzer settings, `languages.yml` with the engine pins, the glossary sources, the dictionaries). A run re-checks only the files whose key changed. This is [ADR-AUTO-CACHE](../docs/adr/automation/caching.md)'s content-keyed cache applied to quality gates; the cache lives under `out/` and a pipeline starts it empty, so CI still checks everything. |
| R3  | **The integrity test of a quality gate calls the gate, which is now incremental.** `Test-Formatting.Tests.ps1`, `Test-ScriptAnalyzer.Tests.ps1`, `Test-Glossary.Tests.ps1` and the rest keep their assertions; they get fast because the gate does (R2). No test is deleted to save time.                                                                                                                                                                                                                                                                                                      |
| R4  | **The run budget is enforced, not just reported.** `Test-Automation` fails a devbox run over `tests.run_seconds` with the per-file report attached, the same fail-fast stance as the time safeguard ([ADR-AUTO-FAILFAST](../docs/adr/automation/fail-fast-with-asserts.md)). The pipeline keeps its own limit. The tier limits (`tests.level_ms`) stay report-only until R1–R3 land, then the worst offenders are fixed one by one.                                                                                                                                                            |
| R5  | **Expensive set-ups are shared, not repeated.** The snapshot copy in `Invoke-TestFile.Tests` (53 s), the bundle build in `Import-Catzc.Tests` (31 s), and the fresh imports in `Import-AllModules.Tests` each build once per run in a shared, read-only fixture that the tests in the file reuse, where today each test builds its own. Where a test only needs to prove the wiring, it uses a reduced fixture (one module, not all).                                                                                                                                                          |

Considered and not chosen: **running only the tests "affected" by a change**, derived from the module dependency graph. It is the biggest
saving on paper, but it makes the devbox verdict depend on the graph being right, and a wrong graph silently skips the test that would have
failed. R2 gets most of the saving for the repository-wide checks, which are most of the cost, without that risk.

## Phases

Each phase measures before and after with the same probe, on the same machine, and records the numbers here.

| Phase | Work                                                                                                                                                                                                             | Done when                                                                                         |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| T1    | **Measure:** `Test-Automation` writes a per-file duration history after every run (from the rows it already collects), and the probe becomes a `Get-TestRunTiming` report.                                       | Two consecutive runs produce the history; the report reproduces the tables above.                 |
| T2    | **Schedule (R1):** longest-first scheduling from the history, greedy files in the same pool from the start.                                                                                                      | The slowest worker finishes within about 15 % of the average; full run under 300 s.               |
| T3    | **Incremental gates (R2, R3):** one shared content-keyed result cache for the quality gates, adopted first by the two most expensive, PSScriptAnalyzer and `Test-Formatting`, then glossary, spelling and links. | A run after a one-file change re-checks only that file; the two files drop from 218 s to seconds. |
| T4    | **Shared set-ups (R5):** the snapshot, bundle and import fixtures built once per file.                                                                                                                           | Those three files drop from 135 s to under 40 s together.                                         |
| T5    | **Enforce (R4):** the 180 s devbox budget fails the run; the tier-limit report names the next offenders.                                                                                                         | A full devbox run finishes under 180 s, leaving at least 180 s of the 360 s window for L3/L4.     |

T1 and T2 come first because they help every file at once and need no change to any test. T3 is the largest single saving.

### T4 measured (2026-10-15): the premise does not hold

Each file was run alone under vendored Pester (`out/probe-test-file.ps1`). The 135 s figure came from a loaded full run, where five workers
and the greedy files share the machine:

| File                      | Full run |  Alone | Where the time goes                                                                                                   |
| ------------------------- | -------: | -----: | --------------------------------------------------------------------------------------------------------------------- |
| `Import-AllModules.Tests` |     31 s |  7.7 s | already one cold sandbox import per tree shape (~1 s each, 5 of them) plus the greedy three-root switch (~2 s)        |
| `Import-Catzc.Tests`      |     31 s | 17.7 s | the full-build walking skeleton (13 s) and one reduced build (4 s): two different bundles, nothing to share           |
| `Invoke-TestFile.Tests`   |     73 s |   65 s | three real worker spawns, one per concern (ADR-AUTO-TEST#23): strict parity 27 s, snapshot 25 s, discovery-throw 12 s |

- No shared fixture is possible without weakening an assertion: each real-worker test needs its own run verdict (Failed by strictness,
  Failed by a discovery throw, Passed in a snapshot), so merging spawns would make one verdict hide another.
- **The common cost is the cold import itself:** 6–9 s per process (`-SkipJanitors`), 10.6 s with the janitors. `-DiagnoseLoadTime` puts 4.8
  s of 5.7 s in `Import-Module` parse/compile of 858 `.ps1` files (incl. AMSI scan-on-parse); file I/O is 86 ms. `Catzc.Base.QualityGates`
  alone is 1.2 s. Every shard worker and every real-worker test pays it.
- Under concurrent sessions the snapshot test can fail ("does not match its source … after 3 attempt(s)"): other sessions edit the tree
  while it copies. That is the snapshot guard doing its job, not a defect of the test.

**T4 becomes "cut the cold import"** (a loader change, so its own decision): candidates are fewer, larger parse units per module (one
generated script per module instead of one parse per file, measured against AMSI's per-scan cost), and the worker reusing one imported
process across the files it is dealt. Neither is started.

### Option 2 tested (2026-10-15): load a module on first use

Prototypes `out/probe-lazy-load.ps1` (the real tree) and `out/probe-lazy-strict.ps1` (throwaway modules); nothing in the tree changed.

- **Session ready in ~0.47 s instead of 5.7 s:** internal modules 34 ms, vendor 116 ms, C# types 313 ms, then `automation/` on
  `PSModulePath` and no catzc module loaded. The generated manifests (explicit `FunctionsToExport`, `.ps1` as `NestedModules`) autoload as
  they are.
- **A call loads only what it reaches:** `Get-RepositoryRoot` loaded 2 modules (122 ms); `Get-Glossary` 6 modules (0.8 s). Loading all 41
  this way costs about the same as the eager loop, so the saving is only what a process never calls.
- **Strict mode gap, and its fix:** an autoloaded module skips the loader's post-import `Set-StrictMode`, so it runs NOT strict. A first
  `NestedModules` entry that runs `Set-StrictMode -Version Latest` makes the module strict however it loads (autoloaded and eager both
  measured strict) — the manifest carries it, not the loader.
- **Pester needs the module loaded:** `Mock -ModuleName` and `InModuleScope` on a module nobody loaded fail ("No modules named 'Widget' are
  currently loaded"). 441 test files use them (QualityGates alone 585 references). **So test workers stay eager**, and option 2 does not
  shorten the suite: it shortens the interactive start and every child `pwsh` that calls a few commands.
- Still to settle before building it: the `PSModulePath` entry is inherited by child processes, which could then autoload a catzc module
  without the importer having loaded the C# types; the run-mode exclusivity (source vs build root) must replace the entry, never add a
  second; manifests must still be generated before the first call (about 100 ms for all).

### Speed assumptions verified (2026-10-15)

`out/bench-speed-assumptions.ps1` states each assumption with a threshold and measures it (median of 3 fresh processes; `-Only A7` etc.
reruns one). Helpers: `out/lazy-entry.ps1`, `out/bench-parse-units.ps1`, `out/bench-module-units.ps1`, `out/bench-amsi-check.ps1`.

| Id  | Assumption                                                                            | Verdict           | Measured                                                                                                                           |
| --- | ------------------------------------------------------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| A1  | the janitors add >= 2 s to an engine start                                            | BLOCKED           | the import with janitors fails outright (another session's invalid glossary entry): an engine start inherits any janitor's failure |
| A2  | a load-on-first-use engine start <= 1.5 s against eager >= 5 s                        | FAILS (threshold) | first use 0.83 s, eager 4.54 s, same answer: 5.5x, not the assumed 6x+                                                             |
| A3  | an engine start's janitors rewrite tracked files                                      | FAILS             | 0 files: the janitors write only what is out of date                                                                               |
| A4  | a bash engine start costs about a pwsh one                                            | HOLDS             | 4.36 s vs 4.54 s; 0.97 s with the first-use entry                                                                                  |
| A5  | one parse per module saves >= 30 % of parsing                                         | FAILS             | 22.7 %, and all parsing is only ~1.2 s                                                                                             |
| A6  | the module loop is >= 75 % of the import                                              | HOLDS             | 3.71 of 4.0 s (93 %)                                                                                                               |
| A7  | one joined .psm1 per module saves >= 30 % of the loop                                 | HOLDS             | 3.15 s -> 0.49 s (-84 %), 414 exports both; but errors point into the generated file                                               |
| A8  | a .psm1 that dot-sources each file saves >= 30 %                                      | FAILS             | 3.29 s (no saving): the cost is per script file loaded from disk, not the NestedModules wrapper                                    |
| A9  | a .psm1 that loads each file via Parser::ParseFile saves >= 30 %, keeps file and line | HOLDS             | 3.15 s -> 0.99 s (-68.5 %), 414 exports; Get-Command names the source file; errors report `Resolve-ConfigEntry.ps1:68`, as today   |

- **Where the time goes:** about 3 ms per `.ps1` loaded as a script file (858 files), not parsing and not the execution policy (Bypass: 3.1
  s vs 3.25 s).
- **Not a scan bypass:** `bench-amsi-check.ps1` loads Microsoft's AMSI test string from a file both ways; neither path is blocked (a
  file-loaded script is not AMSI-blocked here today), while `Invoke-Expression` of the same string is. A9 has the same exposure as the
  current loader.
- **What A9 is worth:** about 2.2 s off every process that imports catzc: each shard worker, each language-bridge engine start (~17 per
  run), each child import a test makes, and the interactive start (~5.7 s -> ~3.5 s). On a run of ~1,500 worker-seconds that is roughly 100
  worker-seconds (~7 %, ~20 s of wall clock): worth having, not enough alone for 180 s.

### A9 built (2026-10-15, committed in `974a105c`)

- A derived `<Module>.psd1` lists the module's files in `PrivateData.CatzcFiles`; its one `NestedModules` entry is the shared, tracked
  loader `automation/.internal/assets/Import-ModuleFiles.ps1`, which `ParseFile`s each file and dot-sources it into the module. Bundle
  manifests are unchanged (one merged NestedModule, ADR-PWSH-MANIFEST#5). Docs reworded: ADR-PWSH-MANIFEST context, ADR-PWSH-USEPS#1 and its
  source/build section, conventional-folders, the FAQ (two claims the measurements disproved), the bootstrap reference, CLAUDE.md.
- **Import 5.7 s -> 2.2 s** (`-DiagnoseLoadTime`: module loop 5.4 s -> 1.8 s; QualityGates 1.2 s -> 0.22 s).
- Verified: `Get-DynamicManifestContent.Tests` 21/21 (new: the derived manifest loads through the shared loader — exports, privates, source
  file and line, a syntax error names its file; derived text formatter-stable), `Import-AllModules.Tests` 18/18 (new: module functions run
  strict through the real importer; duplicate-name, vendor-shadow and run-mode eviction unchanged), `Invoke-ModuleBuild.Tests` 25/25,
  `Import-Catzc.Tests` 2/2 (17.7 s -> 12.2 s). Analyzer, source conventions and glossary clean.

### Snapshot runs start with the result caches (2026-10-15)

Run `20261015-011754` went to a snapshot (another session's run held the working folder) and hit the 360 s safeguard before its greedy phase
finished; `Test-Formatting.Tests` alone took 122 s. A snapshot has its own empty `out/`, so `Format-Code` and the analyzer started cold on
every snapshot run. `Enter-TestRunLocation` now copies the working folder's `out/cache` into the snapshot before priming it — the entries
are content-keyed (ADR-AUTO-CACHE#10), so they hold in a copy of the same tree. `Enter-TestRunLocation.Tests` 13/13 (two new: seeded when
present, absent when the working folder has none); analyzer clean.

### Result caches survive concurrent writers and snapshots; comments do not invalidate them (2026-10-15)

- **The analyzer cache held 28 entries for ~900 files.** Full analyses that finished ran in snapshots and saved into the snapshot's `out/`,
  which is deleted; the in-place run that would have saved at home was stopped at 360 s. Fixes: `Save-ResultCache` merges with what is on
  disk (its own entries win; another process's entry is safe to keep, its key being content + inputs) and replaces the file in one step
  (staging file + move), skipping a save it cannot make with a message; `Exit-TestRunLocation` merges a snapshot's `out/cache/*.json` home
  before removing it. Tests: `Save-ResultCache.Tests` (new, 4), `Exit-TestRunLocation.Tests` 6/6 (one new).
- **Comment-only edits to analyzer rules invalidated every entry** (catzc-27's citation sweep: six `.scriptanalyzer` rules, 40 s before a
  run, cost 127 s). `Get-ContentStamp` now fingerprints a PowerShell input by its tokens without comments, a run of line ends counting as
  one; any code change still changes it, and a file that does not parse falls back to its bytes. `Split-CachedFile.Tests` 6/6 (two new).
- Warm, in place: analyzer 122 s -> 11 s, formatting 113 s -> 5 s.

### Crash fixed: PipelineWatchdog (2026-10-15)

Run `20261015-023531` lost worker shard-2 to an unhandled `NullReferenceException` in `PowerShell.Stop()` from
`Catzc.Base.Timeouts.PipelineWatchdog`'s timer: `Timer.Dispose` does not wait for a running callback, so a limit passing as the pipeline
returned could stop an already disposed pipeline on a thread-pool thread, ending the process. The stop and `Dispose` now share a lock and a
disposed flag. `tests/types/PipelineWatchdog.Tests.ps1` (new, 2: stops a late pipeline; 200 pipelines whose limit lands around their return,
disposed in the caller's order); `Invoke-WithTimeout.Tests` 6/6. The types DLL is rebuilt (`Catzc.Types.d0367107.dll`, uncommitted).

### Under budget (2026-10-15, run after `20261015-024123`)

**156.0 s** wall clock for all tests (5,432 passed, 44 skipped, 12 failed), **in a snapshot** while another session's run held the working
folder: parallel workers 73.6–88.0 s (balanced from the updated history), greedy phase 68 s. 190 s with the import and the snapshot's
priming. The 12 failures are whole-repository integrity checks over other sessions' in-flight files, the known `Invoke-Importer` length
finding, and the uncommitted DLL. Runs before: 326 s (`001200`), 270 s (snapshot, `012543`), 187 s (`013832`, before the history caught up).

### T5 built: the budget fails a devbox run (2026-10-15, the user: "yeah fail")

New rule **ADR-AUTO-TEST#44** (rule, summary and body section "The whole-run budget" in `test-automation.md`). The private
`Test-TestRunOverBudget` decides it: a devbox run whose workers take longer than `tests.run_seconds` fails, with a red line naming its time
and the budget; a pipeline run (`Test-IsRunningInPipeline`) is left to its stage's limit. `Invoke-TestRun` folds it into the manifest status
and the throw (and stays under the function-length rule: 305 -> under 300 lines by the extraction); `Get-TestAutomationVerdict` names the
budget when it is the only cause; the report and the `timeouts.yml` comment no longer say report-only. Tests: `Test-TestRunOverBudget.Tests`
(new, 3), `Invoke-TestRun.Tests` 19 (3 new: devbox over fails, pipeline over passes, devbox within passes),
`Get-TestAutomationVerdict.Tests` 6 (2 new), `Write-TestAutomationReport.Tests` 4; analyzer clean; Test-AdrRegistry,
Test-AdrEngineNeutrality, Test-Links clean.

### Full run measured (2026-10-15, run `20261015-001200`)

676 files, 5,202 passed, 41 skipped, 10 failed, **325.8 s** (342 s with the import). **The greedy files start only when the parallel phase
ends (165 s)** and then take 160 s more (the longest: 127 s, 93 s, 74 s, 71 s). That is the largest lever left: starting the greedy files
alongside the parallel workers, as R1 intended, rather than after them. The 10 failures are all whole-repository integrity checks (links,
spelling, analyzer, markdownlint, formatting, Markdown titles, source conventions, the committed types DLL) reading a tree mid-way through
the ADR-PWSH split, not logic failures.

## Expected effect

| After | Full devbox run (estimate)                                                                                        |
| ----- | ----------------------------------------------------------------------------------------------------------------- |
| today | over 360 s (stopped)                                                                                              |
| T2    | about 875 s of tests ÷ 5 workers ≈ 175 s, bounded below by the longest file (130 s) plus imports: about 200–240 s |
| T3    | the two largest files mostly cached: about 640 s ÷ 5 ≈ 130 s, longest file now about 50 s: about 140–160 s        |
| T4    | about 100–130 s                                                                                                   |

## Open questions

1. **Workers.** The pool is `ProcessorCount / 4`, chosen when the run was smaller. Once R1 balances the work, should T2 re-measure 4, 5 and
   8 workers on this machine and set the default from the measurement?
2. **The 180 s figure.** Is 180 s the budget for the whole devbox run (L0–L3), or for L0–L2 with L3 run separately against Azure?
