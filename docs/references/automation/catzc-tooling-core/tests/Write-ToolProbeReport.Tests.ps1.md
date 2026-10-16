---
catzc:
  immutable:
    with_body_sha: "6a3a675c713e"
    path: docs/references/automation/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-core/tests
    name: write-tool-probe-report-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
The report renders the records it is given as one plain table through Write-Message -NoHeader. Fixture
tokens are neutral ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
