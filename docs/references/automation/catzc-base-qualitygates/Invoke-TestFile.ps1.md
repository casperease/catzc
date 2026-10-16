---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4be740e3de33"
---

# automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'`, written with `#`.

```text
A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/. Earlier runs whose
process died never stamped their run.json: mark them 'abandoned' first, as Test-Automation does.
```

## comment:2

Above `$location = Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -RunDirectory...`, written with `#`.

```text
Claim where the run executes — in place, or in a snapshot when another run holds the working folder
(Enter-TestRunLocation owns the why). The worker inherits CATZC_TEST_RUN_LOCATION_HELD, as Test-Automation's
workers do, so a test that drives Invoke-TestFile for real inside this run runs in place in this run's
root rather than claiming a location of its own.
```

## comment:3

Above `$effectiveMaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested...`, written with `#`.

```text
Every tier asked for that the location allows: in place that includes the L3 system tests; a snapshot skips
them and says so (Resolve-TestRunMaxLevel owns the why). L4 only when asked for.
```

## comment:4

Above `$files = if ([System.IO.File]::Exists($shard.FilesPath)) {`, written with `#`.

```text
Every failure's message, on the console at every -Output level (the worker's own output does not reach a
redirected console): failed tests from the rows, and a file that failed before its tests ran from the
files sidecar.
```
