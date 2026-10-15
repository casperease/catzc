---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md
    kind: test-asset
    body_sha: "26c6da3a4027"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
The report renders the records it is given as one plain table through Write-Message -NoHeader. Fixture
tokens are neutral ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
