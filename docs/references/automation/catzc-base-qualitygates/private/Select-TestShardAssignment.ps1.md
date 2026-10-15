---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Select-TestShardAssignment.ps1.md
    kind: comment-page
    body_sha: "80c52a667c8e"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Select-TestShardAssignment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A phase lasts as long as its slowest shard, so the files are dealt longest first, each to the shard with the least
work so far (longest-processing-time first). A file's work is its duration from the last run that ran it
(Get-TestDurationHistory); a file without one counts as the median of the known durations, or 1 s when nothing is
known yet, so a first run is a fair even split. Ties keep the files' given order, so the result is deterministic.
```
