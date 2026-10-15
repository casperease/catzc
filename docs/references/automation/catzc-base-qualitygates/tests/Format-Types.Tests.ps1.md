---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md
    kind: test-asset
    body_sha: "9f6381e94bcb"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Format-Types' -Tag 'L0', 'logic' {`.

```text
Format-Types maintains each C# type source's file-scoped namespace from its module folder; its -DryRun is the C#
part of Test-Formatting ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
A fixture tree in $TestDrive stands in for the repository (neutral widget/gadget names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the real tree is checked by the
formatting integrity test in Test-Formatting.Tests.ps1.
```
