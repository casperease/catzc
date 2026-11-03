---
plan:
  status: active
  value: high
  reviewed: 2026-11-03
  class: feature
  targets: [pwsh/Base.QualityGates, pwsh/Base.Overlay/tests]
---

# The full test run within its 240 s budget

`Test-Automation -Level 2` passes (2026-11-03 21:16: 11428 passed, 0 failed) and fails its budget, `tests.run_seconds: 240` in
`timeouts.yml`, at 357.8 s; the budget is never raised (the user, 2026-10-28; `test-speed`). Measured from
`out/test-automation/20261103-205425` (the results' start stamps and write times, the results XML):

- The critical path is `Consumer.L2.Tests.ps1` alone: it starts 55 s after the folder stamp and runs 306 s under the pool's load (109 s
  alone), 166 s of it the first `BeforeAll`, one install and one session child that installs the python workspace and the TypeScript types,
  runs every gate over the consumer root and the consumer's own `Test-Automation`; every other shard ends within 15 s of it.
- The phase before the pool is 38 s, of which `discovery` reads 25.8 s on a tree whose test files had not changed: the cache file holds 1175
  entries for 138 files and a warm call still costs 7 s in the session (11 s cold), the whole file read and 11464 rows materialised.
- The eight parallel shards run 192-286 s of suite time each (204-232 s in the 19:46 run), the machine saturated by 14 workers and their
  children.
- After that evening's landings (the discovery cache over the language folders, the janitor mutex, the store sweep per selection, the L3
  rule), the cold run of 22:30 (`out/test-automation/20261103-223037`, the first after a commit, every build selection rebuilt) read 293.5
  s: 51 s before the pool, `Consumer.L2` 242 s from the pool's first second and still the critical path, the parallel shards 172-222 s,
  `Import-Catzc` 64 s (144 s before), `Build-Modules.Bundles` 153 s (202 s before). The worker log keeps no `Write-Message` of a
  `BeforeAll`, so the phase line the file prints is not readable from a run folder; the file now writes `consumer-l2-phases.json` beside a
  worker's results (landed 2026-11-03), and alone it reads: the consumer root 13.7 s, git 1.6 s, the session child 58.8 s, of which the
  python workspace 3.7 s, TypeScript 3.0 s, the probe 2.7 s, the gates 11.8 s, the consumer's own `Test-Automation` 30.5 s.

## Decided

- The budget stays at 240 s; the next full run's wall clock in its `run.json` is the plan's exit, read from a fresh session (the protection
  skip is per session: `Clear-GlobSetProtection` or a new import runs everything).

## Open steps

- [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1`: its `BeforeAll` now times its phases (`Phases` on the session object, landed
      2026-11-03) but nothing keeps them; the phases are written as `consumer-l2-phases.json` beside the results when the worker's run
      folder is known (read `New-TestAutomationShardScript` for what a worker is handed and pass the folder on as one environment variable
      the test reads, else under `Get-OutputRoot`), and the warm full run decides the cut: when its wall clock is under 240 s the step
      closes with the numbers; when it is over, the largest phase of that run's file is cut only if it proves nothing a later case proves
      again (the planted gate case compares every gate's state before and after, so the first gate run stays), else the lever is the
      schedule, measured first (check: the next warm full run's folder holds `consumer-l2-phases.json`, and its `run.json` wall clock is
      under 240 s or the step's next cut is named from those numbers).

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-CACHE-CROSSSESSIONFILES
  ([caching](../../docs/drs/automation/caching.md)), the `test-speed` skill.
- The measurements: `out/test-automation/20261103-205425` and `20261103-211613` against `20261030-130223`.
