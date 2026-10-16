---
catzc:
  immutable:
    with_body_sha: d5abb94987b3
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-analyzer-adr-coverage-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'analyzer-adr-map integrity' -Tag 'L1', 'integrity', 'source-only',...`, written with `#`.

```text
source-only: it cross-checks the map against the repository's ADR tree and .scriptanalyzer rule files, which
gives the same answer in both run modes. The check is the quality gate Test-AnalyzerAdrMap
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
