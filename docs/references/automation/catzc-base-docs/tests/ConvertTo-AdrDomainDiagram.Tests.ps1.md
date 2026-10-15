---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md
    kind: test-asset
    body_sha: "9467cd470d9e"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ConvertTo-AdrDomainDiagram' -Tag 'L0', 'logic' {`.

```text
ConvertTo-AdrDomainDiagram — a pure renderer, fed fixture edges and a fixture AdrsConfig for the node roles
(Get-Config mocked). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
