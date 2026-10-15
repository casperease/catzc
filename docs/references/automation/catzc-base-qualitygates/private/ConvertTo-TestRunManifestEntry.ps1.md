---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/ConvertTo-TestRunManifestEntry.ps1.md
    kind: reference
    body_sha: "26bc716e7a03"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/ConvertTo-TestRunManifestEntry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The part of a run's terminal manifest (Write-TestRunManifest) that only the worker run knows: each shard's
exit code, the wall-clock duration, and where the run executed — `location` plus, for a snapshot, its
provenance (Get-TestRunLocationSummary). A run that crashed before its workers returned has no worker run;
it records no exit codes, a zero duration, and no location.
```
