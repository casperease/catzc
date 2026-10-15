---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md
    kind: test-asset
    body_sha: b1aa17b8c46e
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-DotnetFormat' -Tag 'L0', 'logic' {`.

```text
The dotnet-format engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
the mock answers like `dotnet format whitespace --verify-no-changes --report`, writing the JSON report the engine
reads. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
