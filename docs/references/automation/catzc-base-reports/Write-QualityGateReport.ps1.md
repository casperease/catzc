---
catzc:
  immutable:
    with_body_sha: af46afce2597
    repo_status: locked
    path: docs/references/automation/catzc-base-reports/Write-QualityGateReport.ps1.md
    folder: docs/references/automation/catzc-base-reports
    name: write-quality-gate-report-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
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
