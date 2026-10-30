---
plan:
  status: active
  value: high
  reviewed: 2026-10-30
  class: feature
  targets: [pwsh/Base.QualityGates, js/track-lamps, docs/drs/design]
---

# Test-result markers that follow every run

The track lamps show a test file red from `out/test-results/<test file>.failed`, which only `Invoke-TestFile` writes or clears
(`Invoke-TestFile.ps1:125-133`); `Test-Automation` goes through `Invoke-TestRun`, which never calls `Write-TestResultMarker`, so a green
full run leaves a peer's old marker standing and the editor shows a failure no run still has. The lamps judge a marker by its file time
against the module's files (`facts.js:214-239`), so a failure lapses only on an edit. Eight markers stood on 2026-10-30, the oldest from
2026-10-26, one for a non-test file (`Language.Bridge.ps1`). The goal: every runner records each file's outcome and the scope it ran, the
newest result that covers a failure clears it, the problem names who failed it, and orphans go, with nothing for the user to do.

## Facts the design rests on

- A run's scope narrows a file: `-MinLevel`/`-MaxLevel` and `-Category` exclude tags (`Get-TestExcludeTag`), `-Rule` includes tags, and
  `-FullNameFilter` picks tests. A green run at L0-L2 says nothing about the same file's L3 tests, so a pass clears a failure only when its
  scope covers the failed run's scope.
- Out-of-scope files come back as `NotRun` rows (`Invoke-TestRun.ps1:194`) and protected modules are skipped (`Select-ProtectedTestFile`);
  neither ran, so neither writes a result.
- A container error fails a shard with no failed row (`FailedShardLabels`); every file of that shard counts as failed, never passed.
- An isolated run executes in a snapshot; its paths map back with `Convert-TestRunLocationPath -ToSource`, and the result is written under
  the working folder's `Get-OutputRoot`, after the location is left.
- A run that started before an edit and ended after it is older than the edit. The lamps compare the run's start time, stored in the result,
  with the module's file times, never the result file's own time.
- Peers run concurrently: a result is written to a temporary name and moved into place, so a reader never sees half a file.

## Open steps

1. [ ] Make `Write-TestResultMarker` (`pwsh/Base.QualityGates/private/Write-TestResultMarker.ps1`) write one JSON result per test file,
       `out/test-results/<test file>.result.json`: `result` (`failed` or `passed`), `failedCount`, `startedAt` (the run's start), `runner`
       (`Invoke-TestFile` or `Test-Automation`), `pid`, `isolated`, `scope` (`minLevel`, `maxLevel`, `category`, `rule`, `filtered`) and
       `runDirectory`; written by temporary file and move. A filtered run (`-FullNameFilter` or `-Rule`) writes a failure only. Delete the
       `.failed` shape in the same change. Check: `Invoke-TestFile` on `pwsh/Base.QualityGates/tests/Write-TestResultMarker.Tests.ps1` with
       cases for a pass, a fail, a filtered pass and every field.
2. [ ] Call `Write-TestResultMarker` from `Invoke-TestRun` (`pwsh/Base.QualityGates/private/Invoke-TestRun.ps1`) after the rows return: one
       outcome per file that ran (no `NotRun` row, no protected module), a file in a failed shard counted as failed, paths mapped
       `-ToSource`, the run's scope and start passed in. Check: `Invoke-TestFile` on a new
       `pwsh/Base.QualityGates/tests/Write-TestResultMarker.Automation.Tests.ps1` with a widget/gadget outcome set, a shard failure and a
       NotRun row.
3. [ ] Pass `Invoke-TestFile`'s own start and scope to the same writer (`pwsh/Base.QualityGates/Invoke-TestFile.ps1:133`). Check:
       `Invoke-TestFile` on `pwsh/Base.QualityGates/tests/Write-TestResultMarker.Tests.ps1`.
4. [ ] At the start of an unfiltered `Invoke-TestRun`, delete every result whose test file is gone or is not a test file, and every old
       `.failed` file. Check: a case in `pwsh/Base.QualityGates/tests/Write-TestResultMarker.Automation.Tests.ps1` that seeds an orphan, a
       `.failed` file and a live result, and sees only the live result stay.
5. [ ] In the lamps, `markerFacts` (`js/track-lamps/facts.js`) reads `*.result.json`: a test file is failed when its result says `failed`
       and its `startedAt` is newer than the test file and every file of its module. A `passed` result in the same file has replaced the
       failure on disk only when its scope covered it (step 1's writer keeps a failure that a narrower pass cannot clear). An unreadable
       result counts as no result. Check: `js/track-lamps/tests/facts.test.js` cases for failed, failed-then-passed, a narrow pass that
       keeps the failure, a run started before an edit, and an unreadable file; the lamp vectors stay green.
6. [ ] Show the provenance in the problem (`js/track-lamps/engine.js:202`): "4 failed in Invoke-TestFile, L0-L2, run 20261029-231202-c7f456
       (pid 1234)". Check: a `js/track-lamps/tests/stub-editor.test.js` case asserting the message; `Invoke-TestFile` on
       `pwsh/Base.VSCode/tests/TrackLamps.Tests.ps1`, green.
7. [ ] Name the new shape where the old one is named: `pwsh/Base.Reports/configs/output-formats.yml:58`,
       `docs/drs/design/repository-filters.md:69`, `docs/references/pwsh/base-quality-gates/private/write-test-result-marker.md`, and the
       header comments of `js/track-lamps/extension.js:9` and `js/track-lamps/facts.js:2,207`. Check: the Grep tool finds no `\.failed`
       outside `out/`.

## Open questions

- Simplify proposal, not yet answered: one sentence in the `catzc-run` skill that a background `Invoke-CatzcCommand` call is waited on by
  its completion notification alone (a `tail --pid` waiter is denied as compound), and one line in the `Write-TestResultMarker` reference
  page naming every runner that writes results, so the next session finds the writers without a search.

## Decided

- The scope check lives in the writer, not the reader: a pass whose scope does not cover the stored failure's scope leaves the failure, so
  the file on disk is always the answer and the lamps stay a reader of existence, time and one field.
- JSON over a text first line: the fields are read by two languages, and `output-formats.yml` already registers JSON outputs.
