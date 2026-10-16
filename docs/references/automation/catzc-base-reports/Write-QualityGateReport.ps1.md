---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/Write-QualityGateReport.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: af46afce2597
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Base.Reports/Write-QualityGateReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (-not $OutputFolder) {`, written with `#`.

```text
A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
an explicit empty argument would override a declared default
([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```
