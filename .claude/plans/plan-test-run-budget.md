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

1. [ ] Build the three templates side by side in the bicep build-cache prewarm (`BicepBuildCache.Prewarm.ps1`), which builds them one after
       another today: 5.4-5.8 s, 5.5-6.2 s and 3.4 s of its 19-20 s, the rest its process start. Skipping the prewarm was slower (221.3 s
       against 206.1 s, `packing.md`), so it stays before the pool. Land it only on a measured gain. Check: the prewarm's own "Prewarm done"
       seconds before and after, then a full `Test-Automation` run with its wall clock against 206.1 s.

The plan closes on the user's full `Test-Automation` run inside 180 s.
