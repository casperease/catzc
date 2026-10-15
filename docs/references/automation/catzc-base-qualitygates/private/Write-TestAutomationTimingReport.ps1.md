---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationTimingReport.ps1.md
    kind: comment-page
    body_sha: "5a6d6668bde1"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationTimingReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Validates the run's rows against the per-level time limits (Get-TestTimingViolation owns the per-row
check) and, when any test is over, writes the framed report — red and run-failing under
-EnforceTimings, yellow and report-only otherwise (timings are machine-dependent, so enforcement is
the caller's opt-in). Silent when nothing is over.
```
