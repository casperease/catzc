---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/tests/types/Ansi.Tests.ps1.md
    kind: test-asset
    body_sha: c7710cae9ff5
    adrs:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/tests/types/Ansi.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Ansi' -Tag 'L0', 'logic' {`.

```text
The single ConsoleColor -> ANSI SGR map
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)): the escape
codes Write-InformationColored and
RainbowColor both resolve through, asserted in one place so the two can never disagree.
```
