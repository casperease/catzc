---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLocationSummary.ps1.md
    kind: comment-page
    body_sha: "202abce5c3be"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLocationSummary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One reading of the location a worker run executed in — the run's location from Enter-TestRunLocation,
which Invoke-TestAutomationWorkers returns as its Location — in the two shapes its consumers need: a
one-line text for summary.md's Location line, and the run.json entries — `location` (the location's Mode,
'in-place' or 'snapshot') plus, for a snapshot, its provenance (path, source root, commit, change counts,
whether it was kept, and who held the working folder). No location (a fully protected run executed
nowhere, or the workers crashed) renders as empty text and no entries.
```
