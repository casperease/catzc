---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md
    kind: comment-page
    body_sha: "3f4fbef26384"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SyntaxSearch' -Tag 'L0', 'logic' {`, written with `#`.

```text
The compiled searches return what a PowerShell predicate over FindAll returned. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
