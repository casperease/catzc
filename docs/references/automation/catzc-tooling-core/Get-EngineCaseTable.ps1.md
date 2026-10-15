---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-EngineCaseTable.ps1.md
    kind: comment-page
    body_sha: cf91e45f0ed7
    adrs:
      - ADR-AUTO-ENGINE#1
---

# automation/Catzc.Tooling.Core/Get-EngineCaseTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($Engine) {`.

```text
The engines are declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): Get throws, naming them,
for any other name.
```
