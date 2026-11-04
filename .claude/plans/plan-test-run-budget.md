---
plan:
  status: blocked
  value: high
  reviewed: 2026-11-04
  waits_on: the warm full run in task-user-runs-and-commits, whose run.json wall clock is this plan's exit
  class: feature
  targets:
    [
      pwsh/Base.QualityGates,
      pwsh/Base.Overlay/tests,
      pwsh/Base.Exporter/tests,
      docs/drs/automation/test-automation.md,
      .claude/skills/catzc-run,
    ]
---

# The full test run within its 240 s budget

`Test-Automation -Level 2` passes (2026-11-04 02:44: 0 failed) and fails its budget, `tests.run_seconds: 240` in `timeouts.yml`; the budget
is never raised (the user, 2026-10-28; `test-speed`). Measured from `out/test-automation/20261104-024433` (its `run.json` shard table, the
`files-shard-*.json` and `consumer-l2-phases.json`), a cold run one hour after the commit of 01:40, against the cold run of 22:30 the night
before (`20261103-223037`):

- The wall clock is 348.3 s (293.5 s the night before). The pool is 14 slots: 8 parallel shards (ending 249-301 s) and 6 greedy slots that
  46 greedy files take as they free; the last greedy file starts at 333 s. The slot-seconds are 4820 (2179 parallel, 2641 greedy), 3746 the
  night before; 4820 over 14 slots is 344 s, so the pool is packed and no order of the same files wins.
- The costliest greedy files, pooled seconds (the night before in brackets): `Consumer.L2` 309 (260), `Build-Modules.Bundles` 220 (170),
  `Invoke-TestFile` 213 (132), the language bridge 201 and 177 (158 and 108), `Export-Catzc.Install` 151 (138), `Import-Catzc` 94 (81),
  `Build-Modules.Languages` 70 (66), `Consumer.NoRepository.L2` 66. Every file stretched about 1.3 times between the two cold runs, the
  parallel shards too (2179 against 1648 slot-seconds), so the growth is load, not new tests.
- `consumer-l2-phases.json`, pooled: the consumer root 47.7 s (13.7 alone), git 2.9, the session child 116.0 (58.8 alone), of which the
  python workspace 12.2, TypeScript 6.4, the probe 4.5, the gates 22.4, the DRS 0.2, the consumer's own `Test-Automation` 54.6.

## Decided

- The budget stays at 240 s, and re-measuring it from a run over it is a raise by another name, so it is not taken (the user, 2026-10-28: a
  run past its roof means faster tests). The lever is the slot-seconds of the costliest greedy files, in cost order, each by the
  `test-speed` skill: measure first (ADR-AUTO-TEST-MEASUREFIRST), one import or one worker per input (ADR-AUTO-TEST-ONEIMPORTPERCASE),
  set-up once (ADR-AUTO-TEST-SETUPONCE), nothing a file proves lost.
- The bundles test's probe calls the cheapest all-optional `Get-*` of each shipped module (landed 2026-11-04: 73 s to 65 s alone); what is
  left of its load is `Get-ToolsStatus`, the one `Get-*` of `Tooling.Provisioning`, 15 s in three bundle children for `winget list` and the
  version probes. It stays: a parameter added for a test's sake or a probe exemption would weaken what the load proves.
- The `Invoke-TestFile` test's real-worker block runs its three failing fixtures through one worker (landed 2026-11-04: 92 s to 80 s alone);
  its snapshot case keeps 43 s of its 55 s in `Enter-TestRunLocation` (the cache and hook copy, the priming import, the offline `uv sync`),
  which is the snapshot run the case proves, and the priming import stays by the decision of 2026-11-03.
- The install test stays as it is (measured 2026-11-04: 52 s alone against 151 s pooled, so 100 s of its pooled time is contention): one
  build shared by both root kinds, one load per kind, the cases reading stored state; the 6 s an already-current `Install-Catzc` spends is
  its render child (`Install-Catzc.ps1:99`), which also repairs a drifted root file on a no-op install, and that behaviour is not traded for
  12 s.
- `Consumer.L2`'s edit, render and planted-gate cases share one second fresh session built in `BeforeAll`, the `SecondChild` phase (landed
  2026-11-04: 157 s to 140 s alone, 22 cases unchanged); the orphan and shell cases keep their own children, since one must fail the import
  and the other proves the bash entry; the consumer root phase (18 s alone) is a rebuild only because the tree is dirty, and the builder's
  store reuse already covers a clean tree.
- `Consumer.L2`'s largest phase, the consumer's own `Test-Automation` (54.6 s pooled), stays: it alone proves that a consumer's tests run
  through the bundle's handlers (ADR-AUTO-CONSUMER-CATZCGATES), and no later case proves it again. The planted gate case compares every
  gate's state before and after, so the first gate run stays too.
- The warm full run that closes this plan is the user's: a full run exceeds every call roof an agent has (340 s in the background), and
  ADR-REPO-AI-SMALLTESTSDIRECTLY names `Test-Automation` the user's. Its `run.json` wall clock, read from a fresh session, is the exit; its
  step is in task-user-runs-and-commits.
- The `catzc-run` skill carries the two lines the drones re-learned on 2026-11-03 (decided 2026-11-04): the run lock refuses a call whose
  wait exceeds its budget, so commands chain into one call; a `BeforeAll`'s `Write-Message` never reaches a worker log, so a test that
  reports numbers writes a file beside its results.
- The test-automation record states the default top tier once, from `[TestTiers]::DefaultTop`, and drops the claim that both runs execute in
  CI on every push, which no pipeline does: a CI is `Test-QualityGates` then the source `Test-Automation` until a pipeline runs
  `Test-CatzcBuild` (moved here from plan-build-mode, decided 2026-11-04).

## Open steps

No open step: every cut this round names has landed, and the plan waits on the warm full run (task-user-runs-and-commits). Under 240 s
closes it; over it, the run's shard table and `consumer-l2-phases.json` name the next cut, written here as a step.

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-CACHE-CROSSSESSIONFILES
  ([caching](../../docs/drs/automation/caching.md)), the `test-speed` skill.
- The measurements: `out/test-automation/20261104-024433` against `20261103-223037`, and `20261103-205425` against `20261030-130223`.
