---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d3867880b6d2
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter',...`, written with `#`.

```text
Measure-QualityGates over fixture quality gates: the real Get-Command lookup and the -OutputFolder probe decide each call; the
timing itself is only read for its order. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
