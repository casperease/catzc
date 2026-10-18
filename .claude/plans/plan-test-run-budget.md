---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Engines, pwsh/Catzc.Base.Timeouts/configs]
---

# The full test run under its 180 s roof

The per-engine format cache stamp (ADR-REPO-FORMAT-CONFIGUREDFORMATTERS), greedy groups, the decayed duration maximum and the scheduler that
starts shards 5 and 6 and the greedy pairs as soon as phase A frees a slot are in the tree. The user's last full run took 347 s against the
180 s `tests.run_seconds` budget; the effect of the scheduler is read from the next full run.

## Why its value is medium

The roof is a rule, not a target, so the value is a suite that proves the same in less time. The user runs full suites; this plan proposes
none.

## Decided

- The snapshot test (`Invoke-TestFile`) and the config conventions test (0.77 s against 400 ms) stay as they are; what each spends is what
  it proves, and scheduling, not the files, is the lever. The user may decide otherwise.
- `Test-MarkdownTitle.Repository.Tests.ps1` (L1, integrity) takes 2.45 s warm and 3.68 s cold against the 2 s L1 limit, its one test reading
  every in-scope Markdown file, which is what it proves; the over-limit line is report-only. A stated per-test limit with its reason is the
  user's choice; nothing changes until then.
- The three costliest files (about 14 s alone each) have no lever inside them: each test is one real build; about half of their full-run
  figure is contention between build-heavy greedy files.
- Watch: a first `Invoke-TestFile` of `Get-TimeoutSeconds.Repository.Tests` and `Get-EngineCaseTable.Tests` once crashed after 3 s with
  empty stderr before any test ran; a second run passed (likely an import race).

## Open steps

- [ ] Read the final session's full run (`out/test-automation`), no run started for it: its wall clock and phase table against 347 s, phases
      B and C overlapping A, and `Invoke-TestFile.Tests.ps1` apart from `Test-Formatting.Tests.ps1` (task-test-run-budget step 1) (check:
      the table and the verdict recorded here).

## Refs

- pwsh/Catzc.Base.Timeouts/configs/timeouts.yml
- docs/adr/repository/uniform-formatting.md
