---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-ReportModeFinding.ps1.md
    kind: comment-page
    body_sha: "690e5a46ca77"
    adrs:
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.QualityGates/private/Write-ReportModeFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one way a gate shows a check whose config sets mode: report (Catzc.Base.QualityGates.SourceCheck,
[ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)): the check's findings
are its work list, printed with the check's name so a reader can tell them from the gate's issues, and they are
never passed to Write-QualityGateReport as issues. Nothing is printed when the check found nothing.
```
