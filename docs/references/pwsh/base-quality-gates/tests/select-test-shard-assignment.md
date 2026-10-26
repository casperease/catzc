# pwsh/Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1

The L0 logic test of `Select-TestShardAssignment`, the longest-first scheduling of the parallel test files over the worker shards. The
fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Worked cases

In the two-shard case, `widget` takes 9 s on one shard, and `sprocket` (5 s) with `gizmo` (4 s) take the other, 9 s each. The two 1 s files
then go one to each shard, the first to the lower-numbered shard on the tie, which gives 10 s and 10 s.

In the three-shard case with unknown durations, the median of 1 s and 9 s is 9 s, the upper middle. So `sprocket` ties `widget` and keeps
its given order after it.
