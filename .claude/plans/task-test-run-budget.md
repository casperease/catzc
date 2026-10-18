---
task:
  status: open
  plans: [plan-test-run-budget]
  value: medium
  blocked_on: step 1 reads the shard manifest of the final session's full run (task-user-runs-and-commits, last step); no run is asked for
  targets: [out/test-automation]
---

# Task: the full test run under its 180 s roof

The format cache stamp, the two-pass analyzer cache and the one-pool scheduler (greedy files take the first free slot, at most
`greedy_group_size` at once, the `greedy_apart` build files one at a time, serial last) are in the tree. Their wall-clock effect is read
from the user's next full run. The roof is a rule, not a target; this task proposes no full run, the user runs them (memory: user handles
commits and tests).

The baseline, from three manifests before the pool (the 347 s run is 20261018-153550, snapshot, -Isolated):

| Phase (shards)                       | 347.47 s | 264.55 s | 266.42 s | Driver in the 347 s run                                                                        |
| ------------------------------------ | -------- | -------- | -------- | ---------------------------------------------------------------------------------------------- |
| A: 0-4 in parallel                   | 114 s    | 113 s    | 129 s    | shard 1, 112.2 s (Get-AdrUsage.Tests 49.7 s); Test-Formatting 50.9 s                           |
| B: 5 and 6 in parallel               | 135 s    | 46 s     | 30 s     | shard 5 Test-ScriptAnalyzer.Tests 134.2 s (34.2 / 3.7 s); shard 6 Invoke-TestFile.Tests 52.8 s |
| C: 7-20 as 7 greedy pairs, in series | 88 s     | 95 s     | 96 s     | Language.Bridge pairs 19+20 (19.2 s), 17+18 (14.3 s); Import-Catzc 13.4 s                      |

Open for the user, outside any test file: one shared `az bicep build` per shipped template for the whole run, or the three builds of
`Get-BicepParameterModel.Shipped.Tests.ps1` in parallel in `BeforeAll`; a cheaper `Test-BuildArtifact` (one type-set build shared by the two
`Import-Catzc.Tests.ps1` calls).

## Steps

1. Read the final session's full run (`out/test-automation`): its wall clock and phase table against the baseline above, and whether
   `Invoke-TestFile.Tests.ps1` and `Test-Formatting.Tests.ps1` stay apart. Check: the table and the verdict recorded in the plan, no run
   started for it.
2. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
