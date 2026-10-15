---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/tests/types/PipelineWatchdog.Tests.ps1.md
    kind: test-asset
    body_sha: "90d4d15352bf"
---

# automation/Catzc.Base.Timeouts/tests/types/PipelineWatchdog.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `foreach ($run in 1..200) {`.

```text
The limit is set to land around the moment each short pipeline returns, so across the runs the timer fires
before, during and after the caller disposes the watchdog and then the pipeline. A stop that reached a
disposed pipeline would throw on a thread-pool thread and end this process, not just fail the test.
```
