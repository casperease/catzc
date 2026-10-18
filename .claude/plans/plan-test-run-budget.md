---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Engines, pwsh/Catzc.Base.Timeouts/configs]
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
- [ ] Re-check that Invoke-TestFile no longer shares a shard with Test-Formatting, read from the shard manifest of the final session's full
      run (task-user-runs-and-commits, last step) and of any run the user made on their own; this plan starts none (check: the manifests in
      out/test-automation place them apart). Watch, reported 2026-10-18 by session catzc-93: a first Invoke-TestFile of
      Get-TimeoutSeconds.Repository.Tests and Get-EngineCaseTable.Tests crashed after 3 s with empty stderr before any test ran; the shard
      script run directly and a second Invoke-TestFile passed (likely an import race). The user's last full run took 347 s against the
      180 s `tests.run_seconds` budget.
- [x] Next three files by cost, one at a time via the test-optimization agent (check: same assertions, lower time). Done 2026-10-18 with no
      edit: each file is about 14 s alone (14.3, 13.9 and 14.8 s against 33.6, 32.9 and 31.3 s in the full run), each test is one real build
      the test exists to prove, so no file has a lever inside it; about half of each full-run figure is contention between build-heavy
      greedy files. The lever is scheduling, measured by the shard step above; the options are in task-test-run-budget step 4.

## Refs

- pwsh/Catzc.Base.Timeouts/configs/timeouts.yml
- docs/adr/repository/uniform-formatting.md
