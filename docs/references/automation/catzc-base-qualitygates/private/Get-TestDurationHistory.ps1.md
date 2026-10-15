---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestDurationHistory.ps1.md
    kind: comment-page
    body_sha: "308144f5ca29"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestDurationHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The history is a per-machine file, durations.json, beside the run folders under out/ (gitignored, never
committed): repository-relative '/'-separated test file path -> milliseconds, the file's whole Pester duration
including its set-up. Select-TestShardAssignment schedules from it. A missing or unreadable history is an empty
one: the run falls back to an even split and writes a fresh history at its end.
```
