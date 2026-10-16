---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fe00a5aa2d65
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-FormatEngineStamp' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {`, written with `#`.

```text
Get-FormatEngineStamp over fixture files in $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
