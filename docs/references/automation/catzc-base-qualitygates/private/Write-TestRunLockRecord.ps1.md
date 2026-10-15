---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestRunLockRecord.ps1.md
    kind: comment-page
    body_sha: "2618a444c682"
---

# automation/Catzc.Base.QualityGates/private/Write-TestRunLockRecord.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A lock (the working folder's, Enter-TestRunLocation; the user's system-test lock, Enter-SystemTestLock) says only
that it is held; the record beside it says by whom, so a run that finds the lock held can name the holder
(Get-TestRunLockHolder) instead of guessing. The record carries the holder's pid and process start time (a
reused pid is told apart), the entry point, when it started, its run folder and its working folder. The write
is atomic — a temp file moved over the record — so a reader never sees half of it.
```
