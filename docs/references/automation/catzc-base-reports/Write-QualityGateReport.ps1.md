---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/Write-QualityGateReport.ps1.md
    kind: comment-page
    body_sha: "5638f338e042"
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Base.Reports/Write-QualityGateReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if (-not $OutputFolder) {`.

```text
A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
an explicit empty argument would override a declared default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```
