---
plan:
  status: active
  value: high
  reviewed: 2026-10-29
  class: feature
  targets: [pwsh/Base.QualityGates, python, go/tests, bash/tests]
---

# Test run inside its budget

The full `Test-Automation` run is green but takes 206.1 s against its 180 s budget (`tests.run_seconds`), in run
`out/test-automation/20261030-095709` on the measured defaults of 8 workers and 6 greedy files at once (measurements in
`out/test-run-budget/packing.md`); the prewarm holds every worker back its first 19 s. The limit stays; the tests and the run's overhead get
faster (ADR-AUTO-TEST).

## Open steps

1. [ ] Run the bicep build-cache prewarm (`BicepBuildCache.Prewarm.ps1`) inside the pool instead of before it: it holds every worker back 19
       s, and a test that needs a cache entry already waits on that entry's lock in `Build-Bicep`. Measure the full run's wall clock with
       the prewarm before and inside the pool first; land it only on a measured gain. Check: the Azure.Templates module run, green, then a
       full `Test-Automation` run with its wall clock against 206.1 s.

The plan closes on the user's full `Test-Automation` run inside 180 s.
