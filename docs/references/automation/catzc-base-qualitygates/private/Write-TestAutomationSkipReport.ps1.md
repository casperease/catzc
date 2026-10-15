---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md
    kind: comment-page
    body_sha: "62c2d6d0993d"
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationSkipReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if ($skipped.Count -gt 0) {`.

```text
Skipped — actively skipped during the run, each with the reason from Set-ItResult -Because (an `It
-Skip` carries none). Listed individually: a self-skip naming the missing tool is the whole value.
```

## comment:6

Above `if ($notRun.Count -gt 0) {`.

```text
Not run — excluded by this run's tier/category scope, never executed. Grouped by tier+category with
counts so the breakdown shows exactly what a wider -Level/-Category would add, without 90+ lines.
```
