---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md
    kind: test-asset
    body_sha: a577a9d3ba44
    adrs:
      - ADR-AUTO-TEST#22
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Select-SupportedKeyHandler' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#22' {`.

```text
Neutral fixture function names (widget/gadget) — Select-SupportedKeyHandler is pure classification logic,
so a logic fixture must not borrow real PSReadLine function names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
