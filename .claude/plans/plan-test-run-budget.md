---
plan:
  status: active
  value: high
  reviewed: 2026-10-29
  class: feature
  targets: [pwsh/Base.QualityGates, python, go/tests, bash/tests]
---

# Test run inside its budget

The full `Test-Automation` run is green (10872 passed, 0 failed) but takes 254.1 s against its 180 s budget (`tests.run_seconds`), in run
`out/test-automation/20261029-211212`. The shards are balanced (`out/test-run-budget/packing.md`): the five parallel shards each carry about
180 s of tests, and the run's own start and end add about 70 s. The limit stays; the tests and the run's overhead get faster
(ADR-AUTO-TEST).

## Open steps

1. [ ] Time the run's own start and end apart: the import, the prewarm, discovery and sharding before the pool, and the report after it,
       from timestamped `Write-Message` lines in one module run, written to `out/test-run-budget/packing.md`. Check: the parts and the pool
       time sum to the run's wall clock, within 5 s.
2. [ ] Measure one engine start under pwsh, bash and zsh in a language folder (`python/tests/base_repository`): the fixed cost per engine
       against the per-case cost, written to the same `packing.md`. Check: the three numbers sum to the folder's recorded time, within 10%.
3. [ ] If the fixed engine start dominates, run the three engines of one language folder in parallel inside the bridge,
       `pwsh/Base.QualityGates/tests/Language.Bridge.ps1`, each under its own engine contract. Check:
       `Test-Automation -Modules Catzc.Base.Repository, Catzc.Base.Slides`, green, with the folder times before and after.
4. [ ] Profile `pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1`'s snapshot case (54 s of its 72 s alone): the snapshot copy, the
       priming import and the offline uv sync, timed apart in `packing.md`. Check: the three parts sum to the case's time, within 10%.
5. [ ] If the priming import dominates, give the snapshot case a smaller fixture tree, never a skipped stage. Check: `Invoke-TestFile` on
       that file, green, with its seconds before and after.
6. [ ] Run `test-speed` on the next files by cost: `TrackLamps.Tests.ps1`, `Import-Catzc.Tests.ps1`, `Test-Spelling.Tests.ps1`. Check: each
       file's own `Invoke-TestFile`, green, with its seconds before and after.

The plan closes on the user's full `Test-Automation` run inside 180 s.
