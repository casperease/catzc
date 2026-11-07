---
plan:
  status: blocked
  value: high
  reviewed: 2026-11-04
  waits_on: the user's warm source run under 240 s (task-user-runs-and-commits), now that the post-build split has landed
  class: feature
  targets:
    [
      pwsh/Base.QualityGates,
      pwsh/Base.Overlay/tests,
      pwsh/Base.Exporter/tests,
      pwsh/Base.Config/configs/configs.yml,
      docs/drs/automation/test-automation.md,
      docs/drs/automation/test-artifact-languages.md,
      docs/drs/automation/execution-engines.md,
      docs/references/pwsh/base-quality-gates/configs/test-policy.md,
      .claude/skills/catzc-run,
    ]
---

# The full test run within its 240 s budget

`Test-Automation -Level 2` passes and fails its budget, `tests.run_seconds: 240` in `timeouts.yml`; the budget is never raised (the user,
2026-10-28; `test-speed`). Measured from the `run.json` shard tables, the `files-shard-*.json`, the results XML and
`consumer-l2-phases.json` of the runs under `out/test-automation/`:

- The cold run of 02:44 (`20261104-024433`, one hour after the commit of 01:40) read 348.3 s (293.5 s the cold run of 22:30 the night
  before). The pool is 14 slots: 8 parallel shards and 6 greedy slots that 46 greedy files take as they free. The slot-seconds were 4820
  (2179 parallel, 2641 greedy); 4820 over 14 slots is 344 s, so the pool is packed and no order of the same files wins.
- The user's run of 16:23 (`20261104-162304`, three minutes after the commit of 16:20, this round's four cuts in) read 292.8 s, 0 failed.
  The slot-seconds are 4019 (1905 parallel, ending 220-268 s; 2114 greedy); 4019 over 14 slots is 287 s, so the pool is still packed, and
  the budget needs at most about 3360 slot-seconds of work. The critical greedy files, pooled: `Consumer.L2` 233 (140 alone), the python
  bridge of `Base.Repository` 161 and of `catzc_diagrams` 141, `Invoke-TestFile` 162 (80 alone), `Export-Catzc.Install` 122 (52 alone),
  `Build-Modules.Bundles` 109 (65 alone), the go bridge of `Base.Repository` 89. A file runs 1.7 to 2.4 times slower pooled than alone, the
  14 workers and their children sharing 20 processors.
- The user's BVT by hand of 2026-11-06 (`20261106-000236`, `20261106-001114`), the post-build split in: the warm source run read 217.6 s,
  under the roof for the first time, with one red case; the first source run 283.5 s with four; the build event 101.6 s; the post-build run
  refused to start, rightly, since `base` had no stored build at the tree's stamp. The red cases were three faults of concurrent writers and
  one of load: the import janitor's tool sync writing `out/cache/session-tools.json` in place (three python cases), the snapshot copying
  another writer's in-flight `.tmp` file from `out/cache` (the snapshot case), and a git listing killed at 3 s in the spelling test under
  the cold pool (one occurrence, left).
- The user's run of 19:19 (`20261104-191938`, 75 s after the commit of 19:18, so cold again) read 305.5 s, 0 failed: 4202 slot-seconds (1960
  parallel, 2242 greedy), packed at 300 s; the top bridge 116 pooled (161 before the cut), but every other top file 10 to 15 percent above
  16:23 (`Consumer.L2` 255, `Invoke-TestFile` 193, `Export-Catzc.Install` 143, `Build-Modules.Bundles` 124). Across five cold runs the
  slot-seconds read 4820, 4019, 4383, 4202: the band between cold runs is wider than any one cut, and no warm run exists yet.
- `Invoke-ModuleBuild` takes its build lock on the store build root, one per selection and source stamp (landed 2026-11-04): a second
  builder of the same selection waits and reuses the first's stored build, whatever its destination.
