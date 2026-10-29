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
`out/test-automation/20261029-211212`. Its 1166 files hold about 1739 s of test time across about 6.8 busy workers on average, so the run
needs about 500 s less test time or a tighter packing of the shards. The limit stays; the tests get faster (ADR-AUTO-TEST).

## Open steps

1. [ ] Measure the shard packing: from that run's `durations.json` and its `worker-shard-N.log` files, write
       `out/test-run-budget/packing.md` with each shard's busy seconds and its last file's end. Check: the table sums to the durations
       total, within a second.
2. [ ] If one shard ends far after the others, order the shard assignment longest-first in `New-TestAutomationShardScript.ps1`, from the
       recorded durations. Check: `Invoke-TestFile` on `New-TestAutomationShardScript.Tests.ps1`, and a module run whose wall clock is
       measured before and after.
3. [ ] Measure one engine start under pwsh, bash and zsh in a language folder (`python/tests/base_repository`): the fixed cost per engine
       against the per-case cost, written to the same `packing.md`. Check: the three numbers sum to the folder's recorded time, within 10%.
4. [ ] If the fixed engine start dominates, run the three engines of one language folder in parallel inside the bridge,
       `pwsh/Base.QualityGates/tests/Language.Bridge.ps1`, each under its own engine contract. Check:
       `Test-Automation -Modules Catzc.Base.Repository, Catzc.Base.Slides`, green, with the folder times before and after.
5. [ ] Profile `pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1`'s snapshot case (54 s of its 72 s alone): the snapshot copy, the
       priming import and the offline uv sync, timed apart in `packing.md`. Check: the three parts sum to the case's time, within 10%.
6. [ ] If the priming import dominates, give the snapshot case a smaller fixture tree, never a skipped stage. Check: `Invoke-TestFile` on
       that file, green, with its seconds before and after.
7. [ ] Run `test-speed` on the next files by cost: `TrackLamps.Tests.ps1`, `Import-Catzc.Tests.ps1`, `Test-Spelling.Tests.ps1`. Check: each
       file's own `Invoke-TestFile`, green, with its seconds before and after.

The plan closes on the user's full `Test-Automation` run inside 180 s.
