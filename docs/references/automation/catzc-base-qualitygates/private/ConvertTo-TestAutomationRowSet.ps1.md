---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/ConvertTo-TestAutomationRowSet.ps1.md
    kind: comment-page
    body_sha: ab6818d404de
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/ConvertTo-TestAutomationRowSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Tier/category resolution walks a test's live .Block chain (Get-TestLevelTag / Get-TestCategoryTag), which
does not survive serialization — so a parallel worker reduces its own result to these rows before exiting,
and the parent aggregates the rows (JSON sidecars) from every shard. The row set is the one shape the run
reports consume: tests.csv/summary.md (Write-TestAutomationReport), the over-limit timing check, and the
skip report (Write-TestAutomationSkipReport) all read rows, never a Pester object across a boundary.
Emits one row per discovered test, in Pester's order, including Skipped and NotRun tests.
```
