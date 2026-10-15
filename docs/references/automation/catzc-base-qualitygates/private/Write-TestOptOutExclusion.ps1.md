---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestOptOutExclusion.ps1.md
    kind: reference
    body_sha: e080489d12ed
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The build run never drops a test silently: every test it leaves out by its opt-out tag ('source-only') is
counted and listed on the console, grouped by file (repository-relative), and written to
excluded-tests.csv in the run directory (File, ExpandedPath, Level, Category) beside tests.csv. Nothing to
exclude still prints its one-line count, so a reader sees the exclusion was considered.
```
