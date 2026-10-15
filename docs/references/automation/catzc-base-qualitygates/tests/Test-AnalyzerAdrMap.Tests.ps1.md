---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md
    kind: test-asset
    body_sha: a07cdf6a4787
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AnalyzerAdrMap' -Tag 'L0', 'logic' {`.

```text
Test-AnalyzerAdrMap over a mocked map, a mocked ADR rule-id set, and fixture rule files in $TestDrive. Neutral
fixture names and rule codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
