---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md
    kind: test-asset
    body_sha: "013cb595b20e"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'SyntaxSearch' -Tag 'L0', 'logic' {`.

```text
The compiled searches return what a PowerShell predicate over FindAll returned. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
