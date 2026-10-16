---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: invoke-dotnet-format-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b38164b72e0d
    adrs:
      - ADR-AUTO-TEST#{3,6}
---

# automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-DotnetFormat' -Tag 'L0', 'logic' {`, written with `#`.

```text
The dotnet-format engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
the mock answers like `dotnet format whitespace --verify-no-changes --report`, writing the JSON report the engine
reads. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
