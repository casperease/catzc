---
task:
  status: open
  plans: [plan-test-run-budget]
  value: medium
  blocked_on: step 3 reads the shard manifest of the final session's full run (task-user-runs-and-commits, last step); no run is asked for
  targets:
    [
      docs/adr/repository/uniform-formatting.md,
      pwsh/Catzc.Base.QualityGates,
      pwsh/Catzc.Base.Engines,
      pwsh/Catzc.Base.Timeouts/configs/timeouts.yml,
    ]
---

# Task: the full test run under its 180 s roof

Last measured 265.8 s. Landed: greedy groups and the decayed duration maximum. The largest lever left is the format cache stamp: every
engine's stamp includes `tools.yml`, so any pin edit reformats the whole repository for every engine (PowerShell 58 to 76 s cold). The roof
is a rule, not a target; this task proposes no full run, the user runs them (memory: user handles commits and tests).

## Steps

1. [x] D08 recorded; `docs/adr/repository/uniform-formatting.md`: one sentence, an engine's cache stamp contains its own tool pin and its
       own settings files, nothing else. Check: Test-AdrRegistry, Test-Links. Done 2026-10-18: ADR-REPO-FORMAT#8 says an engine's
       `settings:` entries are its whole stamp, citing ADR-AUTO-CACHE#10; `ADRREG issues=0`, `LINKS issues=0`, `MDLINT issues=0`.
2. [x] The stamp: find where it is built (`Catzc.Base.Engines` or the Format-Code cache in QualityGates); per engine, hash only that
       engine's pin from `tools.yml` and its settings files. Two tests: an unrelated pin edit leaves another engine's cache warm; every
       declared stamp input invalidates it (the risk is a stale result from a missed input). Check: the Test-Formatting tests pass cold and
       warm. Correction 2026-10-18, from the tree: the work had already landed. `Get-FormatEngineStamp` (QualityGates, private) hashes each
       `<file>#<key>` entry by that key's value alone, and every engine in `languages.yml` lists `tools.yml#<tool>` keys, never the whole
       registry. Its tests already hold both cases: 'stays when only another key changes' and 'changes when that key's value changes', plus
       the missing-input and never-the-whole-registry cases; 13 of 13 pass. `Test-Formatting.Tests.ps1` passes 4 of 5 cold and warm (15.2 s,
       then 10.2 s); the failure is its integrity case, "formatting leaves the repository unchanged", over 18 unformatted working-tree
       files, none of them a stamp file.
