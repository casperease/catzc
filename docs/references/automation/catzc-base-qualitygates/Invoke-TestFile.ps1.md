---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md
    kind: comment-page
    body_sha: "6de50f320dab"
---

# automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:11

Above `$reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'`.

```text
A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/. Earlier runs whose
process died never stamped their run.json: mark them 'abandoned' first, as Test-Automation does.
```

## comment:12

Above `$location = Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -RunDirectory...`.

```text
Claim where the run executes — in place, or in a snapshot when another run holds the working folder
(Enter-TestRunLocation owns the why). The worker inherits CATZC_TEST_RUN_LOCATION_HELD, as Test-Automation's
workers do, so a test that drives Invoke-TestFile for real inside this run runs in place in this run's
root rather than claiming a location of its own.
```

## comment:13

Above `$effectiveMaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested...`.

```text
Every tier asked for that the location allows: in place that includes the L3 system tests; a snapshot skips
them and says so (Resolve-TestRunMaxLevel owns the why). L4 only when asked for.
```

## comment:14

Above `$files = if ([System.IO.File]::Exists($shard.FilesPath)) {`.

```text
Every failure's message, on the console at every -Output level (the worker's own output does not reach a
redirected console): failed tests from the rows, and a file that failed before its tests ran from the
files sidecar.
```
