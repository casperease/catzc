---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md
    kind: test-asset
    body_sha: "3a97960579e2"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Write-QualityGateReport' -Tag 'L0', 'logic' {`.

```text
Write-QualityGateReport is every quality gate's output. The settings come from the real ReportsConfig type over a
mocked reports config, and the report goes to $TestDrive, so each test pins one part of the uniform shape
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Neutral fixture subjects
(widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
