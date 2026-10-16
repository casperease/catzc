---
catzc:
  immutable:
    with_body_sha: "452e168524eb"
    path: docs/references/automation/catzc-base-writers/tests/types/Ansi.Tests.ps1.md
    folder: docs/references/automation/catzc-base-writers/tests/types
    name: ansi-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/tests/types/Ansi.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Ansi' -Tag 'L0', 'logic' {`, written with `#`.

```text
The single ConsoleColor -> ANSI SGR map
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)): the escape
codes Write-InformationColored and
RainbowColor both resolve through, asserted in one place so the two can never disagree.
```
