---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Save-TestDurationHistory.ps1.md
    kind: reference
    body_sha: "7025dcf90e2a"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Save-TestDurationHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each file the run measured replaces its entry; files the run did not run keep theirs, so a partial run (one
module, one tier) never forgets the rest. The file is written sorted by path, so it diffs cleanly, and written
only after the run's own results are safe, so a crash cannot corrupt it. See Get-TestDurationHistory.
```
