---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md
    kind: comment-page
    body_sha: ca07ba6801b5
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationSkipReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($skipped.Count -gt 0) {`, written with `#`.

```text
Skipped — actively skipped during the run, each with the reason from Set-ItResult -Because (an `It
-Skip` carries none). Listed individually: a self-skip naming the missing tool is the whole value.
```

## comment:2

Above `if ($notRun.Count -gt 0) {`, written with `#`.

```text
Not run — excluded by this run's tier/category scope, never executed. Grouped by tier+category with
counts so the breakdown shows exactly what a wider -Level/-Category would add, without 90+ lines.
```
