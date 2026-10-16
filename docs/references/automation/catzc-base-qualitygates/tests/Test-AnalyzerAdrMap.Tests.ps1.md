---
catzc:
  immutable:
    with_body_sha: "1c2a076698f9"
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-analyzer-adr-map-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AnalyzerAdrMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-AnalyzerAdrMap over a mocked map, a mocked ADR rule-id set, and fixture rule files in $TestDrive. Neutral
fixture names and rule codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