- The user's run of 17:21 (`20261104-172142`, one minute after the commit of 17:20, the engine cut in) read 317.7 s with two red cases fixed
  since (the plan's own engine wording, the lock-wait race in `Invoke-CatzcCommand.Tests.ps1`): 10729 tests, 709 fewer, the costliest bridge
  down to 84 pooled; but the cold rebuilds and the load took `Build-Modules.Bundles` to 238 pooled (109 the run before), `Consumer.L2` to
  295 (233) and `Export-Catzc.Install` to 158 (122), and the greedy slot-seconds rose to 2383 (2114). Run-to-run noise between cold runs is
  of the same size as a cut, so only the warm second run measures one.
- `consumer-l2-phases.json` of 16:23, pooled: the consumer root 53.3, git 2.9, the session child 105.5 (the python workspace 9.9, TypeScript
  6.3, the probe 4.2, the gates 19.5, the DRS 0.2, the consumer's own `Test-Automation` 51.6), the second child 31.8.
- The language bridge ran 12 shards for about 620 pooled slot-seconds: each Go and Python test folder under every engine, each bash folder
  under bash, each JavaScript folder under pwsh. The POSIX engines' runs of a folder re-run the same tests through the dispatcher, one pwsh
  start and one import per command, which is why they cost more than the pwsh run.
- Fresh cats sessions are spawned at 58 call sites in 22 test files, about 10 s each alone; the per-file collapse to one import per input is
  done, the repetition across files is structural.

## Decided

- The budget stays at 240 s, and re-measuring it from a run over it is a raise by another name, so it is not taken (the user, 2026-10-28: a
  run past its roof means faster tests). Per-file speed is done for this round; what remains is removing duplicate proof (the user,
  2026-11-04: "look at things to cut that have no verification value"), under ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS and
  ADR-AUTO-TEST-FEWINTEGRATIONTESTS, never a test that proves something nothing else proves.
- **The engine runs of the black-box tests collapse to one proof** (the user, 2026-11-04). The POSIX dispatcher is one mechanism, so one
  test folder run under every engine proves it, and every other folder's POSIX-engine runs prove it again. The test policy names that
  folder, `engine_proof` in `test-policy.yml`, shipped as `go/tests/baserepository` (the smallest three-engine folder, 89 s pooled for three
  engines); a Go or Python folder not named runs under pwsh only; bash folders stay under bash and JavaScript under pwsh. The default on the
  type is the empty list; the shipped value's reason is the comment above the key and the config page, not a registry `differs` entry, since
  `ConfigDefaultDifference.Compare` compares scalar keys only and `Test-ShippedConfigs` refuses a `differs` on a list (a known gap of that
  gate, not opened this round). ADR-AUTO-TESTLANG-BLACKBOX states the rule, and the execution-engines record's prose and consequence follow
  it. Landed 2026-11-04. Expected: the python bridges fall from 161 and 141 pooled to about a third, about 200 slot-seconds less; the pool
  then packs at about 270 s, so this cut alone does not reach 240 s, and the next duplicate proof is named from the warm run after it.
- `Consumer.L2`'s own `Test-Automation` stays (asked 2026-11-04): a language test folder runs only through `Test-Automation`, so the proof
  that the bundle's handlers run a consumer's language tests needs that entry; it already runs with `-Workers 2 -GreedyGroupSize 2`, so its
  pool has no lever left. The planted gate case compares every gate's state before and after, so the first gate run stays too.
- Not taken this round, as mechanism work rather than cuts: the 58 fresh-session sites across files, and the base bundle built three times
  (the bundles, install and consumer tests) because the builder's store reuses only on a clean tree.
- The bundles test's probe calls the cheapest all-optional `Get-*` of each shipped module (landed 2026-11-04: 73 s to 65 s alone); what is
  left of its load is `Get-ToolsStatus`, the one `Get-*` of `Tooling.Provisioning`, 15 s in three bundle children for `winget list` and the
  version probes. It stays: a parameter added for a test's sake or a probe exemption would weaken what the load proves.
- The `Invoke-TestFile` test's real-worker block runs its three failing fixtures through one worker (landed 2026-11-04: 92 s to 80 s alone);
  its snapshot case keeps 43 s of its 55 s in `Enter-TestRunLocation` (the cache and hook copy, the priming import, the offline `uv sync`),
  which is the snapshot run the case proves, and the priming import stays by the decision of 2026-11-03.
- The install test stays as it is (measured 2026-11-04: 52 s alone against 151 s pooled): one build shared by both root kinds, one load per
  kind, the cases reading stored state; the 6 s an already-current `Install-Catzc` spends is its render child (`Install-Catzc.ps1:99`),
  which also repairs a drifted root file on a no-op install, and that behaviour is not traded for 12 s.
- `Consumer.L2`'s edit, render and planted-gate cases share one second fresh session built in `BeforeAll`, the `SecondChild` phase (landed
  2026-11-04: 157 s to 140 s alone, 22 cases unchanged); the orphan and shell cases keep their own children, since one must fail the import
  and the other proves the bash entry.
- Fixed on 2026-11-06, each with its test: `Sync-SessionTools` writes its cache file through a temp file and one move and skips a lost race;
  `Enter-TestRunLocation` copies the cache file by file, skipping `.tmp` files and a file that goes away; `Save-BuildToStore` throws when
  its move into the store fails and no other build holds the stamp, where it returned in silence before; `Get-BuildSourceStamp` throws when
  a git listing fails, where it stamped a different tree before. No retry on the store move (ADR-AUTO-RETRY-LASTRESORT): the throw reports
  first, and a retry wrapper follows only on evidence of a transient handle. A dry run, a build and a dry run of `base` read one stamp with
  the record present.
- The warm full run that closes this plan is the user's: a full run exceeds every call roof an agent has (340 s in the background), and
  ADR-REPO-AI-SMALLTESTSDIRECTLY names `Test-Automation` the user's. Its `run.json` wall clock, read from a fresh session, is the exit; its
  step is in task-user-runs-and-commits.
- The `catzc-run` skill carries the two lines the drones re-learned on 2026-11-03 (landed 2026-11-04): the run lock refuses a call whose
  wait exceeds its budget, so commands chain into one call; a `BeforeAll`'s `Write-Message` never reaches a worker log, so a test that
  reports numbers writes a file beside its results.
- The test-automation record states the default top tier once, as the `DefaultTop` constant of the `TestTiers` type (an automation record is
  engine-neutral, so no pwsh type literal: `Test-DrsEngineNeutrality`), and drops the claim that both runs execute in CI on every push,
  which no pipeline does (landed 2026-11-04).

## Open steps

No open step. The budget question is answered (the user, 2026-11-04 evening): the tests split into a source group and a post-build group and
the builds become events of their own, plan-post-build-tests. `tests.run_seconds` stays 240 s and is the source run's; this plan closes when
the user's source run, after that plan lands, reads under 240 s in its `run.json`; over it, the next cut inside the source group is named
here from that run.

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-TESTLANG
  ([test-artifact-languages](../../docs/drs/automation/test-artifact-languages.md)), ADR-AUTO-ENGINE
  ([execution-engines](../../docs/drs/automation/execution-engines.md)), ADR-AUTO-CACHE-CROSSSESSIONFILES
  ([caching](../../docs/drs/automation/caching.md)), the `test-speed` skill.
- The measurements: `out/test-automation/20261104-162304`, `20261104-145159` and `20261104-024433` against `20261103-223037`.