3. [x] Landed 2026-10-18 by session catzc-93, verdict: "Invoke-TestFile.Tests (shard 6, alone) and Test-Formatting.Tests (shard 0) are
   apart in all three manifests; the 347 s run is 81 s over the ~265 s runs, almost all in wave B, where Test-ScriptAnalyzer.Tests ran
   134.2 s against 34.2 s and 3.7 s; no run started". No manifest holds 265.8 s; compared against 20261018-130623 (264.55 s, snapshot)
   and 20261018-115412 (266.42 s, in-place); the 347 s run is 20261018-153550 (347.47 s, snapshot, -Isolated).

   | Phase (shards)                       | 347.47 s | 264.55 s | 266.42 s | Driver in the 347 s run                                             |
   | ------------------------------------ | -------- | -------- | -------- | ------------------------------------------------------------------- |
   | A: 0-4 in parallel                   | 114 s    | 113 s    | 129 s    | shard 1, 112.2 s (Get-AdrUsage.Tests 49.7 s); Test-Formatting 50.9 s |
   | B: 5 and 6 in parallel               | 135 s    | 46 s     | 30 s     | shard 5 Test-ScriptAnalyzer.Tests 134.2 s (34.2 / 3.7 s); shard 6 Invoke-TestFile.Tests 52.8 s |
   | C: 7-20 as 7 greedy pairs, in series | 88 s     | 95 s     | 96 s     | Language.Bridge pairs 19+20 (19.2 s), 17+18 (14.3 s); Import-Catzc 13.4 s |

   Phase A (~113 s) plus phase C (~90 s) exceed 180 s alone in every run, so phase B is pure overrun; in the 347 s run B is a cold
   Test-ScriptAnalyzer (cause not dug into). The structural levers are the serial phases (C's seven pairs in series; B and C could start
   beside A's tail). The import-race crash does not reproduce in these manifests; the one observation is
   `out/test-file/20261018-160653-ad3359` and `-160656-e57894` (crashed in 2.7 s, shard exit 1, no rows). Original step: From the shard
   manifest of the final session's full run (and of any earlier run the user made on their own; this task asks for none):
   `Invoke-TestFile.Tests.ps1` no longer shares a shard with `Test-Formatting.Tests.ps1`; record the shard table and wall clock against the
   265.8 s run in the plan. Check: the table in the plan, read from `out/test-automation`, no run started for it. Reported 2026-10-18 by
   session catzc-93: the user's last full run took 347 s against the 180 s `tests.run_seconds` budget; that run's manifest is one this
   step may read now.
4. [x] Next three files by cost (Get-BicepParameterModel.Shipped 33.6 s, Import-Catzc 32.9 s, Build-Bicep.L2 31.3 s, then the
       Test-BuildArtifact files), one at a time through the `test-optimization` robot, each measured against the new balance. Check: same
       assertions, lower time, recorded per file.
   - `Get-BicepParameterModel.Shipped.Tests.ps1`, 2026-10-18, no edit: 3 tests, about 4 s each (14.3 s container, run alone twice,
     `out/test-file/20261018-114611-03d7dc`); the 33.6 s was contention in the full run. Each test is one real `az bicep build` per shipped
     template, which is what this L2 integrity test proves, so no rule in this file applies. Open for the user, both outside the file: one
     shared build per template for the whole run (other Build-Bicep tests may rebuild the same three), or the three builds in parallel in
     `BeforeAll`.
   - `Import-Catzc.Tests.ps1`, 2026-10-18, no edit: 2 tests, the full build 9.6 s and the reduced build 4.2 s (13.9 s run alone,
     `out/test-file/20261018-114958-f49ab2`), so about 19 s of the 32.9 s was contention. Each test is one real
     `Test-BuildArtifact -Facet Load` of a different profile, which is what it proves. Open for the user, outside the file: make
     `Test-BuildArtifact` cheaper (one type-set build shared by both calls), or cap how many greedy files run at once in the full run.
   - `Build-Bicep.L2.Tests.ps1`, 2026-10-18, no edit: 3 tests, 5.9 s, 4.4 s and 4.6 s (14.8 s run alone,
     `out/test-file/20261018-115121-55bfcb`), so about 16 s of the 31.3 s was contention. Each test is one real `az bicep build` of a
     different template. Caching the `az bicep` state check per session is ruled out: a guard's verdict is never cached in a session on the
     devbox, which is a regulated box too.
   - Step 4 verdict: none of the three files has a lever inside it; each is about 14 s alone, and about half of each full-run figure is
     contention between greedy files that each spawn real builds. The lever is the scheduler: keep the build-heavy greedy files (az bicep
     builds, `Test-BuildArtifact`) from overlapping, which step 3's shard table measures. That is the user's decision.
5. [x] Items 2 and 3 of the carried draft (the Invoke-TestFile snapshot test, the config conventions test at 0.77 s) stay as they are unless
       the user decides otherwise; one Decided line. The markdown title test re-measured once Get-MarkdownScope landed. Check: the lines
       exist. Done 2026-10-18: both lines are under the plan's new Decided section. `Test-MarkdownTitle.Repository.Tests.ps1` (L1) is 2.45 s
       warm, 3.68 s cold against the 2 s limit, its whole-repository read being what it proves; the other three title and scope files are
       under 0.5 s warm.
6. The scheduler (the user's decision 2026-10-18, held by session catzc-93): first the cold Test-ScriptAnalyzer cache, read from its stamp
   inputs and the manifests, fixed in the file that builds the stamp; then the Test-Automation scheduler starts shards 5, 6 and the greedy
   pairs as phase A frees slots, keeping build-heavy greedy files apart, one file at a time. Check: the stamp's and the scheduler's L0
   test files pass under Invoke-TestFile; no run started; the next full run's manifest is read when the user makes it. The cold cache,
   found 2026-10-18 by catzc-93: the stamp is correct (ADR-AUTO-CACHE#10), but any terminology or glossary edit regenerates a `.cspell`
   file and so re-analyzes all ~1630 files (~130 s; 15:36 run: only `vssps` added, 637d66ca9). Decided by the orchestrator on the user's
   delegation: `Get-ScriptAnalyzerDiagnostics` runs two cached passes, the spelling rule keyed on the dictionaries and its own files,
   every other rule on settings, rules and manifest only; an L0 case proves a dictionary-only change re-runs only the spelling pass.
   The scheduler, decided by the orchestrator on the user's delegation: one PesterRunner pool with a per-class cap (greedy files start in
   any slot a parallel shard frees, at most `greedy_group_size` at once, serial last and alone); "build-heavy apart" is a `greedy_apart`
   list in `test-policy.yml` with its default declared once on TestPolicyConfig; ADR-AUTO-TEST#26 is reworded to the pool.
   Part 1 landed 2026-10-18 by session catzc-93, verdict: "the analyzer cache is split into two passes, rules and spelling, each keyed on
   every input it declares (ADR-AUTO-CACHE#10); a dictionary-only change re-runs only the spelling pass: 22.9 s against 151.7 s for a
   full cold run, and 4.1 s warm; repo-wide .internal Test-ScriptAnalyzer.Tests passes" (new CatzcSpelling.psm1 and private
   Invoke-ScriptAnalyzerShards; settings re-linked). Part 2 written, unverified: blocked on the importer's compile error in
   ContractParameter.cs:107 (catzc-f3's in-progress step 8).
7. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
