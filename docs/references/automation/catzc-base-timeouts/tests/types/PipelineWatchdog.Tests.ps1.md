---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/tests/types/PipelineWatchdog.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9a2deaa257cc"
---

# automation/Catzc.Base.Timeouts/tests/types/PipelineWatchdog.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($run in 1..200) {`, written with `#`.

```text
The limit is set to land around the moment each short pipeline returns, so across the runs the timer fires
before, during and after the caller disposes the watchdog and then the pipeline. A stop that reached a
disposed pipeline would throw on a thread-pool thread and end this process, not just fail the test.
```
