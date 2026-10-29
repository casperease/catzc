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

1. [ ] Read the next full run's `run.json` `shards` after the carried agent hooks and the spelling cache: where the parallel shards and the
       greedy files end against 180 s, and the next slowest files from `durations.json`, written to `out/test-run-budget/packing.md`; plan
       the next lever from that measurement. Check: the shard ends in `packing.md` match `run.json`.

The plan closes on the user's full `Test-Automation` run inside 180 s.
