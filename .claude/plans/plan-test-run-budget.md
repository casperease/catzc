---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [automation/Catzc.Base.QualityGates, automation/Catzc.Base.Engines, automation/Catzc.Base.Timeouts/configs]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-test-run-budget.md"
    folder: plans
    name: plan-test-run-budget
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-REPO-FORMAT#8
---

# The full test run under its 180 s roof

Last measured run took 265.8 s. Landed: greedy groups (greedy_group_size) and a decayed maximum in the duration history so a cold spike is
not forgotten. The largest remaining lever is the format cache stamp.

## Why its value is medium

Every tools.yml pin edit reformats the whole repository for every engine, 58 to 76 s for PowerShell alone. The roof is a rule, not a target,
so the value is a suite that proves the same in less time. The user runs full suites; this plan proposes none.

## Decided

- 2026-10-18: the snapshot test (`Invoke-TestFile`, item 2) and the config conventions test (item 3) stay as they are; what each spends is
  what it proves, and scheduling, not the files, is the lever. The user may decide otherwise.
- 2026-10-18, re-measured once `Get-MarkdownScope` landed: `Test-MarkdownTitle.Repository.Tests.ps1` (L1, integrity) takes 2.45 s warm and
  3.68 s cold against the 2 s L1 limit, its one test reading every in-scope Markdown file, which is what it proves; the over-limit line is
  report-only. Like item 3, a stated per-test limit with its reason is the user's choice; nothing changes until then.

## Needed docs

- ADR-REPO-FORMAT: an engine's cache stamp contains its own tool pin and its own settings files, nothing else.
- Per-test limits, if any, are stated with their reason (the config conventions test, 0.77 s against 400 ms, stays).

## Needed tests

- An unrelated pin edit leaves another engine's cache warm.
- Every declared stamp input invalidates the cache (the risk is a stale result from a missing input).
- Two measured full runs after the shard change, compared against the 265.8 s table.

## Open steps

- [x] Decide the stamp rule (check: the ADR sentence exists). Decided 2026-10-18 (D08): an engine's stamp contains its own tool pin and its
      own settings files, nothing else; the sentence and the tests are task-test-run-budget steps 1 and 2.
- [x] Change the stamp, add both tests (check: Test-Formatting tests pass cold and warm). Done 2026-10-18, already in the tree: each engine
      lists `tools.yml#<tool>` keys and `Get-FormatEngineStamp` hashes each key alone (ADR-AUTO-CACHE#10); its 13 tests hold both cases and
      pass, and ADR-REPO-FORMAT#8 states the stamp. `Test-Formatting.Tests.ps1` is 4 of 5 cold and warm; its integrity case fails on
      unformatted working-tree files only.
- [ ] Re-check that Invoke-TestFile no longer shares a shard with Test-Formatting after two runs (check: the shard manifests of two runs
      place them apart).
- [x] Next three files by cost, one at a time via the test-optimization agent (check: same assertions, lower time). Done 2026-10-18 with no
      edit: each file is about 14 s alone (14.3, 13.9 and 14.8 s against 33.6, 32.9 and 31.3 s in the full run), each test is one real build
      the test exists to prove, so no file has a lever inside it; about half of each full-run figure is contention between build-heavy
      greedy files. The lever is scheduling, measured by the shard step above; the options are in task-test-run-budget step 4.

## Refs

- the full draft is carried below (formerly out/plan-test-run-budget.md)
- automation/Catzc.Base.Timeouts/configs/timeouts.yml
- docs/adr/repository/uniform-formatting.md

## Carried: out/plan-test-run-budget.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

## Plan: bring the full test run under its 180 s budget

Status as of 2026-10-15. The last measured full run (`out/test-automation/20261015-113336`) took 265.8 s against `tests.run_seconds` 180 s.
Figures below come from that run and from the `test-optimization` agent's report; the agent's timings were taken on a loaded machine, so
treat them as noisy and re-measure before acting.

## Landed in this round

- Greedy phase runs in groups: `greedy_group_size` in `test-policy.yml` (default 2, declared once on `TestPolicyConfig`), overridable with
  `Test-Automation -GreedyGroupSize`.
- Shard split: the duration history now keeps a decayed maximum per file (`duration_decay`, default 0.9), so a cold-cache spike is not
  forgotten after one warm run. Cause found: `Test-Formatting.Tests.ps1` was recorded at 9.2 s (warm) but takes 94 s cold, so the assignment
  never isolated it and it shared a shard with `Invoke-TestFile.Tests.ps1` (126 s shard).
- Verify: run the full `Test-Automation` twice. The first run after this change still uses the old history, so only the second run shows the
  new balance. Compare shard durations against the table in the 265.8 s run.

## Open decisions

### 1. Per-engine format cache stamp (largest lever, needs an ADR decision)

- Problem: every engine's cache stamp includes `tools.yml`, so any pin edit anywhere makes every engine reformat the whole repository
  (powershell about 58-76 s, markdown about 35 s, csharp about 10 s cold). Warm, the same test takes about 7.5 s.
- Proposal: stamp each engine with only its own tool's pin and its own settings files.
- Steps: read the formatting ADR and `ADR-REPO-FORMAT`; find where the stamp is built; decide what an engine's stamp must contain; change
  it; add a test that an unrelated pin edit leaves another engine's cache warm; measure a cold and a warm run.
- Risk: a stamp that leaves out an input would serve stale results. The test must also prove that each declared input does invalidate.

### 2. Snapshot test (`Invoke-TestFile`, about 15 s unloaded)

- Recommendation: leave the test. Its two importer spawns and the snapshot are what it proves.
- Scheduling is the lever, covered by the decayed history above. Re-check after two full runs that it no longer shares a shard with
  `Test-Formatting`.

### 3. Config conventions test (about 0.77 s against the 400 ms L0 limit)

- Recommendation: leave it. The cold parse of 57 configs is what it proves, and re-tiering it only to escape the limit is not allowed.
- The over-limit line is report-only (`-EnforceTimings` is not on). If it should go, the choice is a stated per-test limit with its reason,
  a decision for the user.

### 4. Next files by cost (measure, then optimize one file at a time)

| File                                                                    | Seconds in the 265.8 s run |
| ----------------------------------------------------------------------- | -------------------------- |
| `Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` | 33.6                       |
| `.internal/tests/Import-Catzc.Tests.ps1`                                | 32.9                       |
| `Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1`                  | 31.3                       |
| `Test-BuildArtifact` tests (25.0, 20.9, 11.9, 7.9 s)                    |                            |

Hand these to the `test-optimization` agent after the first two re-runs, so it measures against the new balance.

### 5. Markdown title test (3.3 s, L1 limit 2 s)

Blocked on the other session's `Get-MarkdownScope` refactor. Re-measure once it lands.

## Order

1. Run all tests twice and record shard durations and wall clock.
2. If still over 180 s: item 1, then item 4.
3. Items 2 and 3 stay as they are unless the user decides otherwise.
