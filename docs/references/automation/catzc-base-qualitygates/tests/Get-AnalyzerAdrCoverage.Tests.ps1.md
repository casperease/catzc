---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md
    kind: test-asset
    body_sha: dd1ec506b4a1
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'analyzer-adr-map integrity' -Tag 'L1', 'integrity', 'source-only',...`.

```text
source-only: it cross-checks the map against the repository's ADR tree and .scriptanalyzer rule files, which
gives the same answer in both run modes. The check is the quality gate Test-AnalyzerAdrMap
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
