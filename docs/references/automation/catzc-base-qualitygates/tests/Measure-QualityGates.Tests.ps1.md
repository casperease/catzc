---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md
    kind: test-asset
    body_sha: ccdb96f3b9e9
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter',...`.

```text
Measure-QualityGates over fixture quality gates: the real Get-Command lookup and the -OutputFolder probe decide each call; the
timing itself is only read for its order. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
