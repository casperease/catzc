---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/tests/types/RainbowColor.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8ff12bad41dd"
    adrs:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/tests/types/RainbowColor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'RainbowColor' -Tag 'L0', 'logic' {`, written with `#`.

```text
The <base>-rainbow colour profile
([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)): char 0 is
the anchor, the walk steps a chromatic-only
ring (legible on a dark ground), and the profile side-grades to its base ConsoleColor.
```
