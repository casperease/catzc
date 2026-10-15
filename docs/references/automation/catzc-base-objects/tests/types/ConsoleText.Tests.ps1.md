---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
    kind: test-asset
    body_sha: "3afcff75a698"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ConsoleText' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {`.

```text
ConsoleText — the shared console rendering behind every catzc type's ToString(), so an object held in pwsh reads
as one line in "$x", [string]$x and a table cell. Exercised through probe types compiled by Add-Type against the
loaded combined assembly. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
