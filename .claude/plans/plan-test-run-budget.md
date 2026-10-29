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
end at 193-215 s, and the greedy files end 24 s after them. The limit stays; the tests and the run's overhead get faster (ADR-AUTO-TEST).

## Open steps

1. [ ] Let `New-RepositorySnapshot` carry the working tree's already-generated files into the snapshot, so `Enter-TestRunLocation`'s priming
       import has less to materialise: the priming import is 34.3 s of the isolated case's 53.1 s (`packing.md`), and the case's own fixture
       is 9.8 s. Measure the priming import with and without the carried files first; land it only on a measured gain. Check:
       `Enter-TestRunLocation.Tests.ps1` and `New-RepositorySnapshot.Tests.ps1`, then `Invoke-TestFile` on `Invoke-TestFile.Tests.ps1` with
       its seconds before and after.
2. [ ] Give `Test-Spelling.ps1`'s whole-repository `cspell lint` a cache (`--cache` with its cache file under `out/`): the real-repository
       case is 15.2 s of `Test-Spelling.Tests.ps1`'s 25 s alone. Measure a warm run with and without the cache first; land it only on a
       measured gain. Check: `Invoke-TestFile` on `Test-Spelling.Tests.ps1`, with its seconds before and after.
3. [ ] Let `extension.js` in the track-lamps extension walk the disk once and reuse it across lamps in `hiddenPlan` and `census`: the
       every-file census case is 13.9 s of `TrackLamps.Tests.ps1`'s 34 s alone. Check: `Invoke-TestFile` on `TrackLamps.Tests.ps1`, green,
       with its seconds before and after, and the extension's own lamp-vector tests.

The plan closes on the user's full `Test-Automation` run inside 180 s.
