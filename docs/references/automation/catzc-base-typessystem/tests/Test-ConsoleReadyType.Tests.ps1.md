---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md
    kind: test-asset
    body_sha: "9607a1b9baf1"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ConsoleReadyType' -Tag 'L0', 'logic' {`.

```text
Test-ConsoleReadyType — whether a shipped type renders as a readable line in pwsh: it overrides ToString(), or it is
a kind never held as a value. Probed with BCL types and Add-Type probes. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
