---
plan:
  status: active
  value: high
  reviewed: 2026-10-29
  class: feature
  targets: [pwsh/Base.QualityGates, python, go/tests, bash/tests]
---

# Test run inside its budget

The full `Test-Automation` run is green (10875 passed, 0 failed) but takes 239.2 s against its 180 s budget (`tests.run_seconds`), in run
`out/test-automation/20261029-214736` (measurements in `out/test-run-budget/packing.md`): the prewarm takes 19 s, the five parallel shards
end at 193-215 s, and the greedy files end 24 s after them. A language folder runs its three engines in series, each one engine start. The
limit stays; the tests and the run's overhead get faster (ADR-AUTO-TEST).

## Open steps

1. [ ] Run the three engines of one language folder in parallel inside the bridge, `pwsh/Base.QualityGates/tests/Language.Bridge.ps1`, each
       under its own engine contract. Check: `Test-Automation -Modules Catzc.Base.Repository, Catzc.Base.Slides`, green, with the folder
       times before and after.
2. [ ] Profile `pwsh/Base.QualityGates/tests/Invoke-TestFile.Tests.ps1`'s snapshot case (54 s of its 72 s alone): the snapshot copy, the
       priming import and the offline uv sync, timed apart in `packing.md`. Check: the three parts sum to the case's time, within 10%.
3. [ ] If the priming import dominates, give the snapshot case a smaller fixture tree, never a skipped stage. Check: `Invoke-TestFile` on
       that file, green, with its seconds before and after.
4. [ ] Run `test-speed` on the next files by cost: `TrackLamps.Tests.ps1`, `Import-Catzc.Tests.ps1`, `Test-Spelling.Tests.ps1`. Check: each
       file's own `Invoke-TestFile`, green, with its seconds before and after.

The plan closes on the user's full `Test-Automation` run inside 180 s.
