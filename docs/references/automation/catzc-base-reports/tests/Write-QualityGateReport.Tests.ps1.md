---
catzc:
  immutable:
    with_body_sha: "901c41229511"
    repo_status: locked
    path: docs/references/automation/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md
    folder: docs/references/automation/catzc-base-reports/tests
    name: write-quality-gate-report-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,35}
---

# automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Write-QualityGateReport' -Tag 'L0', 'logic' {`, written with `#`.

```text
Write-QualityGateReport is every quality gate's output. The settings come from the real ReportsConfig type over a
mocked reports config, and the report goes to $TestDrive, so each test pins one part of the uniform shape
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Neutral fixture subjects
(widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
