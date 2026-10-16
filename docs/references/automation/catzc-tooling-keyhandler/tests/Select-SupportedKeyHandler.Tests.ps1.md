---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "357bdd78420d"
    adrs:
      - ADR-AUTO-TEST#{3,22}
---

# automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Select-SupportedKeyHandler' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#22' {`, written with `#`.

```text
Neutral fixture function names (widget/gadget) — Select-SupportedKeyHandler is pure classification logic,
so a logic fixture must not borrow real PSReadLine function names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
