---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationWorkerSummary.ps1.md
    kind: reference
    body_sha: "32b5c15f5832"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationWorkerSummary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders a framed section (Write-Header / Write-Footer) with one table row per worker, ordered by each
worker's wall-clock start time (queue number — the submission order — stays visible in the # column,
so a pool that starts workers out of order still reads truthfully). Each row carries the worker's file
and test tallies, its start offset on the run's single timeline, and its own wall-clock duration. The
footer line sums the tallies and names the run's total wall clock — the parallel phases mean the
workers' durations add up to more than the run took, so the summation is printed as its own row rather
than implied.
```

## comment:2

Section `.PARAMETER WorkerSummaries` of the comment-based help.

```text
The per-worker summary objects from Invoke-TestAutomationWorkers (QueueNumber, Label, Files, Tests,
Passed, Failed, Skipped, StartSeconds, DurationSeconds).
```
