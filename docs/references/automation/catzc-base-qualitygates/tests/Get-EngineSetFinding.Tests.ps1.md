---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-EngineSetFinding.Tests.ps1.md
    kind: test-asset
    body_sha: "436d1fb35005"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-EngineSetFinding' -Tag 'L0', 'logic' {`.

```text
Get-EngineSetFinding over fixture texts, with a fixture engine set — widget, gadget and sprocket stand in for the
model's engines ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)), so the finder is
proven to read the names and their count from its caller, never from a literal of its own.
```
